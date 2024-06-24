package backend;

import openfl.utils.Assets;
import backend.Song;

typedef StageFile = {
	var directory:String;
	var defaultZoom:Float;
	var stageUI:String;

	var boyfriend:Array<Float>;
	var girlfriend:Array<Float>;
	var opponent:Array<Float>;
	var hide_girlfriend:Bool;

	var camera_boyfriend:Array<Float>;
	var camera_opponent:Array<Float>;
	var camera_girlfriend:Array<Float>;
	var camera_speed:Null<Float>;
}

class StageData {
	public static function dummy():StageFile {
		return {
			directory: "",
			defaultZoom: 0.9,
			stageUI: "normal",

			boyfriend: [770, 100],
			girlfriend: [400, 130],
			opponent: [100, 100],
			hide_girlfriend: false,

			camera_boyfriend: [0, 0],
			camera_opponent: [0, 0],
			camera_girlfriend: [0, 0],
			camera_speed: 1
		};
	}

	public static var forceNextDirectory:String = null;

	public static function loadDirectory(SONG:SwagSong) {
		var stage:String = '';
		if (SONG.stage != null) {
			stage = SONG.stage;
		} else if (SONG.song != null) {
			stage = vanillaSongStage(SONG.song);
		} else {
			stage = 'stage';
		}

		var stageFile:StageFile = getStageFile(stage);
		if (stageFile == null) { // preventing crashes
			forceNextDirectory = '';
		} else {
			forceNextDirectory = stageFile.directory;
		}
	}

	public static function getStageFile(stage:String):StageFile {
		var rawJson:String = null;

		#if MODS_ALLOWED
		var modPath:String = Paths.modFolders('stages/' + stage + '.json');
		if (FileSystem.exists(modPath))
			rawJson = File.getContent(modPath);
		#end

		var path:String = Paths.getPreloadPath('stages/' + stage + '.json');

		#if sys
		if (rawJson == null && FileSystem.exists(path))
			rawJson = File.getContent(path);
		#end

		if (rawJson == null && Assets.exists(path, TEXT))
			rawJson = Assets.getText(path);

		if (rawJson == null)
			return null;

		return cast Json.parse(rawJson);
	}

	public static function vanillaSongStage(songName:String):String {
		// songName = Paths.formatToSongPath(songName);
		// switch (songName) {}
		return 'stage';
	}
}
