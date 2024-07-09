package states.debug;

import options.*;
import flixel.FlxG;
import flixel.util.FlxColor;

using StringTools;

class DebugSaveEditorSubState extends options.BaseOptionsMenu {
	public override function getSpacing():Float {
		return 20;
	}

	public override function getOffset():Float {
		return -70;
	}

	var order:Option;

	public function new() {
		doRPC = false;
		// hasBG = false;
		title = 'Save Editor Screen';
		// rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Allow Saving', '', '', BOOL);
		option.defaultValue = DataSaver.allowSaving;
		option.onSet = (variable:String, value:Dynamic) -> {
			DataSaver.allowSaving = value;
		};
		option.onGet = (variable:String) -> {
			return DataSaver.allowSaving;
		};
		option.fontColor = 0xFFFFFF;
		addOption(option);

		var option:Option = new Option('Geo', '', '', INT);
		option.defaultValue = DataSaver.geo;
		option.onSet = (variable:String, value:Dynamic) -> {
			DataSaver.geo = value;
		};
		option.onGet = (variable:String) -> {
			return DataSaver.geo;
		};
		option.fontColor = 0xFFFFFF;
		addOption(option);

		var option = new Option("Elderbug State", "", "", INT);
		option.defaultValue = DataSaver.elderbugstate;
		option.onSet = (variable:String, value:Dynamic) -> {
			DataSaver.elderbugstate = value;
		};
		option.onGet = (variable:String) -> {
			return DataSaver.elderbugstate;
		};
		option.fontColor = 0xFFFFFF;
		addOption(option);

		function boolHighlight(self:Option, value:Dynamic) {
			option.fontColor = value ? 0xFFFFFFFF : 0xFF7f7f7f;
		}

		var header:Option = new Option('Unlocked Charms', '', '', BOOL);
		header.disabled = true;
		header.checkboxVisible = false;
		header.alphaMul = 0.5;
		header.fontColor = 0xFFFFFF;
		addOption(header);

		for (charm in DataSaver.allCharmsInternal) {
			var charm = charm;
			var option:Option = new Option(charm, '', charm, BOOL);
			option.defaultValue = DataSaver.charmsunlocked.get(charm);
			option.onSet = (variable:String, value:Dynamic) -> {
				DataSaver.charmsunlocked.set(charm, value);
			};
			option.onGet = (variable:String) -> {
				return DataSaver.charmsunlocked.get(charm);
			};
			option.handleVisual = boolHighlight;
			option.fontColor = 0xFFFFFF;
			addOption(option);
		}

		var header:Option = new Option('Selected Charms', '', '', BOOL);
		header.disabled = true;
		header.checkboxVisible = false;
		header.alphaMul = 0.5;
		header.fontColor = 0xFFFFFF;
		addOption(header);

		order = new Option('Order', '', '', BOOL);
		order.disabled = true;
		order.checkboxVisible = false;
		order.alphaMul = 0.5;
		order.onGet = (variable:String) -> {
			return DataSaver.sillyOrder.join(',');
		};
		order.fontColor = 0xFFFFFF;
		addOption(order);

		for (charm in DataSaver.allCharms) {
			var charm = charm;
			var option:Option = new Option(charm, '', charm, BOOL);
			option.defaultValue = DataSaver.charms.get(charm);
			option.onSet = (variable:String, value:Dynamic) -> {
				DataSaver.charms.set(charm, value);
			};
			option.onGet = (variable:String) -> {
				return DataSaver.charms.get(charm);
			};
			option.handleVisual = boolHighlight;
			option.fontColor = 0xFFFFFF;
			addOption(option);
		}

		var header:Option = new Option('Interacts', '', '', BOOL);
		header.disabled = true;
		header.checkboxVisible = false;
		header.alphaMul = 0.5;
		header.fontColor = 0xFFFFFF;
		addOption(header);

		for (i in 0...DataSaver.interacts.length) {
			var option:Option = new Option("Interact " + i, '', Std.string(i), BOOL);
			option.onSet = (variable:String, value:Dynamic) -> {
				DataSaver.interacts[i] = value;
			};
			option.onGet = (variable:String) -> {
				return DataSaver.interacts[i];
			};
			option.handleVisual = boolHighlight;
			option.fontColor = 0xFFFFFF;
			addOption(option);
		}

		super();

		var bg = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		insert(0, bg);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function updateTextFrom(option:Option) {
		if (option != order) {
			super.updateTextFrom(order);
		}
		super.updateTextFrom(option);
	}

	override function close():Void {
		DataSaver.saveSettings(DataSaver.saveFile);
		// ClientPrefs.saveSettings();
		super.close();
	}
}
