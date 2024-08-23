package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.graphics.FlxGraphic;
import haxe.Serializer;
import haxe.Unserializer;

enum abstract Charm(String) to String {
	var MelodicShell = "Melodic Shell";
	var BaldursBlessing = "Baldur's Blessing";
	var LifebloodSeed = "Lifeblood Seed";
	var CriticalFocus = "Critical Focus";

	var Swindler = "Swindler"; // Shop item, just nld using it, not a real charm
}

typedef SaveFileData = {
	var geo:Int;
	var charms:Map<Charm, Bool>;
	var charmsunlocked:Map<Charm, Bool>;
	var songScores:Map<String, Int>;
	var weekScores:Map<String, Int>;
	var songRating:Map<String, Float>;
	var unlocked:Map<String, String>;
	var played:Bool;
	var elderbugstate:Int;
	var charmOrder:Array<Int>;
	var slytries:Int;
	var doingsong:String;
	var lichendone:Bool;
	var diedonfirststeps:Bool;
	var interacts:Array<Bool>;
	var sillyOrder:Array<Charm>;
	var usedNotches:Int;
	var version:String;
}

typedef SaveFile = {
	var data:SaveFileData;
}

class DataSaver {
	public static function getCharmImage(charm:Charm) {
		if (charm == BaldursBlessing) {
			var img = Paths.image('charms/Baldurs Blessing/base', 'hymns');
			if (img != null)
				return img;
		}
		return Paths.image('charms/$charm/base', 'hymns');
	}

	public static function getDesc(charm:Charm) {
		if (charm == BaldursBlessing) {
			var txt = Paths.getContent('charms/Baldurs Blessing/desc.txt', 'hymns');
			if (txt != null)
				return txt;
		}
		return Paths.getContent('charms/$charm/desc.txt', 'hymns');
	}

	public static function getCost(charm:Charm) {
		return switch (charm) {
			case MelodicShell: 0;
			case BaldursBlessing: 3;
			case LifebloodSeed: 2;
			case CriticalFocus: 2;
			default: 0;
		}
	}

	public static var isOvercharmed(get, never):Bool;

	private static function get_isOvercharmed() {
		return usedNotches > 5;
	}

	public static final allCharms:Array<Charm> = [MelodicShell, BaldursBlessing, LifebloodSeed, CriticalFocus];
	public static final allCharmsInternal:Array<Charm> = [MelodicShell, BaldursBlessing, LifebloodSeed, CriticalFocus, Swindler];

	public static var allowSaving:Bool = true;

	// needs to be saved
	public static var geo:Null<Int> = 0;
	public static var charms:Map<Charm, Bool> = new Map();
	public static var charmsunlocked:Map<Charm, Bool> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	public static var weekScores:Map<String, Int> = new Map();
	public static var songRating:Map<String, Float> = new Map();
	public static var unlocked:Map<String, String> = new Map();
	public static var played:Null<Bool> = false;
	public static var elderbugstate:Null<Int> = 0;
	public static var slytries:Null<Int> = 0;
	public static var usedNotches:Null<Int> = 0;

	public static var lichendone:Null<Bool> = false;
	public static var diedonfirststeps:Null<Bool> = false;
	public static var interacts = [false, false, false];

	public static var charmOrder:Array<Int> = [];
	public static var sillyOrder:Array<Charm> = [];

	public static final defaultSave:SaveFile = {
		data: {
			"geo": 0,
			"charms": [MelodicShell => false],
			"charmsunlocked": [MelodicShell => false, Swindler => false,],
			"songScores": new Map<String, Int>(),
			"weekScores": weekScores,
			"songRating": songRating,
			"unlocked": unlocked,
			"played": false,
			"elderbugstate": 0,
			"charmOrder": charmOrder,
			"slytries": 0,
			"usedNotches": 0,
			"doingsong": "",
			"lichendone": false,
			"diedonfirststeps": false,
			"interacts": [false, false, false],
			"sillyOrder": sillyOrder,
			"version": "DEMO"
		}
	};

	// public static var curSave:FlxSave = null;
	public static var jsonSave1:SaveFile = null;
	public static var jsonSave2:SaveFile = null;
	public static var jsonSave3:SaveFile = null;
	public static var jsonSave4:SaveFile = null;

