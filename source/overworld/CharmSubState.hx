package overworld;

import overworld.Charms;
#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.util.FlxAxes;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import openfl.text.TextFieldAutoSize;
import overworld.*;

using StringTools;

@:structInit
class CharmsSprData {
	public var spr:FlxSprite;
	// public var dataList:Array<String>; // deprecated
	public var data:Charm;
	public var order:Int;
	public var idx:Int;
}

class CharmSubState extends MusicBeatSubstate {
	public var notchAmount:Int = 5;
	public var usedNotches:Int = 0;
	public var selector:FlxSprite;

	var notches:Array<FlxSprite> = [];
	var holders:Array<FlxSprite> = [];
	var cost:Array<FlxSprite> = [];
	var txt:FlxText;
	var txt2:FlxText;
	var txt3:FlxText;
	var fleurs:FlxSprite;
	var charmIcon:FlxSprite;
	var holderCharms:FlxSprite;
	var selectorGlow:FlxSprite;
	var overcharmGlow:FlxSprite;
	var tempEmit:FlxEmitter;
	var sprites:Array<Dynamic> = [];

	var row:Int = 1;
	var horiz:Int = 0;

	var sillycam:FlxCamera;

	var rows:Array<Int> = [9, 9,];
	var charmData:Array<CharmsSprData> = [];
	var charmsOrder:Map<Int, Int> = [];

	public function new(x:Float, y:Float, cam:FlxCamera) {
		super();
		sillycam = cam;

		var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		black.screenCenterXY();
		add(black);
		black.alpha = 0.5;

		overcharmGlow = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Charm/glow', 'hymns'));
		overcharmGlow.scale.set(8, 5);
		overcharmGlow.updateHitbox();
		overcharmGlow.screenCenterXY();
		overcharmGlow.alpha = 0;
		overcharmGlow.color = 0xFF985189;
		overcharmGlow.antialiasing = ClientPrefs.data.antialiasing;
		add(overcharmGlow);

		fleurs = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Charm/charmfleur', 'hymns'));
		fleurs.setGraphicSize(1280, 720);
		fleurs.updateHitbox();
		fleurs.screenCenterXY();
		fleurs.antialiasing = ClientPrefs.data.antialiasing;
		fleurs.ID = -2;
		add(fleurs);

		selectorGlow = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Charm/glow', 'hymns'));
		selectorGlow.scale.set(0.6, 0.6);
		selectorGlow.updateHitbox();
		selectorGlow.screenCenterXY();
		selectorGlow.alpha = 0.25;
		selectorGlow.color = 0xFF7A94FE;
		selectorGlow.antialiasing = ClientPrefs.data.antialiasing;
		add(selectorGlow);
		sprites.push(selectorGlow);

		tempEmit = new FlxEmitter(0, 0, 200);
		for (i in 0...100) {
			var p = new FlxParticle();
			p.loadGraphic(Paths.image('Menus/Charm/particle', 'hymns'));
			p.setGraphicSize(5, 5);
			p.updateHitbox();
			p.exists = false;
			tempEmit.add(p);
		}
		add(tempEmit);
		tempEmit.launchMode = FlxEmitterMode.CIRCLE;
		tempEmit.alpha.set(1, 1, 0, 0);
		tempEmit.scale.set(0.05, 0.05, 0.03, 0.01);
		tempEmit.speed.set(-160, 160);
		tempEmit.lifespan.set(0.5, 1);

		holderCharms = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Charm/charmholder', 'hymns'));
		holderCharms.scale.set(0.6, 0.6);
		holderCharms.updateHitbox();
		holderCharms.screenCenterXY();
		holderCharms.antialiasing = ClientPrefs.data.antialiasing;
		holderCharms.x -= FlxG.width / 2.6;
		holderCharms.y -= 150;
		add(holderCharms);
		sprites.push(selectorGlow);

		createNotches(notchAmount, 5);
		createCharmRow(9, 2);
		makeCharms();
		getCharmLocation();

		selector = new FlxSprite(0, 0);
		selector.scale.set(0.6, 0.6);
		selector.updateHitbox();
		selector.frames = Paths.getSparrowAtlas('Menus/Charm/Inventory_Selector', 'hymns');
		selector.animation.addByPrefix('loop', 'InvCursor', 24, true);
		selector.animation.play('loop', true);
		add(selector);
		sprites.push(selector);
		selector.antialiasing = ClientPrefs.data.antialiasing;

		selector.x = holders[0].x - (selector.width / 4.2);
		selector.y = holders[0].y - (selector.height / 3.8);

		addText();

		charmIcon = new FlxSprite(0, 0);
		sprites.push(charmIcon);

		setTextIcon();
		canMove = true;
	}

