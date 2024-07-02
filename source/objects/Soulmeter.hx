/*
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣉⣿⣿⣿⣿⣿⠷⠀⠙⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⢀⣴⣿⣿⣿⣿⣿⣆⠀⠀⢹⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠛⠛⠋⠛⠛⠻⣿⡟⠀⠀⣸⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⡇  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⡇
	⣿⣿⣿⣿⣿⣿⣿⣿⠁⣴⣷⡄⠀⢢⣾⣿⡄⠀⠀⣴⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣷⠀⠻⠟⠀⠀⠘⠿⠟⠀⠀⠀⣿⣿⣿⣿⣿⣿⡇
	⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀  ⢠⣿⣿⣿⣿⣿⣿⡇
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀ ⢀⣠⣿⠿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀ ⠈⢁⣀⣤⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⢀⣬⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⢿⣿⣿⣿⣿⣿⣿⡇
	⣿⠏⢠⣶⠃⠀⣠⠞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣿
	⡟⠀⣿⣿⠀⠀⠁⣀⣤⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣄⣮⢿⣿⣿
	⣷⠀⣿⢃⡀⢰⣿⣿⣿⣆⠀⢹⣶⣄⠀⠀⠀⠀⠀⢄⡀⠀⣈⣡⣾⣿
	⣿⡇⣸⣿⣷⢸⣿⣿⣿⣿⣧⡀⢻⣿⣇⢰⣿⣿⣶⢸⣿⣆⡙⢻⣿
	⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣇⣾⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿
 */

package objects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import flixel.util.FlxBitmapDataUtil;
import flixel.system.frontEnds.BitmapFrontEnd;
import lime.graphics.Image;

using StringTools;

class Soulmeter extends FlxTypedGroup<FlxBasic> {
	var soulMeter:FlxSprite;
	var soulPulse:FlxSprite;
	var soulEyes:FlxSprite;
	var soulBurst:FlxSprite;

	public var backBoard:FlxSprite;

	var result:FlxSprite = new FlxSprite();

	var geo:FlxSprite;

	public var maxMasks:Int = 2;
	public var masks:Int = 2;

	var maskList:Array<FlxSprite> = [];

	public var soul:Float = 0;

	var frameIndex:Int = 0;
	var soulCooldown:Bool = false;

	public var healing:Bool = false;

	var healingSoul:Float = 0;

	var camera2:FlxCamera;
	var ypossoul:Float = 0;

	var heal:FlxSound;

	public var silly:FlxSprite;

