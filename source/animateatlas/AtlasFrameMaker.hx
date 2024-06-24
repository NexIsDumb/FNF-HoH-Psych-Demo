package animateatlas;

import flixel.util.FlxDestroyUtil;
import openfl.geom.Rectangle;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import openfl.Assets;
import openfl.display.BitmapData;
import animateatlas.JSONData.AtlasData;
import animateatlas.JSONData.AnimationData;
import animateatlas.displayobject.SpriteAnimationLibrary;
import animateatlas.displayobject.SpriteMovieClip;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.frames.FlxFrame;
import openfl.display3D.textures.RectangleTexture;

class AtlasFrameMaker extends FlxFramesCollection {
	/**

		* Creates Frames from TextureAtlas(very early and broken ok) Originally made for FNF HD by Smokey and Rozebud
		*
		* @param   key                 The file path.
		* @param   _excludeArray       Use this to only create selected animations. Keep null to create all of them.
		*
	 */
	public static function construct(key:String, ?_excludeArray:Array<String> = null, ?noAntialiasing:Bool = false):FlxFramesCollection {
		// widthoffset = _widthoffset;
		// heightoffset = _heightoffset;

		var frameCollection:FlxFramesCollection;
		var frameArray:Array<Array<FlxFrame>> = [];

		if (Paths.fileExists('images/$key/spritemap1.json', TEXT)) {
			PlayState.instance.addTextToDebug("Only Spritemaps made with Adobe Animate 2018 are supported", FlxColor.RED);
			trace("Only Spritemaps made with Adobe Animate 2018 are supported");
			return null;
		}

		var animationData:AnimationData = Json.parse(Paths.getTextFromFile('images/$key/Animation.json'));

		// @:formatter off
		var atlasData:AtlasData = Json.parse(Paths.getTextFromFile('images/$key/spritemap.json').replace("\u{FEFF}", ""));
		// @:formatter on

		var graphic:FlxGraphic = getFlxGraphic('$key/spritemap');
		// var graphic:FlxGraphic = Paths.image('$key/spritemap');

		var ss:SpriteAnimationLibrary = new SpriteAnimationLibrary(animationData, atlasData, graphic.bitmap);
		var t:SpriteMovieClip = ss.createAnimation(noAntialiasing);
		if (_excludeArray == null) {
			_excludeArray = t.getFrameLabels();
			// trace('creating all anims');
		}
		trace('Creating: ' + _excludeArray);

		frameCollection = new FlxFramesCollection(graphic, FlxFrameCollectionType.IMAGE);
		for (x in _excludeArray) {
			frameArray.push(getFramesArray(t, x));
		}

		for (x in frameArray) {
			for (y in x) {
				frameCollection.pushFrame(y);
			}
		}

		// clear memory
		graphic.bitmap.dispose();
		graphic.bitmap.disposeImage();
		graphic.destroy();
		return frameCollection;
	}

	static function getFlxGraphic(key:String):FlxGraphic {
		/*var bitmap:BitmapData = null;
			var file:String = null;

			#if MODS_ALLOWED
			file = Paths.modsImages(key);
			if (FileSystem.exists(file))
				bitmap = BitmapData.fromFile(file);
			else
			#end
			{
				file = Paths.getPath('images/$key.png', IMAGE);
				if (Assets.exists(file, IMAGE))
					bitmap = Assets.getBitmapData(file);
			}

			if (bitmap != null)
				return FlxGraphic.fromBitmapData(bitmap, false, file); */

		return Paths.image(key);
	}

	static function getFramesArray(t:SpriteMovieClip, animation:String):Array<FlxFrame> {
		var sizeInfo:Rectangle = new Rectangle(0, 0);
		t.currentLabel = animation;
		var bitMapArray:Array<BitmapData> = [];
		var daFramez:Array<FlxFrame> = [];
		var firstPass = true;
		var frameSize:FlxPoint = new FlxPoint(0, 0);

		for (i in (t.getFrame(animation))...(t.numFrames)) {
			t.currentFrame = i;
			if (t.currentLabel == animation) {
				sizeInfo = t.getBounds(t);
				var bitmapShit:BitmapData = new BitmapData(Std.int(sizeInfo.width + sizeInfo.x), Std.int(sizeInfo.height + sizeInfo.y), true, 0);
				if (ClientPrefs.data.cacheOnGPU) {
					var texture:RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmapShit.width, bitmapShit.height, BGRA, true);
					texture.uploadFromBitmapData(bitmapShit);
					bitmapShit.image.data = null;
					bitmapShit.dispose();
					bitmapShit.disposeImage();
					bitmapShit = BitmapData.fromTexture(texture);
				}
				bitmapShit.draw(t, null, null, null, null, true);
				bitMapArray.push(bitmapShit);

				if (firstPass) {
					frameSize.set(bitmapShit.width, bitmapShit.height);
					firstPass = false;
				}
				continue;
			}
			break;
		}

		for (i in 0...bitMapArray.length) {
			var b = FlxGraphic.fromBitmapData(bitMapArray[i]);
			var theFrame = new FlxFrame(b);
			theFrame.parent = b;
			theFrame.name = animation + i;
			theFrame.sourceSize.set(frameSize.x, frameSize.y);
			theFrame.frame = new FlxRect(0, 0, bitMapArray[i].width, bitMapArray[i].height);
			daFramez.push(theFrame);
		}
		return daFramez;
	}
}
