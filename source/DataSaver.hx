package;

import overworld.Charms.CharmId;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.graphics.FlxGraphic;

class DataSaver {
	// needs to be saved
	public static var geo:Int = 0;
	public static var equippedCharms:Array<CharmId> = [];
	public static var unlockedCharms:Map<CharmId, Bool> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	public static var weekScores:Map<String, Int> = new Map();
	public static var songRating:Map<String, Float> = new Map();
	public static var unlocked:Map<String, String> = new Map();
	public static var played:Bool = false;
	public static var elderbugstate:Int = 0;
	public static var slytries:Int = 0;
	public static var usedNotches:Int = 0;

	public static var lichendone:Bool = false;
	public static var diedonfirststeps:Bool = false;
	public static var interacts = [false, false, false];

	public static var charmOrder:Array<CharmId> = [];

	// vars
	public static var saveFile:Int = 0;
	public static var doingsong:String = '';

	public static function saveSettings(saveFileData:Int) {
		saveFile = saveFileData;

		var curSave:FlxSave = new FlxSave();
		curSave.bind('saveData' + saveFile, 'nld');

		curSave.data.geo = geo;
		curSave.data.equippedCharms = equippedCharms;
		curSave.data.unlockedCharms = unlockedCharms;
		curSave.data.songScores = songScores;
		curSave.data.weekScores = songScores;
		curSave.data.songRating = songScores;
		curSave.data.unlocked = unlocked;
		curSave.data.played = played;
		curSave.data.elderbugstate = elderbugstate;
		curSave.data.charmOrder = charmOrder;
		curSave.data.slytries = slytries;
		curSave.data.usedNotches = usedNotches;
		curSave.data.doingsong = doingsong;
		curSave.data.lichendone = lichendone;
		curSave.data.diedonfirststeps = diedonfirststeps;
		curSave.data.interacts = interacts;

		curSave.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadData(saveFileData:Int) {
		saveFile = saveFileData;

		var curSave:FlxSave = new FlxSave();
		curSave.bind('saveData' + saveFile, 'nld');

		geo = 0;
		equippedCharms = [];
		unlockedCharms = [CharmId.MELODIC_SHELL => true /*, "swindler" => false*/];
		// unlockedCharms.set("Melodic Shell", false);
		// unlockedCharms.set("Swindler", false);
		songScores = new Map();
		weekScores = new Map();
		songRating = new Map();
		unlocked = new Map();
		played = false;
		elderbugstate = 0;
		charmOrder = [];
		slytries = 0;
		usedNotches = 0;
		doingsong = '';
		lichendone = false;
		diedonfirststeps = false;
		interacts = [false, false, false];

		if (curSave.data.geo != null) {
			geo = curSave.data.geo;
		}
		if (curSave.data.equippedCharms != null) {
			equippedCharms = curSave.data.equippedCharms;
		}
		if (curSave.data.unlockedCharms != null) {
			unlockedCharms = curSave.data.unlockedCharms;
		}
		if (curSave.data.songScores != null) {
			songScores = curSave.data.songScores;
		}
		if (curSave.data.weekScores != null) {
			weekScores = curSave.data.weekScores;
		}
		if (curSave.data.songRating != null) {
			songRating = curSave.data.songRating;
		}
		if (curSave.data.unlocked != null) {
			unlocked = curSave.data.unlocked;
		}
		if (curSave.data.played != null) {
			played = curSave.data.played;
		}
		if (curSave.data.elderbugstate != null) {
			elderbugstate = curSave.data.elderbugstate;
		}
		if (curSave.data.charmOrder != null) {
			charmOrder = curSave.data.charmOrder;
		}
		if (curSave.data.slytries != null) {
			slytries = curSave.data.slytries;
		}
		if (curSave.data.usedNotches != null) {
			usedNotches = curSave.data.usedNotches;
		}
		if (curSave.data.doingsong != null) {
			doingsong = curSave.data.doingsong;
		}
		if (curSave.data.lichendone != null) {
			lichendone = curSave.data.lichendone;
		}
		if (curSave.data.diedonfirststeps != null) {
			diedonfirststeps = curSave.data.diedonfirststeps;
		}
		if (curSave.data.interacts != null) {
			interacts = curSave.data.interacts;
		}

		curSave.flush();
		FlxG.log.add("Loaded!");
	}

	public static function wipeData(saveFileData:Int) {
		saveFile = saveFileData;

		var curSave:FlxSave = new FlxSave();
		curSave.bind('saveData' + saveFile, 'nld');
		curSave.erase();
		FlxG.log.add("Wiped data from SaveFile : " + saveFile);
	}
}