	public function new(x:Float, y:Float, maskAmt:Int, camera:FlxCamera) {
		super();

		maxMasks = maskAmt;
		masks = maxMasks;
		camera2 = camera;
		maskList = [];

		silly = new FlxSprite(x, y).loadGraphic(Paths.image("SoulMeter/overcharmbackboard", 'hymns'));
		silly.cameras = [camera];
		silly.antialiasing = ClientPrefs.data.antialiasing;
		silly.updateHitbox();
		silly.scale.set(0.75, 0.75);
		silly.alpha = 0.5;
		add(silly);

		sillyview2 = FlxTween.tween(silly, {alpha: 0}, 1, {ease: FlxEase.quintInOut, type: FlxTweenType.PINGPONG});

		DataSaver.loadData(DataSaver.saveFile);
		if (DataSaver.usedNotches <= 5) {
			silly.alpha = 0;
		}

		backBoard = new FlxSprite(x, y);
		backBoard.frames = Paths.getSparrowAtlas('SoulMeter/SOULMeterBack', 'hymns');
		backBoard.cameras = [camera];
		backBoard.animation.addByPrefix("appear", "HUDAPPEAR", 15, false);
		backBoard.animation.addByIndices("idle", "HUDAPPEAR", [0], "", 15, false);
		backBoard.animation.addByPrefix("idle2", "HUDIDLE", 15, false);
		backBoard.antialiasing = ClientPrefs.data.antialiasing;
		backBoard.setGraphicSize(Std.int(backBoard.width * 0.65));
		backBoard.updateHitbox();
		backBoard.animation.play("idle2");
		add(backBoard);

		// initGeo(backBoard, camera, '257175');

		var pos = backBoard.getGraphicMidpoint();
		soulMeter = new FlxSprite(pos.x - 119.5 * 1.325, pos.y - 68);
		pos.put();
		soulMeter.cameras = [camera];
		soulMeter.frames = Paths.getSparrowAtlas('SoulMeter/HoH_Soul', 'hymns');
		soulMeter.updateHitbox();
		for (i in 1...38) {
			soulMeter.animation.addByPrefix(Std.string(i), Std.string(i) + 'Soul', 15, true);
			soulMeter.animation.play(Std.string(i));
		}
		soulMeter.animation.play('2');
		soulMeter.setGraphicSize(Std.int(soulMeter.width * 0.64));
		soulMeter.updateHitbox();
		soulMeter.antialiasing = ClientPrefs.data.antialiasing;
		add(soulMeter);
		ypossoul = soulMeter.y;

		var pos = soulMeter.getGraphicMidpoint();
		soulEyes = new FlxSprite(pos.x - soulMeter.width / 1.42, pos.y + 51);
		pos.put();
		soulEyes.cameras = [camera];
		soulEyes.frames = Paths.getSparrowAtlas('SoulMeter/Soul_Eyes', 'hymns');
		soulEyes.scale.set(0.7, 0.7);
		soulEyes.updateHitbox();
		soulEyes.animation.addByPrefix('enter', 'soul eyes appear', 15, false);
		soulEyes.animation.addByPrefix('exit', 'soul eyes disappear', 15, false);
		soulEyes.animation.play('exit', true);
		soulEyes.antialiasing = ClientPrefs.data.antialiasing;
		add(soulEyes);

		var pos = backBoard.getGraphicMidpoint();
		soulPulse = new FlxSprite(pos.x - 119.5 * 2, pos.y - 66);
		pos.put();
		soulPulse.cameras = [camera];
		soulPulse.frames = Paths.getSparrowAtlas('SoulMeter/pulse_soul', 'hymns');
		soulPulse.scale.set(0.7, 0.7);
		soulPulse.updateHitbox();
		soulPulse.animation.addByPrefix('pulse', 'soul glow pulse', 15, true);
		soulPulse.animation.play('pulse', true);
		soulPulse.antialiasing = ClientPrefs.data.antialiasing;
		add(soulPulse);
		soulPulse.y = ypossoul - 104 / 1.2;

		var pos = soulMeter.getGraphicMidpoint();
		soulBurst = new FlxSprite(pos.x - 265 / 1.27, pos.y - 208 / 1.3);
		pos.put();
		soulBurst.cameras = [camera];
		soulBurst.frames = Paths.getSparrowAtlas('SoulMeter/soulburst', 'hymns');
		soulBurst.scale.set(1.8, 1.8);
		soulBurst.updateHitbox();
		soulBurst.animation.addByPrefix('goku', 'soulburst0', 15, false);
		soulBurst.antialiasing = ClientPrefs.data.antialiasing;
		add(soulBurst);
		soulBurst.alpha = 0;

		initMasks(backBoard, camera);

		backBoard.animation.play("idle");

		heal = FlxG.sound.load(Paths.sound('focus_health_charging', 'hymns'));
		soulCooldown = false;
	}

	var geotxt:FlxText;
	var baldur:FlxSprite;

	function initGeo(backboard:FlxSprite, camera:FlxCamera, geoAmt:String) {
		var pos = backboard.getGraphicMidpoint();
		baldur = new FlxSprite(pos.x - 217, pos.y - 36);
		pos.put();
		baldur.cameras = [camera];
		baldur.frames = Paths.getSparrowAtlas('SoulMeter/BaldursBlessingHUD_Assets', 'hymns');
		baldur.scale.set(0.7, 0.7);
		baldur.updateHitbox();
		baldur.animation.addByPrefix('init', 'BBSummon', 15, false);
		baldur.animation.addByPrefix('boom', 'BBBreak', 15, false);
		baldur.animation.play('init', true);
		baldur.antialiasing = ClientPrefs.data.antialiasing;
		baldur.centerOffsets();
		baldur.centerOrigin();
		DataSaver.loadData(DataSaver.saveFile);
		var rawData:Bool = DataSaver.charms.get(BaldursBlessing);
		if (rawData == false) {
			baldur.alpha = 0;
		}
		add(baldur);

		var pos = backboard.getGraphicMidpoint();
		geo = new FlxSprite(pos.x - 60, pos.y - 20);
		pos.put();
		geo.cameras = [camera];
		geo.frames = Paths.getSparrowAtlas('SoulMeter/geo', 'hymns');
		geo.scale.set(0.8, 0.8);
		geo.updateHitbox();
		geo.animation.addByPrefix('init', 'geo-appear', 15, false);
		geo.animation.play('init', true);
		geo.antialiasing = ClientPrefs.data.antialiasing;
		add(geo);

		new FlxTimer().start(11 * (1 / 15), function(tmr:FlxTimer) {
			geotxt = new FlxText(FlxG.width * 0.7, 7, 0, "", 32);
			geotxt.setFormat(Constants.UI_FONT, 28, FlxColor.WHITE, RIGHT);
			var pos = geo.getGraphicMidpoint();
			geotxt.x = pos.x + (geo.width / 2);
			geotxt.y = pos.y - (geo.height / 2);
			geotxt.text = Std.string(DataSaver.geo);
			geotxt.cameras = [camera];
			geotxt.antialiasing = ClientPrefs.data.antialiasing;
			add(geotxt);

			geotxt.alpha = 0;
			FlxTween.tween(geotxt, {alpha: 1}, 1, {ease: FlxEase.quintOut});
		});
	}

