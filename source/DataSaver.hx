package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.graphics.FlxGraphic;

enum abstract Charm(String) to String {
	var MelodicShell = "Melodic Shell";
	var BaldursBlessing = "Baldur's Blessing";
	var LifebloodSeed = "Lifeblood Seed";
	var CriticalFocus = "Critical Focus";

	var Swindler = "Swindler"; // Shop item, just nld using it, not a real charm
}

class DataSaver {
	public static function getCharmImage(charm:Charm) {
		return Paths.image('charms/$charm/base', 'hymns');
	}

	public static function getDesc(charm:Charm) {
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
	public static var geo:Int = 0;
	public static var charms:Map<Charm, Bool> = new Map();
	public static var charmsunlocked:Map<Charm, Bool> = new Map();
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

	public static var charmOrder:Array<Int> = [];
	public static var sillyOrder:Array<Charm> = [];

	//public static var curSave:FlxSave = null;

	public static var curSave1:FlxSave = null;
	public static var curSave2:FlxSave = null;
	public static var curSave3:FlxSave = null;
	public static var curSave4:FlxSave = null;

	public static var flushReady = false;
	// vars
	public static var saveFile:Int = 1;
	public static var doingsong:String = '';

	public static function setIfNotNull(obj:Dynamic, fieldName:String, value:Dynamic) {
		if (obj != null && value != null) {
			Reflect.setField(obj, fieldName, value);
		}
		else if (obj != null){
			Reflect.setField(obj, fieldName, getDefaultValue(fieldName));
		}
	}

	public static function setIfNotFilled(obj:Dynamic, fieldName:String) {
		var valueExists = Reflect.hasField(obj, fieldName);
		if(valueExists){
			var value2 = Reflect.field(obj, fieldName);
			if(value2==null){
				setIfNotNull(obj, fieldName, null);
			}
		}
		else{
			setIfNotNull(obj, fieldName, null);
		}
	}

	public static function loadSaves(){
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

		/*switch(DataSaver.saveFile){
			case 1: DataSaver.curSave = curSave1;
			case 2: DataSaver.curSave = curSave2;
			case 3: DataSaver.curSave = curSave3;
			case 4: DataSaver.curSave = curSave4;
		}*/

	}

	public static function makeSave(saveFile:FlxSave):FlxSave{
		setIfNotFilled(saveFile.data, 'geo');
		setIfNotFilled(saveFile.data, 'charms');
		setIfNotFilled(saveFile.data, 'charmsunlocked');
		setIfNotFilled(saveFile.data, 'songScores');
		setIfNotFilled(saveFile.data, 'weekScores');
		setIfNotFilled(saveFile.data, 'songRating');
		setIfNotFilled(saveFile.data, 'unlocked');
		setIfNotFilled(saveFile.data, 'played');
		setIfNotFilled(saveFile.data, 'elderbugstate');
		setIfNotFilled(saveFile.data, 'charmOrder');
		setIfNotFilled(saveFile.data, 'slytries');
		// setIfNotNull(saveFile.data, 'usedNotches', usedNotches);
		setIfNotFilled(saveFile.data, 'doingsong');
		setIfNotFilled(saveFile.data, 'lichendone');
		setIfNotFilled(saveFile.data, 'diedonfirststeps');
		setIfNotFilled(saveFile.data, 'interacts');
		setIfNotFilled(saveFile.data, 'sillyOrder');
		return saveFile;
	}

	public static function fixSave(saveFile:FlxSave):FlxSave{
		setIfNotNull(saveFile.data, 'geo', geo);
		setIfNotNull(saveFile.data, 'charms', charms);
		setIfNotNull(saveFile.data, 'charmsunlocked', charmsunlocked);
		setIfNotNull(saveFile.data, 'songScores', songScores);
		setIfNotNull(saveFile.data, 'weekScores', weekScores);
		setIfNotNull(saveFile.data, 'songRating', songRating);
		setIfNotNull(saveFile.data, 'unlocked', unlocked);
		//setIfNotNull(saveFile.data, 'played', played);
		setIfNotNull(saveFile.data, 'elderbugstate', elderbugstate);
		setIfNotNull(saveFile.data, 'charmOrder', charmOrder);
		setIfNotNull(saveFile.data, 'slytries', slytries);
		// setIfNotNull(saveFile.data, 'usedNotches', usedNotches);
		setIfNotNull(saveFile.data, 'doingsong', doingsong);
		setIfNotNull(saveFile.data, 'lichendone', lichendone);
		setIfNotNull(saveFile.data, 'diedonfirststeps', diedonfirststeps);
		setIfNotNull(saveFile.data, 'interacts', interacts);
		setIfNotNull(saveFile.data, 'sillyOrder', sillyOrder);
		return saveFile;
	}

	public static function getSave(saveNo:Int):FlxSave{
		switch(saveNo){
			case 1: return curSave1;
			case 2: return curSave2;
			case 3: return curSave3;
			default: return curSave4;
		}
	}

	public static function doFlush(force:Bool) {
		if ( force || flushReady) {
			trace("here we go");
			getSave(DataSaver.saveFile).flush();
			flushReady=false;
		}
	}

	
	public static function retrieveSaveValue(saveKey:String, variable:Dynamic):Dynamic {
		var curSave = getSave(DataSaver.saveFile);
		if(curSave == null || curSave.data == null) {
			checkSave(DataSaver.saveFile);
			return null;
		}

		var value:Dynamic = Reflect.hasField(curSave.data, saveKey);
		if (!value) {
			return Reflect.field(curSave.data, saveKey);
		}
		else{
			//Reflect.setField(DataSaver.curSave.data, variable, getDefaultValue(variable));
			flushReady = true;
			//Reflect.setField(DataSaver, variable, value);
			return getDefaultValue(variable);
		}
		
		trace('Error: value ${saveKey} is null');
		return null;
	}

	public static function checkSave(saveFileData:Int){
		DataSaver.saveFile = saveFileData;
		var save = getSave(DataSaver.saveFile);
		if(save == null){
			loadSaves();
		}		
	}

	public static function saveSettings(?saveFileData:Null<Int>) {
		if (!allowSaving)
			return;

		if(saveFileData!=null){
			DataSaver.saveFile = saveFileData;
		}
		//saveFile = saveFileData;
		var save = getSave(DataSaver.saveFile);
		checkSave(DataSaver.saveFile);
		
		if(save == null) {
			trace("save file not created");
			return;
		}
		
		fixSave(save);

		flushReady = true;
		save.flush();
		FlxG.log.add("Settings saved!");
		trace('Saved Savefile in slot ${DataSaver.saveFile}');
	}


	public static function getDefaultValue(?key:Null<String>):Dynamic {
		if(key==null) return null;
		var value:Dynamic = null;
		switch (key) {
			case 'geo':
				value = 0;
			case 'charms':
				value = [MelodicShell => false,];
			case 'charmsunlocked':
				value = [MelodicShell => false, Swindler => false,];
			case 'songScores':
				value = new Map<Charm, Bool>();
			case 'weekScores':
				value = new Map<String, Int>();
			case 'songRating':
				value = new Map<String, Float>();
			case 'unlocked':
				value = new Map<String, String>();
			case 'played':
				value = false;
			case 'elderbugstate':
				value = 0;
			case 'charmOrder':
				value = [];
			case 'slytries':
				value = 0;
			case 'usedNotches':
				value = 0;
			case 'doingsong':
				value = '';
			case 'lichendone':
				value = false;
			case 'diedonfirststeps':
				value = false;
			case 'interacts':
				value = [false, false, false];
			case 'sillyOrder':
				value = [];
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
	
		//resetData();
		retrieveSaveValue("geo", "geo");
		retrieveSaveValue("charms", "charms");
		retrieveSaveValue("charmsunlocked", "charmsunlocked");
		retrieveSaveValue("songScores", "songScores");
		retrieveSaveValue("weekScores", "weekScores");
		retrieveSaveValue("songRating", "songRating");
		retrieveSaveValue("unlocked", "unlocked");
		retrieveSaveValue("played", "played");
		retrieveSaveValue("elderbugstate", "elderbugstate");
		retrieveSaveValue("charmOrder", "charmOrder");
		retrieveSaveValue("slytries", "slytries");
		retrieveSaveValue("doingsong", "doingsong");
		retrieveSaveValue("lichendone", "lichendone");
		retrieveSaveValue("diedonfirststeps", "diedonfirststeps");
		retrieveSaveValue("interacts", "interacts");
		if (retrieveSaveValue("sillyOrder", "sillyOrder")!= null ) {
			fixSillyOrder();
		}

		// Etrace(sillyOrder);

		// remove unequipped charms from sillyOrder

		usedNotches = calculateNotches();

		var curSave = getSave(DataSaver.saveFile);
		if(curSave!=null){
			flushReady = true;
			curSave.data.played = true;
			curSave.flush();
		}
		FlxG.log.add("Loaded!");
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
		//saveFile = saveFileData;

		var curSave:FlxSave = new FlxSave();
		curSave.bind('saveData' + saveFileData, 'hymns');
		curSave.erase();
		fixSave(curSave);
		//setDefaultValues();
		FlxG.log.add("Wiped data from SaveFile : " + saveFile);
	}
}