	function createNotches(amt:Int, extra:Int) {
		for (i in 0...amt + extra) {
			var spacing:Float = 10;

			var notch = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Charm/charmnotch', 'hymns'));
			notch.scale.set(0.6, 0.6);
			notch.updateHitbox();
			notch.screenCenterXY();
			notch.antialiasing = ClientPrefs.data.antialiasing;
			notch.x -= FlxG.width / 2.6;
			notch.y -= 55;
			add(notch);

			notch.x += (spacing + (notch.width / 3)) * i;
			notch.ID = i;
			notches.push(notch);

			sprites.push(notch);
		}
	}

	function createCost(amt:Int) {
		for (i in 0...amt) {
			var spacing:Float = 8;

			var notch = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Charm/fillednotch', 'hymns'));
			notch.scale.set(0.5, 0.5);
			notch.updateHitbox();
			notch.screenCenterXY();
			notch.antialiasing = ClientPrefs.data.antialiasing;
			notch.x = txt3.x + 65;
			notch.y = txt3.y - (notch.height / 4) - 5;
			add(notch);

			sprites.push(notch);

			notch.x += (spacing + (notch.width / 3)) * i;
			notch.ID = i;
			cost.push(notch);
		}
	}

	function createCharmRow(horiz:Int, verti:Int) {
		var vert:Float = 25;

		for (i in 0...verti) {
			for (v in 0...horiz) {
				var spacing:Float = 35;

				var holder = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Charm/charmholder', 'hymns'));
				holder.scale.set(0.6, 0.6);
				holder.updateHitbox();
				holder.screenCenterXY();
				holder.antialiasing = ClientPrefs.data.antialiasing;
				holder.x -= FlxG.width / 2.6;
				holder.y += vert;
				add(holder);

				holder.x += (spacing + (holder.width / 2)) * v + (holder.width / 2 * i);
				holder.ID = v * i;
				holders.push(holder);
				sprites.push(holder);
			}
			vert += 70;
		}
	}