	var sillyview:FlxTween;

	public function changebaldurview() {
		if (sillyview != null) {
			sillyview.cancel();
		}

		if (baldur.alpha > 0) {
			sillyview = FlxTween.tween(baldur, {alpha: 0}, 1, {ease: FlxEase.quintOut});
		} else {
			sillyview = FlxTween.tween(baldur, {alpha: 1}, 1, {ease: FlxEase.quintOut});
		}
	}

	var sillyview2:FlxTween;

	public function changeovercharmview() {
		if (sillyview2 != null) {
			sillyview2.cancel();
		}

		if (DataSaver.usedNotches > 5) {
			silly.alpha = 0.5;
			sillyview2 = FlxTween.tween(silly, {alpha: 1}, 1, {ease: FlxEase.quintInOut, type: FlxTweenType.PINGPONG});
		} else {
			sillyview2 = FlxTween.tween(silly, {alpha: 0}, 1, {ease: FlxEase.quintOut});
		}
	}

	function initMasks(backboard:FlxSprite, camera:FlxCamera) {
		maskList = [];
		for (i in 0...maxMasks) {
			var spacing:Int = -1;

			var mask:FlxSprite = new FlxSprite(backboard.x + 140, backboard.y + 35);
			mask.cameras = [camera];
			mask.frames = Paths.getSparrowAtlas('SoulMeter/Mask', 'hymns');
			mask.setGraphicSize(Std.int(mask.width * 0.66));
			mask.updateHitbox();
			mask.animation.addByPrefix('regen', 'maskrefill', 15, false);
			mask.animation.addByPrefix('full', 'maskidle', 15, true);
			mask.animation.addByPrefix('appear', 'maskappear', 15, false);
			mask.animation.addByPrefix('empty', 'maskshatter', 15, false);

			mask.x += (spacing + (mask.width / 2)) * i;

			mask.antialiasing = ClientPrefs.data.antialiasing;
			add(mask);

			mask.animation.play('empty', true);
			maskList.push(mask);
			mask.alpha = 0;
		}

		DataSaver.loadData(DataSaver.saveFile);
		var rawData:Bool = DataSaver.charms.get(LifebloodSeed);
		if (rawData == true) {
			for (i in 0...2) {
				var spacing:Int = -1;

				var mask:FlxSprite = new FlxSprite(backboard.x + 215, backboard.y + 5);
				mask.cameras = [camera];
				mask.frames = Paths.getSparrowAtlas('SoulMeter/LifeMask', 'hymns');
				mask.setGraphicSize(Std.int(mask.width * 0.66));
				mask.updateHitbox();
				mask.animation.addByPrefix('regen', 'lifemaskrefill', 15, false);
				mask.animation.addByPrefix('full', 'lifemaskidle', 15, true);
				mask.animation.addByPrefix('appear', 'lifemaskrefill', 15, false);
				mask.animation.addByPrefix('empty', 'lifebloodburst', 15, false);
				mask.animation.addByPrefix('waaa', 'lifemaskshatter', 15, false);

				mask.x += (spacing + (91 / 2)) * (i);

				mask.antialiasing = ClientPrefs.data.antialiasing;
				add(mask);

				mask.animation.play('empty', true);
				maskList.push(mask);
				mask.centerOrigin();
				mask.centerOffsets();
				mask.alpha = 0;
			}
			masks += 2;
		}

		maxMasks -= 1;
		masks -= 1;
	}