	public static var flushReady = false;
	// vars
	public static var saveFile:Int = 1;
	public static var doingsong:String = '';

	public static function setIfNotNull(obj:Dynamic, fieldName:String, value:Dynamic) {
		if (obj != null && value != null) {
			Reflect.setField(obj, fieldName, value);
		} else if (obj != null) {
			Reflect.setField(obj, fieldName, getDefaultValue(fieldName));
		} else {
			trace("object is null");
		}
	}

	public static function setIfNotFilled(obj:Dynamic, fieldName:String) {
		var valueExists = Reflect.hasField(obj, fieldName);
		if (valueExists) {
			var value2 = Reflect.field(obj, fieldName);
			if (value2 == null) {
				setIfNotNull(obj, fieldName, null);
			}
		} else {
			setIfNotNull(obj, fieldName, null);
		}
	}

	public static function getJson(saveFileNo:Int):Dynamic {
		var encodedData = getSave(saveFileNo);
		try {
			var unserializer = new Unserializer(File.getContent('assets/data/save${saveFileNo}.json'));
			unserializer.setResolver(cast {resolveEnum: Type.resolveEnum, resolveClass: Type.resolveClass});
			encodedData = unserializer.unserialize();
		} catch (err) {
			encodedData = defaultSave;
			trace(err);
		}
		return encodedData;
	}

	public static function loadSaves() {
		jsonSave1 = getJson(1);
		jsonSave2 = getJson(2);
		jsonSave3 = getJson(3);
		jsonSave4 = getJson(4);

		makeSave(jsonSave1);

		/*
			DataSaver.curSave1 = new FlxSave();
			DataSaver.curSave1.bind('saveData1', 'hymns');
			makeSave(DataSaver.curSave1);
			DataSaver.curSave2 = new FlxSave();
			DataSaver.curSave2.bind('saveData2', 'hymns');
			makeSave(DataSaver.curSave2);
			DataSaver.curSave3 = new FlxSave();
			DataSaver.curSave3.bind('saveData3', 'hymns');
			makeSave(DataSaver.curSave3);
			DataSaver.curSave4 = new FlxSave();
			DataSaver.curSave4.bind('saveData4', 'hymns');
			makeSave(DataSaver.curSave4);
		 */
	}

	public static function makeSave(curSaveFile:Dynamic):Dynamic {
		setIfNotFilled(curSaveFile.data, 'geo');
		setIfNotFilled(curSaveFile.data, 'charms');
		setIfNotFilled(curSaveFile.data, 'charmsunlocked');
		setIfNotFilled(curSaveFile.data, 'songScores');
		setIfNotFilled(curSaveFile.data, 'weekScores');
		setIfNotFilled(curSaveFile.data, 'songRating');
		setIfNotFilled(curSaveFile.data, 'unlocked');
		setIfNotFilled(curSaveFile.data, 'played');
		setIfNotFilled(curSaveFile.data, 'elderbugstate');
		setIfNotFilled(curSaveFile.data, 'charmOrder');
		setIfNotFilled(curSaveFile.data, 'slytries');
		// setIfNotNull(curSaveFile.data, 'usedNotches', usedNotches);
		setIfNotFilled(curSaveFile.data, 'doingsong');
		setIfNotFilled(curSaveFile.data, 'lichendone');
		setIfNotFilled(curSaveFile.data, 'diedonfirststeps');
		setIfNotFilled(curSaveFile.data, 'interacts');
		setIfNotFilled(curSaveFile.data, 'sillyOrder');
		curSaveFile.data.version = "DEMO";
		return curSaveFile;
	}