	public function makeCharms() {
		var id = 0;
		for (slot => cd in Charms.charms) {
			var charmId = cd.str_id;

			if (cd.isUnlocked() == false)
				continue;

			var charm = new FlxSprite(0, 0).loadGraphic(Paths.image('charms/${charmId}', 'hymns'));
			charm.scale.set(0.25, 0.25);
			charm.updateHitbox();
			charm.screenCenterXY();
			charm.antialiasing = ClientPrefs.data.antialiasing;
			charm.ID = -5;
			sprites.push(charm);

			var holder = holders[slot];

			charm.x = holder.x - (charm.width / 2) + (holder.width / 2);
			charm.y = holder.y - (charm.height / 2) + (holder.height / 2);

			var charmtr = new FlxSprite(0, 0).loadGraphic(Paths.image('charms/${charmId}', 'hymns'));
			charmtr.scale.set(0.25, 0.25);
			charmtr.updateHitbox();
			charmtr.screenCenterXY();
			charmtr.antialiasing = ClientPrefs.data.antialiasing;
			charmtr.color = 0xFF2D2D2D;
			add(charmtr);
			charmtr.x = charm.x;
			charmtr.y = charm.y;
			sprites.push(charmtr);

			add(charm);
			// charmData.push([charm, dataList, charmId, makeCharm, rawData2, rawData2, dataList[6]]);
			charmData.push({
				spr: charm,
				// dataList: dataList,
				data: cd,
				order: slot,
				idx: id
			});
			charmsOrder.set(slot, id);

			id++;
		}

		/*var directories:Array<String> = ['assets/hymns/charms/'];

			for (i in 0...directories.length) {
				var directory:String = directories[i];
				if (FileSystem.exists(directory)) {
					var itee:Int = 0;
					for (file in FileSystem.readDirectory(directory)) {
						var charmName:String = file;

						trace(charmName);

						// var charm = new FlxSprite(0, 0).loadGraphic('hymns:assets/hymns/charms/' + charmName + '/base.png');
						var charm = new FlxSprite(0, 0).loadGraphic(Paths.image('charms/$charmName', 'hymns'));
						charm.scale.set(0.25, 0.25);
						charm.updateHitbox();
						charm.screenCenterXY();
						charm.antialiasing = ClientPrefs.data.antialiasing;
						charm.ID = -5;
						sprites.push(charm);

						var rawData:String = Paths.getContent('hymns/charms/' + charmName + '/data.charm', 'hymns');
						var rawData2:Int = Std.parseInt(Paths.getContent('hymns/charms/' + charmName + '/order.txt', 'hymns').trim());
						var dataList:Array<Dynamic> = rawData.trim().split('\n');
						dataList[5] = rawData2 + 1;

						var makeCharm = DataSaver.unlockedCharms.get(charmName);

						if (makeCharm != true) {
							makeCharm = false;
							charm.visible = false;
						} else {
							var charmtr = new FlxSprite(0, 0).loadGraphic(Paths.image('charms/$charmName/base', 'hymns'));
							charmtr.scale.set(0.25, 0.25);
							charmtr.updateHitbox();
							charmtr.screenCenterXY();
							charmtr.antialiasing = ClientPrefs.data.antialiasing;
							charmtr.color = 0xFF2D2D2D;
							add(charmtr);
							charmtr.x = charm.x;
							charmtr.y = charm.y;
							sprites.push(charmtr);
						}
						if (makeCharm == true) {
							add(charm);
							charmData.insert(itee, [charm, dataList, charmName, makeCharm, rawData2, rawData2, dataList[6]]);

							charmsOrder.push(rawData2);
							itee++;
						}
					}
				}
		}*/

		trace(charmData);
	}

	function getCharmFromId(charm:String) {
		for (c in charmData) {
			if (c.data.str_id == charm) {
				return c;
			}
		}
		return null;
	}

	public function getCharmLocation() {
		DataSaver.loadData(DataSaver.saveFile);
		usedNotches = DataSaver.usedNotches;

		for (i in 0...DataSaver.equippedCharms.length) {
			var charmId = DataSaver.equippedCharms[i];
			var charm = getCharmFromId(charmId);

			if (charm != null) {
				var slot = charm.idx;
				var spr:FlxSprite = charm.spr;
				spr.x = holderCharms.x - (spr.width / 2) + (holders[slot].width / 2);
				spr.y = holderCharms.y - (spr.height / 2) + (holders[slot].height / 2);
				holderCharms.x += (35 + (holderCharms.width / 2));
				if (usedNotches >= notchAmount) {
					FlxTween.tween(holderCharms.scale, {x: 0, y: 0}, 0.15, {ease: FlxEase.cubeOut});
				}
				charmsEquipped.push(spr);
			}

			/*for (i in 0...charmData.length) {
				var charm = charmData[i];
				var spr:FlxSprite = charm.spr;

				DataSaver.loadData(DataSaver.saveFile);
				var dat:Bool = charm.data.isEquipped();

				if (dat == true) {
					for (charm in charmData) {
						var slot = charm.order;
						if (charmsOrder.exists(slot)) {
							slot = charmsOrder.get(slot);
						}
						new FlxTimer().start(0.01 * slot, function(tmr:FlxTimer) {
							spr.x = holderCharms.x - (spr.width / 2) + (holders[slot].width / 2);
							spr.y = holderCharms.y - (spr.height / 2) + (holders[slot].height / 2);
							holderCharms.x += (35 + (holderCharms.width / 2));
							if (usedNotches >= notchAmount) {
								FlxTween.tween(holderCharms.scale, {x: 0, y: 0}, 0.15, {ease: FlxEase.cubeOut});
							}
							charmsEquipped.push(spr);
						});
					}
				}
			}*/
		}
	}