	var baldurd = false;

	public function changeMasks(amt:Int) {
		masks += amt;

		if (amt < 0) {
			FlxG.sound.play(Paths.soundRandom('Damage', 1, 4, 'hymns'));
		}

		if (baldur.alpha == 1) {
			if (masks < 0 && baldurd == false) {
				baldurd = true;
				masks = 4;
				baldur.animation.play('boom', true);
				baldur.centerOffsets();
				baldur.centerOrigin();

				FlxG.sound.play(Paths.sound('charm_baldur_revive_break', 'hymns'));

				PlayState.instance.baldursbreak();
			}
		}
	}

	public function showMasks() {
		initGeo(backBoard, camera2, '2078');

		new FlxTimer().start(4 * (1 / 24), function(tmr:FlxTimer) {
			var mask = maskList[maskList.length - tmr.loopsLeft - 1];
			mask.animation.play("appear", true);
			mask.centerOrigin();
			mask.centerOffsets();

			new FlxTimer().start(1 * (1 / 15), function(tmr:FlxTimer) {
				mask.alpha = 1;
			});

			if (maskList.length - tmr.loopsLeft >= maxMasks + 2) {
				mask.y -= 30;
				mask.x += 2;
			}

			var loopsies = tmr.loopsLeft;

			new FlxTimer().start(63 * (1 / 15), function(tmr:FlxTimer) {
				mask.animation.play("full", false);
				mask.x += .5;
				mask.y += .5;
				mask.centerOrigin();
				mask.centerOffsets();

				if (maskList.length - loopsies >= maxMasks + 2) {
					mask.y += 30;
					mask.x -= 4;
				}
			});
		}, maskList.length);
	}

	function getAlpha(soulAlph:Float):Float {
		var soulMeterAlpha = 0.55;

		if (Math.floor(0.37 * soul) == 0) {
			soulMeterAlpha = 0;
		}

		if (soul >= 33) {
			soulMeterAlpha = 1;
		}

		return soulMeterAlpha;
	}

	function burst() {
		soulBurst.alpha = 1;
		soulBurst.animation.play("goku", true);

		new FlxTimer().start(8 * (1 / 15), function(tmr:FlxTimer) {
			soulBurst.alpha = 0;
		});
	}

	var help:Bool = false;
	var kms:Bool = false;
	var timer:Int = 0;
	var alpha:Float = 0;

	var pingpongtween:FlxTween;