	public static function fixSave(saveNo:Int):Dynamic {
		var curSaveFile = getSave(saveNo);

		var attempt:SaveFileData = curSaveFile.data;
		if (attempt == null) {
			attempt = defaultSave.data;
		}
		curSaveFile.data = attempt;
		/*
			curSaveFile.data.geo = geo != null ? geo : getDefaultValue('geo');
			curSaveFile.data.charms = charms != null ? charms : getDefaultValue('charms');
			curSaveFile.data.charmsunlocked = charmsunlocked != null ? charmsunlocked : getDefaultValue('charmsunlocked');
			curSaveFile.data.songScores = songScores != null ? songScores : getDefaultValue('songScores');
			curSaveFile.data.weekScores = weekScores != null ? weekScores : getDefaultValue('weekScores');
			curSaveFile.data.songRating = songRating != null ? songRating : getDefaultValue('songRating');
			curSaveFile.data.unlocked = unlocked != null ? unlocked : getDefaultValue('unlocked');
			curSaveFile.data.elderbugstate = elderbugstate != null ? elderbugstate : getDefaultValue('elderbugstate');
			curSaveFile.data.charmOrder = charmOrder != null ? charmOrder : getDefaultValue('charmOrder');
			curSaveFile.data.slytries = slytries != null ? slytries : getDefaultValue('slytries');
			curSaveFile.data.doingsong = doingsong != null ? doingsong : getDefaultValue('doingsong');
			curSaveFile.data.lichendone = lichendone != null ? lichendone : getDefaultValue('lichendone');
			curSaveFile.data.diedonfirststeps = diedonfirststeps != null ? diedonfirststeps : getDefaultValue('diedonfirststeps');
			curSaveFile.data.interacts = interacts != null ? interacts : getDefaultValue('interacts');
			curSaveFile.data.sillyOrder = sillyOrder != null ? sillyOrder : getDefaultValue('sillyOrder');
		 */
		// setIfNotNull(curSaveFile.data, 'played', played);//
		// setIfNotNull(curSaveFile.data, 'usedNotches', usedNotches);//

		return curSaveFile;
	}

	public static function getSave(saveNo:Int):SaveFile {
		return switch (saveNo) {
			case 1: jsonSave1;
			case 2: jsonSave2;
			case 3: jsonSave3;
			default: jsonSave4;
		}
	}

	public static function doFlush(force:Bool) {
		if (force || flushReady) {
			trace("here we go");
			// getSave(DataSaver.saveFile).flush();
			var output = File.write('assets/data/save${DataSaver.saveFile}.json', false);
			output.writeString(
				haxe.Json.stringify(Serializer.run(getSave(DataSaver.saveFile)))
			);
			output.close();
			flushReady = false;
		}
	}

	public static function retrieveSaveValue(saveKey:String):Dynamic {
		var curSave = getSave(DataSaver.saveFile);
		if (curSave == null || curSave.data == null) {
			checkSave(DataSaver.saveFile);
			return null;
		}

		var data = curSave.data;

		var value:Dynamic = Reflect.hasField(data, saveKey);
		if (!value) {
			return Reflect.field(data, saveKey);
		} else {
			// Reflect.setField(DataSaver.curSave.data, variable, getDefaultValue(variable));
			flushReady = true;
			// Reflect.setField(DataSaver, variable, value);
			return getDefaultValue(saveKey);
		}

		trace('Error: value ${saveKey} is null');
		return null;
	}

	public static function checkSave(saveFileData:Int) {
		DataSaver.saveFile = saveFileData;
		var save = getSave(DataSaver.saveFile);
		if (save == null) {
			loadSaves();
		}
	}

	public static function saveSettings(?saveFileData:Null<Int>) {
		if (!allowSaving)
			return;

		if (saveFileData != null) {
			DataSaver.saveFile = saveFileData;
		}
		// saveFile = saveFileData;
		checkSave(DataSaver.saveFile);
		var save = getJson(DataSaver.saveFile);

		if (save == null) {
			trace("save file not created");
			return;
		}

		fixSave(DataSaver.saveFile);

		flushReady = true;
		// save.flush();
		doFlush(true);
		FlxG.log.add("Settings saved!");
		trace('Saved Savefile in slot ${DataSaver.saveFile}');
	}