	function setTextIcon() {
		for (i in 0...cost.length) {
			var notch = cost[0];
			if (notch != null) {
				cost.remove(notch);
				notch.destroy();
			}
		}

		var charmSlot = horiz + (rows[row - 1] * (row - 1));

		if (charmsOrder.exists(charmSlot)) {
			var charm = charmData[charmsOrder.get(charmSlot)];
			// var datar = charmOrder.get(horiz + (rows[row - 1] * (row - 1)));
			// if (charm[3] == true) {
			var charmText:String = charm.data.description;
			var mainTxt:String = charmText.trim();

			txt2.text = charm.data.name;
			txt2.updateHitbox();
			txt2.screenCenterXY();
			txt2.x += 365;
			txt2.y -= 225;

			// txt.text = 'Tuneful charm created for\nthose who wish to chant\n\n\nGrants its bearer the ability to sing\nin return rewarding them soul';

			txt3.text = 'Cost';
			txt3.screenCenterXY();
			txt3.updateHitbox();
			txt3.x += 325;
			txt3.y -= 190;

			createCost(charm.data.cost);

			if (charm.data.cost == 0) {
				txt3.x += 25;
				txt3.text = 'No Cost';
			}
			charmIcon.loadGraphic(Paths.image('charms/${charm.data.str_id}', 'hymns'));
			charmIcon.scale.set(0.7, 0.7);
			charmIcon.updateHitbox();
			charmIcon.x = txt.x + 50;
			charmIcon.y = txt.y - charmIcon.height;
			charmIcon.alpha = 1;
			charmIcon.antialiasing = ClientPrefs.data.antialiasing;
			add(charmIcon);

			trace(mainTxt);
			txt.text = mainTxt;
			txt.translation(mainTxt);

			trace(txt.translationPub(mainTxt));
			// } else {
			//	clearicon();
			// }
		} else {
			clearicon();
		}
	}

	function clearicon() {
		txt.text = '';
		txt2.screenCenterXY();
		txt2.x += 225;
		txt2.y -= 225;
		txt2.text = '';

		txt3.screenCenterXY();
		txt3.x += 315;
		txt3.y -= 190;
		txt3.text = '';
		charmIcon.alpha = 0;
	}