	override public function update(elapsed:Float) {
		soulMeter.update(elapsed);
		soulPulse.update(elapsed);
		backBoard.update(elapsed);
		soulBurst.update(elapsed);
		soulEyes.update(elapsed);
		if (baldur != null) {
			baldur.update(elapsed);
		}
		if (geo != null) {
			geo.update(elapsed);
		}

		if (geotxt != null) {
			geotxt.text = Std.string(DataSaver.geo);
		}

		for (i in 0...maskList.length) {
			var mask = maskList[i];
			mask.update(elapsed);

			if (mask.animation.curAnim.name != 'appear') {
				if (i > masks) {
					if (mask.animation.curAnim.name != 'empty') {
						mask.animation.play('empty', true);
						mask.centerOrigin();
						mask.centerOffsets();

						if (i > maxMasks) {
							mask.y -= 30;
						}
					}
				} else {
					if (mask.animation.curAnim.name != 'regen' && mask.animation.curAnim.name != 'full') {
						mask.animation.play('regen', true);
						mask.centerOrigin();
						mask.centerOffsets();
					}
				}
			}
			if (timer % 300 == 1) {
				if (mask.animation.curAnim.finished && mask.animation.curAnim.name == 'full') {
					mask.animation.play('full', true);
					mask.centerOrigin();
					mask.centerOffsets();
				}
			}
		}

		timer++;

		if (soul >= 99) {
			soul = 99;
		} else {
			if (soul <= 0) {
				soul = 0;
			}
		}

		if (soul >= 99) {
			if (kms == false) {
				kms = true;
				burst();
				alpha = 1;
				FlxG.sound.play(Paths.sound('focus_ready', 'hymns'));
			}
		} else {
			kms = false;
			alpha = 0;
		}

		soulPulse.alpha = FlxMath.lerp(soulPulse.alpha, alpha, elapsed * 2.4);

		if (soul >= 60) {
			if (help == false) {
				help = true;
				soulEyes.animation.play('enter', true);
			}
		} else {
			if (help == true) {
				help = false;
				soulEyes.animation.play('exit', true);
			}
		}

		var meow = Math.floor(0.37 * soul) + 1;

		if (soulMeter.animation.curAnim.name != Std.string(meow) && Math.min(meow, 36) != 30) {
			frameIndex = soulMeter.animation.curAnim.curFrame;
			soulMeter.animation.play(Std.string(Math.min(meow, 37)), true);
			soulMeter.y = ypossoul + 104 - 3 * (Math.min(meow, 34));
			if (Math.min(meow, 35) == 35) {
				soulMeter.y -= 1.5;
			}
			soulMeter.animation.curAnim.curFrame = frameIndex;
			if (Std.string(Math.min(meow, 37)) == "37") {
				soulMeter.animation.curAnim.curFrame = 0;
			}
		}

		soulMeter.alpha = getAlpha(soul);
		var singVar:Bool = (PlayState.bfCurAnim == 'idle' || PlayState.keysPressed.length == 0);

		if (FlxG.keys.justPressed.SPACE && singVar) {
			trace(masks < maxMasks);
			if (soul >= 33 && masks < maxMasks && soulCooldown == false) {
				healing = true;
				healingSoul = soul;
				PlayState.instance.boyfriend.playAnim("focusSTART", true);
				heal.play(true);
			}
		}

		if (healing == true && FlxG.keys.pressed.SPACE && singVar && soulCooldown == false) {
			trace(soul, healingSoul);
			if (soul >= (healingSoul - 33) && singVar) {
				DataSaver.loadData(DataSaver.saveFile);
				var rawData:Bool = DataSaver.charms.get(CriticalFocus);

				if (rawData) {
					if (masks <= maxMasks / 2) {
						soul -= 0.75 * 1.5;
					} else {
						soul -= 0.75;
					}
				} else {
					soul -= 0.75;
				}
			} else {
				soul = (healingSoul - 33);
			}

			// soulMeter.animation.curAnim.curFrame += 1;
			// soulMeter.animation.curAnim.curFrame = soulMeter.animation.curAnim.curFrame % 11;

			if (soul == (healingSoul - 33)) {
				PlayState.instance.boyfriend.playAnim("focusIMPACT", true);
				FlxG.sound.play(Paths.sound('focus_health_heal', 'hymns'));
				heal.stop();

				if (soul >= 33 && masks < maxMasks) {
					healingSoul = soul;
					healing = true;
					soulCooldown = true;
					new FlxTimer().start(0.35, function(tmr:FlxTimer) {
						if (healing == true) {
							soulCooldown = false;
							PlayState.instance.boyfriend.playAnim("focusLOOP", true);
							heal.play(true);
						}
					});
				} else {
					healing = false;
				}

				masks += 1;
				if (masks >= maxMasks) {
					healing = false;
					new FlxTimer().start(0.35, function(tmr:FlxTimer) {
						soulCooldown = false;
					});
				}
			}
		}

		if (FlxG.keys.justReleased.SPACE) {
			trace("stopped");
			if (healing == true && soulCooldown == false) {
				healing = false;
				soulCooldown = true;
				FlxTween.num(soul, healingSoul, 0.3, {ease: FlxEase.quintOut}, function(num) {
					soul = num;});
				PlayState.instance.boyfriend.playAnim("focusEND", true);
				heal.stop();
				new FlxTimer().start(0.35, function(tmr:FlxTimer) {
					soulCooldown = false;
				});
			}
		}

		if (healing == false) {
			heal.stop();
		}
	}

