package states.debug;

import backend.WeekData;
import backend.Song;
import haxe.io.Path;
import lime.ui.KeyModifier;
import lime.ui.KeyCode;

using StringTools;

class DebugSongSelect extends DebugBaseSelect {
	var songsInPath:Array<String> = [];

	override function create() {
		var path = "assets/songs/";
		if (Sys.args().contains("-livereload")) { // lime test
			path = Main.pathBack + "/assets/songs/";
		}
		path = Path.normalize(path);
		trace("Loading songs from " + path);
		songsInPath = FileSystem.readDirectory(path).filter(function(song) return !song.endsWith(".DS_Store"));

		WeekData.reloadWeekFiles(false);
		super.create();
	}

	override function generateBaseItems() {
		itemsTxt = generateItems(songsInPath);
	}

	override function onKeyDown(e:KeyCode, modifier:KeyModifier) {
		if (inDiffselect)
			return;
		super.onKeyDown(e, modifier);
	}

	override function onTextInput(text:String) {
		if (inDiffselect)
			return;
		super.onTextInput(text);
	}

	override function onTextEdit(text:String, start:Int, end:Int) {
		if (inDiffselect)
			return;
		super.onTextEdit(text, start, end);
	}

	override function acceptSelection() {
		if (!inDiffselect) {
			var item = itemsTxt[curSelected];
			var diffs = getDifficultiesForSong(item.buttonText);
			selectedSong = item.buttonText;

			if (diffs.length > 0) {
				inDiffselect = true;
				curSelected = 0;
				searchText = "";
				searchTxt.text = "Select Difficulty for " + selectedSong;
				itemsTxt = generateItems(diffs);
				updatePosAndNodes();
			} else {
				showMessage('No difficulties found for chart', 1);
			}
		} else if (inDiffselect) {
			var diff = itemsTxt[curSelected % Difficulty.list.length];
			var song = selectedSong;
			var diffTxt = diff.text;

			var diffPath:String = '-${diffTxt.toLowerCase().replace(' ', '-')}';
			if (diffPath == '-normal') {
				diffPath = ''; // Normal difficulty uses no suffix
			}

			PlayState.SONG = Song.loadFromJson(song + diffPath, song);
			PlayState.isStoryMode = Std.int(curSelected / Difficulty.list.length) >= 1;
			PlayState.storyDifficulty = Difficulty.getByName(diffTxt);
			trace('Playing ' + song + ' ' + diffTxt + " (" + PlayState.storyDifficulty + " | " + Difficulty.getString().toUpperCase() + ")");
			exiting = true;
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	override function back() {
		if (controls.BACK && inDiffselect) {
			inDiffselect = false;
			itemsTxt = generateItems(songsInPath);
			curSelected = 0;
			searchText = "";
			searchTxt.text = "";
			updatePosAndNodes();
		}
	}

	var inDiffselect = false;
	var selectedSong = "";

	function getDifficultiesForSong(song:String):Array<String> {
		var diffs:Array<String> = [];
		for (difficulty in Difficulty.defaultList) {
			var diffPath:String = '-${difficulty.toLowerCase().replace(' ', '-')}';
			if (diffPath == '-normal') {
				diffPath = ''; // Normal difficulty uses no suffix
			}

			if (Song.doesChartExist(song + diffPath, song)) {
				diffs.push(difficulty);
			}
		}
		Difficulty.list = diffs.copy();
		diffs.reverse();
		var copy = diffs.copy();
		for (diff in copy) {
			diffs.push(diff + " (Story)");
		}
		return diffs;
	}
}