	public static function getDefaultValue(?key:Null<String>):Dynamic {
		if (key == null)
			return null;
		var value:Dynamic = null;
		switch (key) {
			case 'geo': value = 0;
			case 'charms': value = [MelodicShell => false,];
			case 'charmsunlocked': value = [MelodicShell => false, Swindler => false,];
			case 'songScores': value = new Map<Charm, Bool>();
			case 'weekScores': value = new Map<String, Int>();
			case 'songRating': value = new Map<String, Float>();
			case 'unlocked': value = new Map<String, String>();
			case 'played': value = false;
			case 'elderbugstate': value = 0;
			case 'charmOrder': value = [];
			case 'slytries': value = 0;
			case 'usedNotches': value = 0;
			case 'doingsong': value = '';
			case 'lichendone': value = false;
			case 'diedonfirststeps': value = false;
			case 'interacts': value = [false, false, false];
			case 'sillyOrder': value = [];
		}
		return value;
	}

	public static function setDefaultValues() {
		geo = 0;
		charms = [MelodicShell => false,];
		charmsunlocked = [MelodicShell => false, Swindler => false,];
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
		sillyOrder = [];
	}

	public static function loadData(note:String) {
		if (!allowSaving)
			return;

		trace(note);
		checkSave(DataSaver.saveFile);

		var curSaveFile = getSave(DataSaver.saveFile);
		setDefaultValues();

		var attempt:SaveFileData = curSaveFile.data;
		if (attempt != null) {
			for (key in Reflect.fields(attempt)) {
				var value:Dynamic = Reflect.field(attempt, key);
				// trace(key, value);
				Reflect.setProperty(DataSaver, key, value);
			}
		}

		/*
			var data = curSaveFile.data != null ? curSaveFile.data : defaultSave.data;

			geo = data.geo != null ? data.geo : getDefaultValue('geo');
			charms = data.charms != null ? data.charms : getDefaultValue('charms');
			charmsunlocked = data.charmsunlocked != null ? data.charmsunlocked : getDefaultValue('charmsunlocked');
			songScores = data.songScores != null ? data.songScores : getDefaultValue('songScores');
			weekScores = data.weekScores != null ? data.weekScores : getDefaultValue('weekScores');
			songRating = data.songRating != null ? data.songRating : getDefaultValue('songRating');
			unlocked = data.unlocked != null ? data.unlocked : getDefaultValue('unlocked');
			elderbugstate = data.elderbugstate != null ? data.elderbugstate : getDefaultValue('elderbugstate');
			charmOrder = data.charmOrder != null ? data.charmOrder : getDefaultValue('charmOrder');
			slytries = data.slytries != null ? data.slytries : getDefaultValue('slytries');
			doingsong = data.doingsong != null ? data.doingsong : getDefaultValue('doingsong');
			lichendone = data.lichendone != null ? data.lichendone : getDefaultValue('lichendone');
			diedonfirststeps = data.diedonfirststeps != null ? data.diedonfirststeps : getDefaultValue('diedonfirststeps');
			interacts = data.interacts != null ? data.interacts : getDefaultValue('interacts');
			sillyOrder = data.sillyOrder != null ? data.sillyOrder : getDefaultValue('sillyOrder');
		 */
		// Etrace(sillyOrder);

		// remove unequipped charms from sillyOrder

		// usedNotches = calculateNotches();

		if (curSaveFile != null) {
			flushReady = true;
			// fixSave(DataSaver.saveFile);
			// curSaveFile.data.played = true;
			// curSaveFile.flush();
		}
		FlxG.log.add("Loaded! " + note);
		trace("Loaded Savefile");
	}

	public static function fixSillyOrder() {
		for (charm => equipped in charms) {
			if (!equipped) {
				while (sillyOrder.contains(charm))
					sillyOrder.remove(charm);
			}
		}

		// trace(sillyOrder);

		// remove duplicate charms from sillyOrder
		var silly = [];
		for (charm in sillyOrder) {
			if (!silly.contains(charm))
				silly.push(charm);
		}

		// trace(silly);
		sillyOrder = silly;
	}

	public static function calculateNotches() {
		var notches = 0;
		for (charm => equipped in charms) {
			if (equipped) {
				notches += DataSaver.getCost(charm);
			}
		}
		return notches;
	}

	public static function wipeData(saveFileData:Int) {
		// saveFile = saveFileData;

		var curSave:FlxSave = new FlxSave();
		curSave.bind('saveData' + saveFileData, 'hymns');
		curSave.erase();
		fixSave(saveFileData);
		setDefaultValues();
		FlxG.log.add("Wiped data from SaveFile : " + saveFile);
	}
}