	public function missed() {
		masks -= 1;
	}
}
/*
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⣻⣿⢻⣿⣿⣿⡏⢻⣿⣿⣿⣿⢻⣿⣇⢸⣿⣿⣿⡇⢸⣿⡛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⡿⠛⠁⣤⣶⣿⣿⣿⠸⣿⣿⣿⡇⠀⢿⣿⣿⣿⠀⣿⣿⡀⢻⣿⣿⡇⢸⣿⡇⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⢋⣴⣾⠀⣿⣿⣿⣿⣿⠀⣿⣿⣿⡇⢀⠘⣿⣿⣿⠀⢸⣿⡧⠀⢻⡿⠀⣾⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⠀⢻⣿⣿⣿⣿⠀⢿⣿⣿⣇⢸⡄⠸⣿⣿⡄⢸⣿⣿⣷⣄⠀⣾⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⡆⢸⣿⣿⣿⣿⡄⢸⣿⣿⣿⠸⣿⡄⠙⣿⡇⢸⣿⣿⣿⣿⠀⢻⣿⣿⡗⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⠇⠘⣿⣿⣿⠀⣿⣿⣆⠈⠃⢸⣿⣿⣿⣿⠀⢸⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣧⣬⣿⣿⣿⣿⣦⣶⣿⣿⣿⣴⣿⣿⣿⣷⣶⣿⣿⣿⣿⣿⣦⣼⣿⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⢉⣭⣤⣤⣤⣬⣍⡙⠛⢿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠹⢿⣿⣿⣿⣿⣿⣿⣷⣄⠙⢿⣿⣿⣿⣿⣿
	⣿⣿⣿⠟⠋⣀⣴⣶⣶⡄⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠗⢂⣉⣿⣿⣿⣿⣿⣿⣿⣷⡈⢻⣿⣿⣿⣿
	⣿⣿⠋⢠⣾⣿⣿⣿⣿⣁⣤⡄⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣈⠛⠻⣿⣿⣿⣿⣿⣿⣷⡀⢻⣿⣿⣿
	⣿⠇⣠⣿⣿⣿⣿⣿⣿⣿⠏⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠸⣿⣿⣿⣿⣿⣿⣇⠘⣿⣿⣿
	⡟⠀⣿⣿⣿⣿⣿⣿⡿⠃⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢠⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿
	⡇⠠⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢛⣻⣿⣿⣿⣿⣿⣿⣿⣤⣌⢿⣿⣿⣿⣿⠟⢀⣾⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿
	⣇⠀⣿⣿⣿⣿⣿⣿⡇⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡿⠟⢋⣉⣭⣤⣶⣶⣶⣤⣬⣉⡙⠛⢋⣁⣴⣿⣿⣿⣿⣿⣿⣿⣿⡏⢠⣿⣿⣿
	⣿⡆⠹⣿⣿⣿⣿⣿⣿⣦⣄⠙⠛⠿⢿⣿⣿⣿⡿⠟⣩⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⢠⣾⣿⣿⣿
	⣿⣿⣄⠹⢿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣦⣤⣤⣶⣿⣿⣿⠿⢿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠉⠙⠻⣿⣿⣿⣿⣿⣿⣿⠟⢉⣴⣿⣿⠿⣋⣽
	⣿⣿⣿⣦⡈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠈⠻⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠈⠻⡈⢻⢛⣉⣤⣶⣿⣿⡟⣡⣾⣿⣿
	⣿⣿⣿⣿⣿⣷⣤⣈⠙⠻⢿⣿⣿⣿⣿⢻⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⢳⠀⣿⣿⣿⣿⣿⣿⣟⠻⢿⣿⣿
	⣿⣿⣿⣯⣉⣛⠿⠿⢿⣶⣶⣶⣶⣶⡏⢸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠿⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⢹⣿⣿⣿⣿⣿⣿⣷⣶⣦⣼
	⣿⣿⣿⣿⣿⣿⣿⣶⡶⢤⣿⣿⣿⣿⡇⢸⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠣⢀⡄⠀⠀⠀⠀⠀⠀⠀⢸⡇⠈⡿⠋⠁⠉⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⠿⠿⢛⣋⣡⣴⣿⣿⣿⣿⣿⣷⠈⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣴⣿⣿⣄⠀⠀⠀⠀⠀⣰⣿⡇⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿
	⣿⣿⣷⣶⣿⣿⣿⣿⣿⣿⠟⠛⠻⠿⢿⡆⠸⣿⣷⣄⡀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⡟⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠈⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⢀⣤⣦⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⣀⣀⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⣠⣾⣿⠃⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠻⣿⣷⣦⣄⡉⠙⠻⠿⠿⣿⣿⣿⠿⠿⠟⠉⣁⣴⣾⣿⣿⣥⣤⣄⠈⢻⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠈⠛⢻⣿⣿⣿⣶⡦⢀⣤⣤⣤⣤⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⣼⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⠀⢾⣿⣿⣿⣿⡏⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠋⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣉⠛⠛⢛⣃⡈⠻⢿⣿⣿⣿⣿⣿⣿⣿⡄⢠⣴⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣬⣉⣙⣉⣉⣤⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
 */
