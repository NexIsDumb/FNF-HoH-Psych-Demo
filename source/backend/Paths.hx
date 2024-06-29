package backend;

import backend.native.Utils;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.system.System;
import lime.utils.Assets;
import openfl.media.Sound;
#if MODS_ALLOWED
import backend.Mods;
#end

class Paths {
	public inline static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> = [
		'assets/music/freakyMenu.${Constants.SOUND_EXT}',
		'assets/shared/music/breakfast.${Constants.SOUND_EXT}',
		'assets/shared/music/tea-time.${Constants.SOUND_EXT}',
	];

	/// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory() {
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys()) {
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key)) {
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null) {
					// remove the key from all cache maps
					FlxG.bitmap._cache.remove(key);
					openfl.Assets.cache.removeBitmapData(key);
					currentTrackedAssets.remove(key);

					// and get rid of the object
					obj.persist = false; // make sure the garbage collector actually clears it up
					obj.destroyOnNoUse = true;
					obj.destroy();
				}
			}
		}

		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];

	public static function clearStoredMemory(?cleanUnused:Bool = false) {
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys()) {
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key)) {
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		// clear all sounds that are cached
		for (key in currentTrackedSounds.keys()) {
			if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && key != null) {
				// trace('test: ' + dumpExclusions, key);
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		#if !html5 openfl.Assets.cache.clear("songs"); #end
	}

	public static var currentLevel:String;

	public inline static function setCurrentLevel(name:String) {
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, ?type:AssetType = TEXT, ?library:Null<String> = null, ?modsAllowed:Bool = false):String {
		#if MODS_ALLOWED
		if (modsAllowed) {
			var modded:String = modFolders(file);
			if (FileSystem.exists(modded))
				return modded;
		}
		#end

		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null) {
			var levelPath:String = '';
			levelPath = getLibraryPathForce(file, "shared");
			if (fileExistsDirect(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	public static function getLibraryPath(file:String, library:String) {
		return (library == "preload" || library == "default") ? getPreloadPath(file) : getLibraryPathForce(file, library);
	}

	private inline static function getLibraryPathForce(file:String, library:String, ?level:String) {
		if (level == null)
			level = library;
		return '$library:assets/$level/$file';
	}

	public inline static function getPreloadPath(file:String = '') {
		return 'assets/$file';
	}

	public inline static function txt(key:String, ?library:String) {
		return getPath('data/$key.txt', TEXT, library);
	}

	public inline static function xml(key:String, ?library:String) {
		return getPath('data/$key.xml', TEXT, library);
	}

	public inline static function json(key:String, ?library:String) {
		return getPath('data/$key.json', TEXT, library);
	}

	public inline static function shaderFragment(key:String, ?library:String) {
		return getPath('shaders/$key.frag', TEXT, library);
	}

	public inline static function shaderVertex(key:String, ?library:String) {
		return getPath('shaders/$key.vert', TEXT, library);
	}

	public inline static function lua(key:String, ?library:String) {
		return getPath('$key.lua', TEXT, library);
	}

	public inline static function video(key:String) {
		// TODO: fix this
		#if MODS_ALLOWED
		var file:String = modsVideo(key);
		if (FileSystem.exists(file)) {
			return file;
		}
		#end
		return 'assets/videos/$key.${Constants.VIDEO_EXT}';
	}

	public inline static function sound(key:String, ?library:String):Sound {
		return returnSound('sounds', key, library);
	}

	public inline static function soundRandom(key:String, min:Int, max:Int, ?library:String) {
		return sound(key + FlxG.random.int(min, max), library);
	}

	public inline static function music(key:String, ?library:String):Sound {
		return returnSound('music', key, library);
	}

	public inline static function voices(song:String):#if html5 String #else Sound #end {
		#if html5
		return 'songs:assets/songs/${formatToSongPath(song)}/Voices.${Constants.SOUND_EXT}';
		#else
		var songKey:String = '${formatToSongPath(song)}/Voices';
		return returnSound('songs', songKey);
		#end
	}

	public inline static function inst(song:String):#if html5 String #else Sound #end {
		#if html5
		return 'songs:assets/songs/${formatToSongPath(song)}/Inst.${Constants.SOUND_EXT}';
		#else
		var songKey:String = '${formatToSongPath(song)}/Inst';
		return returnSound('songs', songKey);
		#end
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

	public static function image(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxGraphic {
		var bitmap:BitmapData = null;
		var file:String = getPath('images/$key.png', IMAGE, library);

		if (currentTrackedAssets.exists(file)) {
			localTrackedAssets.push(file);
			return currentTrackedAssets.get(file);
		}

		#if debug
		trace(file);
		#end
		#if sys
		if (FileSystem.exists(file))
			bitmap = BitmapData.fromFile(Utils.removeLibraryPath(file));
		#end

		#if !sys
		if (bitmap == null && OpenFlAssets.exists(file, IMAGE))
			bitmap = OpenFlAssets.getBitmapData(file);
		#end

		if (bitmap != null) {
			localTrackedAssets.push(file);
			if (allowGPU && ClientPrefs.data != null && ClientPrefs.data.cacheOnGPU) {
				var texture:RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmap.width, bitmap.height, BGRA, true);
				texture.uploadFromBitmapData(bitmap);
				bitmap.image.data = null;
				bitmap.dispose();
				bitmap.disposeImage();
				bitmap = BitmapData.fromTexture(texture);
			}
			var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, file);
			newGraphic.persist = true;
			newGraphic.destroyOnNoUse = false;
			currentTrackedAssets.set(file, newGraphic);
			return newGraphic;
		}
		trace("Bitmap is null", file);
		return null;
	}

	public static function getContent(key:String, library:String = null, ?ignoreMods:Bool = false):String {
		var path:String = getPath(key, TEXT, library, ignoreMods);
		#if sys
		if (FileSystem.exists(path))
			return File.getContent(path);
		#end
		#if !sys
		if (OpenFlAssets.exists(path, TEXT))
			return Assets.getText(path);
		#end
		return null;
	}

	public static function getTextFromFile(key:String, ?ignoreMods:Bool = false):String {
		var path:String = getPath(key, TEXT, null, ignoreMods);
		#if sys
		if (FileSystem.exists(path))
			return File.getContent(path);
		#end
		#if !sys
		if (OpenFlAssets.exists(path, TEXT))
			return Assets.getText(path);
		#end
		return null;
	}

	public inline static function font(key:String) {
		#if MODS_ALLOWED
		var file:String = modsFont(key);
		if (FileSystem.exists(file))
			return file;
		#end
		return 'assets/fonts/$key';
	}

	public inline static function fileExistsDirect(path:String, type:AssetType) {
		#if sys
		if (FileSystem.exists(path))
			return true;
		#end
		#if !sys
		if (OpenFlAssets.exists(path, type))
			return true;
		#end
		return false;
	}

	public inline static function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String = null) {
		var path:String = getPath(key, type, library, ignoreMods);

		return fileExistsDirect(path, type);
	}

	// less optimized but automatic handling
	public static function getAtlas(key:String, ?library:String = null):FlxAtlasFrames {
		var path = getPath('images/$key.xml', library);
		if (fileExistsDirect(path, TEXT))
			return getSparrowAtlas(key, library);

		return getPackerAtlas(key, library);
	}

	public static function getSparrowAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames {
		var image:FlxGraphic = image(key, library, allowGPU);
		var xmlPath:String = getPath('images/$key.xml', library);
		var data:String = null;

		#if sys
		if (FileSystem.exists(xmlPath))
			data = File.getContent(xmlPath);
		#end
		#if !sys
		if (data == null)
			data = Assets.getText(xmlPath);
		#end

		return FlxAtlasFrames.fromSparrow(image, data);
	}

	public static function getPackerAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames {
		var image:FlxGraphic = image(key, library, allowGPU);
		var txtPath:String = getPath('images/$key.txt', library);

		var data:String = null;
		#if sys
		if (FileSystem.exists(txtPath))
			data = File.getContent(txtPath);
		#end
		#if !sys
		if (data == null)
			data = Assets.getText(txtPath);
		#end

		return FlxAtlasFrames.fromSpriteSheetPacker(image, data);
	}

	public inline static function formatToSongPath(path:String) {
		return path.replace(' ', '-').toLowerCase();
		// slow code below, but we dont need it
		/*
			var invalidChars = ~/[~&\\;:<>#]/;
			var hideChars = ~/[.,'"%?!]/;

			var path = invalidChars.split(path.replace(' ', '-')).join("-");
			return hideChars.split(path).join("").toLowerCase();
		 */
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];

	public static function returnSound(path:String, key:String, ?library:String) {
		#if MODS_ALLOWED
		var file:String = modsSounds(path, key);
		if (FileSystem.exists(file)) {
			if (!currentTrackedSounds.exists(file)) {
				currentTrackedSounds.set(file, Sound.fromFile(file));
			}
			localTrackedAssets.push(key);
			return currentTrackedSounds.get(file);
		}
		#end
		// I hate this so god damn much
		var libPath:String = getPath('$path/$key.${Constants.SOUND_EXT}', SOUND, library);
		var filePath = backend.native.Utils.removeLibraryPath(libPath);
		// trace(libPath);
		if (!currentTrackedSounds.exists(filePath)) {
			var snd:Sound = null;
			#if sys
			if (FileSystem.exists(filePath))
				snd = Sound.fromFile('./' + filePath);
			#end
			#if !sys
			if (snd == null)
				snd = OpenFlAssets.getSound(libPath);
			#end
			if (snd == null)
				FlxG.log.warn("[SOUND] Sound " + libPath + " not found");
			currentTrackedSounds.set(filePath, snd);
		}
		localTrackedAssets.push(filePath);
		return currentTrackedSounds.get(filePath);
	}

	inline static public function transMainFolder(key:String = '') {
		return 'assets/translations/' + key;
	}

	#if MODS_ALLOWED
	public inline static function mods(key:String = '') {
		return 'mods/' + key;
	}

	public inline static function modsFont(key:String) {
		return modFolders('fonts/' + key);
	}

	public inline static function modsJson(key:String) {
		return modFolders('data/' + key + '.json');
	}

	public inline static function modsVideo(key:String) {
		return modFolders('videos/' + key + '.' + Constants.VIDEO_EXT);
	}

	public inline static function modsSounds(path:String, key:String) {
		return modFolders(path + '/' + key + '.' + Constants.SOUND_EXT);
	}

	public inline static function modsImages(key:String) {
		return modFolders('images/' + key + '.png');
	}

	public inline static function modsXml(key:String) {
		return modFolders('images/' + key + '.xml');
	}

	public inline static function modsTxt(key:String) {
		return modFolders('images/' + key + '.txt');
	}

	public static function modFolders(key:String) {
		if (Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0) {
			var fileToCheck:String = mods(Mods.currentModDirectory + '/' + key);
			if (FileSystem.exists(fileToCheck)) {
				return fileToCheck;
			}
		}

		for (mod in Mods.getGlobalMods()) {
			var fileToCheck:String = mods(mod + '/' + key);
			if (FileSystem.exists(fileToCheck))
				return fileToCheck;
		}
		return 'mods/' + key;
	}
	#end
}
