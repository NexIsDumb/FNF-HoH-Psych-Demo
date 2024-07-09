package states.debug;

import backend.WeekData;
import backend.Song;
import haxe.io.Path;
import lime.ui.KeyModifier;
import lime.ui.KeyCode;

using StringTools;

class DebugSaveEditor extends DebugBaseSelect {
	var songsInPath:Array<String> = [];

	override function create() {
		allowSearch = false;
		super.create();
	}

	override function getVisualName(name:String):String {
		switch (name) {
			case "geo": return "Geo: " + DataSaver.geo;
			case "charms": return "Equipped Charms: " + [for (c => u in DataSaver.charms) if (u) c].join(", ");
			case "charmsunlocked": return "Unlocked Charms: " + [for (c => u in DataSaver.charmsunlocked) if (u) c].join(", ");
			case "interacts": return "Interactions: " + DataSaver.interacts.map((i) -> i ? "T" : "F").join("");
			case "songScores": return "Song Scores";
			case "weekScores": return "Week Scores";
			case "songRating": return "Song Rating";
			case "unlocked": return "Unlocked Data";
		}
		return name;
	}

	override function generateBaseItems() {
		itemsTxt = generateItems([
			"geo",
			"charms",
			"charmsunlocked",
			"interacts",
			"songScores",
			"weekScores",
			"songRating",
			"unlocked"
		]);
	}

	override function onKeyDown(e:KeyCode, modifier:KeyModifier) {
		if (!inEdit)
			return;
		super.onKeyDown(e, modifier);
	}

	override function onTextInput(text:String) {
		if (!inEdit)
			return;
		super.onTextInput(text);
	}

	override function onTextEdit(text:String, start:Int, end:Int) {
		if (!inEdit)
			return;
		super.onTextEdit(text, start, end);
	}

	var inEdit = false;
	var editing = "";

	override function acceptSelection() {
		if (!inEdit) {
			var item = itemsTxt[curSelected];

			editing = item.buttonText;
			inEdit = true;

			searchText = switch (editing) {
				case "geo": Std.string(DataSaver.geo);
				case "charms": '';
				case "charmsunlocked": '';
				case "interacts": '';
				case "songScores": '';
				case "weekScores": '';
				case "songRating": '';
				case "unlocked": '';
				case _: null;
			}
			searchTxt.text = "";
		} else if (inEdit) {
			switch (editing) {
				case "geo":
					DataSaver.geo = Std.parseInt(searchText);
					// case "charms": DataSaver.charms = CoolUtil.parseBoolArray(searchText);
					// case "charmsunlocked": DataSaver.charmsunlocked = CoolUtil.parseBoolArray(searchText);
					// case "interacts": DataSaver.interacts = CoolUtil.parseBoolArray(searchText);
					// case "songScores": DataSaver.songScores = CoolUtil.parseIntArray(searchText);
					// case "weekScores": DataSaver.weekScores = CoolUtil.parseIntArray(searchText);
					// case "songRating": DataSaver.songRating = CoolUtil.parseFloatArray(searchText);
					// case "unlocked": DataSaver.unlocked = CoolUtil.parseStringArray(searchText);
			}
		}
	}

	override function back() {
		if (controls.BACK && inEdit) {
			inEdit = false;
			searchText = "";
			searchTxt.text = "";
			updatePosAndNodes();
		}
	}
}