	function addText() {
		txt = new FlxText(0, FlxG.height - 44, 350, '', 12);
		txt.scrollFactor.set();
		txt.setFormat(Paths.font("perpetua.ttf"), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.autoSize = false;
		txt.wordWrap = true;
		txt.screenCenterXY();
		txt.x += 367;
		txt.y += 75;
		txt.antialiasing = ClientPrefs.data.antialiasing;
		add(txt);

		txt2 = new FlxText(0, FlxG.height - 44, 0, '', 12);
		txt2.scrollFactor.set();
		txt2.setFormat(Constants.UI_FONT, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt2.screenCenterXY();
		txt2.x += 275;
		txt2.y -= 225;
		txt2.antialiasing = ClientPrefs.data.antialiasing;
		add(txt2);

		txt3 = new FlxText(0, FlxG.height - 44, 0, 'Cost', 12);
		txt3.scrollFactor.set();
		txt3.setFormat(Constants.UI_FONT, 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt3.screenCenterXY();
		txt3.x += 315;
		txt3.y -= 190;
		txt3.antialiasing = ClientPrefs.data.antialiasing;
		add(txt3);

		sprites.push(txt);
		sprites.push(txt2);
		sprites.push(txt3);

		// I hate not fixing the other stuff and using nld's same coding format, but i gotta rush for the release  - Nex
		var temp:FlxText;

		sprites.push(temp = new FlxText(0, 60, 0, "Charms"));
		add(temp.setFormat(Constants.UI_FONT, 19, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK).screenCenterX());
		temp.antialiasing = ClientPrefs.data.antialiasing;

		sprites.push(temp = new FlxText(30, 40, 0, "Exit to Dirtmouth"));
		add(temp.setFormat(Constants.UI_FONT, 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK));
		temp.antialiasing = ClientPrefs.data.antialiasing;

		sprites.push(temp = new FlxText(130, 140, 0, "Equipped"));
		add(temp.setFormat(Constants.UI_FONT, 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK));
		temp.antialiasing = ClientPrefs.data.antialiasing;

		sprites.push(temp = new FlxText(130, 270, 0, "Notches"));
		add(temp.setFormat(Constants.UI_FONT, 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK));
		temp.antialiasing = ClientPrefs.data.antialiasing;
	}

	var shakeList:Array<Dynamic> = [];

	function shakeObject(Obj:Dynamic) {
		var _fxShakeDuration:Float = 1.25;
		var _fxShakeAxes:FlxAxes = XY;
		var _fxShakeIntensity:Float = 0.015;

		var defaultposx:Float = Obj.x;
		var defaultposy:Float = Obj.y;

		var savedposx:Float = 0;
		var savedposy:Float = 0;

		var shakey = (elapsed:Float) -> {
			if (Obj.ID == -5 && usedNotches > notchAmount) {
				Obj.x -= savedposx;
				Obj.y -= savedposy;

				savedposx = FlxG.random.float(-0.025 * Obj.width, 0.025 * Obj.width);
				savedposy = FlxG.random.float(-0.025 * Obj.height, 0.025 * Obj.height);

				Obj.x += savedposx;
				Obj.y += savedposy;

				_fxShakeDuration = 0;
			} else {
				if (_fxShakeDuration > 0) {
					_fxShakeDuration -= elapsed;
					if (_fxShakeDuration <= 0) {
						Obj.x -= savedposx;
						Obj.y -= savedposy;
					} else {
						Obj.x -= savedposx;
						Obj.y -= savedposy;

						savedposx = FlxG.random.float(-_fxShakeIntensity * Obj.width, _fxShakeIntensity * Obj.width);
						savedposy = FlxG.random.float(-_fxShakeIntensity * Obj.height, _fxShakeIntensity * Obj.height);

						Obj.x += savedposx;
						Obj.y += savedposy;
					}
				}
			}
		}

		shakeList.push(shakey);
	}

	var current:Int = 0;
	var selectorTween:FlxTween;
	var charmsEquipped:Array<FlxSprite> = [];
	var canMove:Bool = false;
	var charmselect:FlxSprite = null;
	var firstgoin:Bool = true;

	override function update(elapsed:Float) {
		if (controls.UI_RIGHT_P) {
			horiz++;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.UI_LEFT_P) {
			horiz--;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.UI_UP_P) {
			row--;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.UI_DOWN_P) {
			row++;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		if (row > 2) {
			row = 2;
		} else if (row < 1) {
			row = 1;
		}

		if (horiz > rows[row - 1] - 1) {
			horiz = 0;
		} else if (horiz < 0) {
			horiz = rows[row - 1] - 1;
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			DataSaver.saveSettings(DataSaver.saveFile);

			FlxTween.tween(sillycam, {alpha: 0}, .5, {ease: FlxEase.quintOut});
			new FlxTimer().start(.5, function(tmr:FlxTimer) {
				close();
				OverworldManager.instance.player.status.bench = false;
				FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
				this.destroy();
			});
		}

		for (i in 0...shakeList.length) {
			var shake = shakeList[i];

			shake(elapsed);
		}

		if (charmselect != null) {
			tempEmit.x = charmselect.getMidpoint().x;
			tempEmit.y = charmselect.getMidpoint().y - charmselect.height / 2;
		}

		if (canMove == true && OverworldManager.instance.subState == this) {
			if (controls.ACCEPT) {
				var slot = horiz + (rows[row - 1] * (row - 1));
				if (charmsOrder.exists(slot)) {
					var datar = charmsOrder.get(slot);

					var charm = charmData[datar];

					if (firstgoin == true) {
						firstgoin = false;
					} else {
						// if (charm[3] == true) {
						DataSaver.loadData(DataSaver.saveFile);
						trace(charm.data);
						if (charm.data.isEquipped() == false) {
							if (usedNotches < notchAmount) {
								FlxG.sound.play(Paths.sound('charm_equipping_again_1', 'hymns'));
								charm.data.equip();
								trace("Equipping " + charm.data);
								DataSaver.saveSettings(DataSaver.saveFile);

								var spr = charm.spr;
								charmsEquipped.push(spr);

								FlxTween.tween(spr, {
									x: holderCharms.x - (spr.width / 2) + (holders[datar].width / 2),
									y: holderCharms.y - (spr.height / 2) + (holders[datar].width / 2)
								}, 0.3, {ease: FlxEase.cubeIn});
								canMove = false;
								DataSaver.charmOrder.push(charm.data.str_id);
								trace(DataSaver.charmOrder);
								DataSaver.saveSettings(DataSaver.saveFile);

								var rowy = charm.data.cost;

								charmselect = spr;
								tempEmit.x = spr.getMidpoint().x;
								tempEmit.y = spr.getMidpoint().y - spr.height;
								tempEmit.start(false, 0.01);

								if (charm.data.id == BALDURS_BLESSING) {
									OverworldManager.instance.soulMeter.changebaldurview();
								}

								FlxTween.tween(holderCharms.scale, {x: 0, y: 0}, 0.15, {ease: FlxEase.cubeIn});
								new FlxTimer().start(0.15, function(tmr:FlxTimer) {
									if (usedNotches + (rowy) < notchAmount) {
										FlxTween.tween(holderCharms.scale, {x: 0.6, y: 0.6}, 0.15, {ease: FlxEase.cubeOut});
									}
									holderCharms.x += (35 + (holderCharms.width / 2));
								});

								new FlxTimer().start(0.3, function(tmr:FlxTimer) {
									charmselect = null;
									tempEmit.start(true, 0);

									usedNotches += (rowy);

									var selectedGlow:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Charm/glow', 'hymns'));
									selectedGlow.scale.set(0.9, 0.9);
									selectedGlow.updateHitbox();
									selectedGlow.screenCenterXY();
									selectedGlow.alpha = 1.2;
									selectedGlow.antialiasing = ClientPrefs.data.antialiasing;
									add(selectedGlow);
									sprites.push(selectedGlow);
									selectedGlow.x = spr.getMidpoint().x - (spr.width / 1.5);
									selectedGlow.y = spr.getMidpoint().y - (spr.height / 1.5);
									FlxTween.tween(selectedGlow, {alpha: 0}, 1.25, {ease: FlxEase.cubeOut});
									FlxTween.tween(selectedGlow.scale, {x: 0.6, y: 0.6}, 1.05, {ease: FlxEase.cubeOut});

									if (usedNotches > notchAmount) {
										fleurs.loadGraphic(Paths.image('Menus/Charm/overcharm', 'hymns'));
										fleurs.setGraphicSize(1280, 720);
										fleurs.updateHitbox();
										fleurs.screenCenterXY();

										overcharmGlow.x = spr.getMidpoint().x - (overcharmGlow.width / 2);
										overcharmGlow.y = spr.getMidpoint().y - (overcharmGlow.height / 2);

										overcharmGlow.alpha = 0.5;
										FlxTween.tween(overcharmGlow, {alpha: 0}, 1.25, {ease: FlxEase.cubeOut});

										for (i in 0...sprites.length) {
											var spriter = sprites[i];
											if (spriter != null) {
												shakeObject(spriter);
											}
										}

										DataSaver.loadData(DataSaver.saveFile);
										DataSaver.usedNotches = usedNotches;
										trace(DataSaver.usedNotches);
										DataSaver.saveSettings(DataSaver.saveFile);
										FlxG.sound.play(Paths.sound('overcharm', 'hymns'));

										OverworldManager.instance.soulMeter.changeovercharmview();
									} else {
										fleurs.loadGraphic(Paths.image('Menus/Charm/charmfleur', 'hymns'));
										fleurs.setGraphicSize(1280, 720);
										fleurs.updateHitbox();
										fleurs.screenCenterXY();

										DataSaver.loadData(DataSaver.saveFile);
										DataSaver.usedNotches = usedNotches;
										DataSaver.saveSettings(DataSaver.saveFile);

										trace(DataSaver.usedNotches);
									}
								});

								new FlxTimer().start(0.5, function(tmr:FlxTimer) {
									canMove = true;
								});
							}
						} else {
							var charm = charmData[datar];

							if (charm.data.id != MELODIC_SHELL) {
								FlxG.sound.play(Paths.sound('charm_click_in', 'hymns'));

								charm.data.unequip();
								trace("Unequipping " + charm.data);
								DataSaver.saveSettings(DataSaver.saveFile);

								var spr = charm.spr;
								var charmIndex = charmsEquipped.indexOf(spr);

								for (i in 0...charmsEquipped.length) {
									if (i > charmIndex) {
										var charmy = charmsEquipped[i];
										FlxTween.tween(charmy, {x: charmy.x - (35 + (holderCharms.width / 2))}, 0.3, {ease: FlxEase.cubeOut});
									}
								}

								charmsEquipped.remove(spr);

								var holder = holders[datar];

								// charm.x = holder.x - (charm.width / 2) + (holder.width / 2);
								// charm.y = holder.y - (charm.height / 2) + (holder.height / 2);

								FlxTween.tween(spr, {
									x: holder.x - (spr.width / 2) + (holder.width / 2),
									y: holder.y - (spr.height / 2) + (holder.height / 2) //	x: (holder.x - (selector.width / 4.2)) + spr.width / 2 + 2,
									//	y: (holder.y - (selector.height / 3.8)) + spr.height / 2
								}, 0.3, {ease: FlxEase.cubeOut});
								canMove = false;
								DataSaver.charmOrder.remove(charm.data.str_id);
								DataSaver.saveSettings(DataSaver.saveFile);

								FlxTween.tween(holderCharms.scale, {x: 0, y: 0}, 0.15, {ease: FlxEase.cubeIn});

								new FlxTimer().start(0.15, function(tmr:FlxTimer) {
									FlxTween.tween(holderCharms.scale, {x: 0.6, y: 0.6}, 0.15, {ease: FlxEase.cubeOut});
									holderCharms.x -= (35 + (holderCharms.width / 2));
								});

								var notchies = charm.data.cost;

								fleurs.loadGraphic(Paths.image('Menus/Charm/charmfleur', 'hymns'));
								fleurs.setGraphicSize(1280, 720);
								fleurs.updateHitbox();
								fleurs.screenCenterXY();

								new FlxTimer().start(0.2, function(tmr:FlxTimer) {
									usedNotches -= notchies;
									DataSaver.usedNotches = usedNotches;
									DataSaver.saveSettings(DataSaver.saveFile);
									OverworldManager.instance.soulMeter.changeovercharmview();
								});

								new FlxTimer().start(0.5, function(tmr:FlxTimer) {
									canMove = true;
								});

								if (charm.data.id == BALDURS_BLESSING) {
									OverworldManager.instance.soulMeter.changebaldurview();
								}
							}
						}
						// }
					}
				}
			}
		}

		for (i in 0...notches.length) {
			var notch = notches[i];
			if (notch != null) {
				if (notch.ID < usedNotches) {
					notch.loadGraphic(Paths.image('Menus/Charm/fillednotch', 'hymns'));
					if (usedNotches > notchAmount) {
						notch.loadGraphic(Paths.image('Menus/Charm/purplenotch', 'hymns'));
						notch.alpha = 1;
					}
				} else {
					if (notch.ID < notchAmount) {
						notch.loadGraphic(Paths.image('Menus/Charm/charmnotch', 'hymns'));
					} else {
						notch.alpha = 0;
					}
				}
			}
		}

		var slot = horiz + (rows[row - 1] * (row - 1));
		if (current != slot) {
			if (selectorTween != null) {
				selectorTween.cancel();
			}

			selectorTween = FlxTween.tween(selector, {
				x: holders[slot].x - (selector.width / 4.2),
				y: holders[slot].y - (selector.height / 3.8)
			}, 0.5, {ease: FlxEase.cubeOut});
			setTextIcon();

			current = slot;
		}

		selectorGlow.x = selector.getMidpoint().x - (selectorGlow.width / 1.5);
		selectorGlow.y = selector.getMidpoint().y - (selectorGlow.height / 1.5);

		super.update(elapsed);
	}

	override function destroy() {
		super.destroy();
	}
}
