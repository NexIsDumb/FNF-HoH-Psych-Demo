package overworld;

import haxe.macro.Expr.FieldType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween as OGTween;
import flixel.tweens.FlxEase;
import backend.Difficulty;
import backend.WeekData;
import backend.Highscore;
import backend.Song;

using StringTools;

class Shop extends FlxSpriteGroup {
	var main:FlxSprite;
	var notches:Array<FlxSprite> = [];
	var charmList:Array<Array<Dynamic>> = [];

	var arrowselection:Array<FlxSprite> = [];
	var titledesc:Array<FlxText> = [];

	var selected = 0;

	public var callback:Dynamic;

	var notch:FlxText;
	var desc1:FlxText;
	var title:FlxText;
	var selector:FlxSprite;
	var arrowtop:FlxSprite;
	var arrowbot:FlxSprite;

	var pointer1:FlxSprite;
	var pointer2:FlxSprite;

	var purchase:FlxText;
	var yes:FlxText;
	var no:FlxText;
	var title2:FlxText;
	var charmsy:FlxSprite;
	var gradient:FlxSprite;

	var caninteractter:Bool = false;
	var firsttime:Bool = true;
	var purchasedall:Bool = false;

	var controls(get, never):Controls;

	private function get_controls() {
		return Controls.instance;
	}

	public function new() {
		super();

		main = new FlxSprite(0, 0);
		main.frames = Paths.getSparrowAtlas('Shop/ShopMain', 'hymns');
		main.animation.addByPrefix("appear", "Symbool 2", 24, false);
		main.antialiasing = ClientPrefs.data.antialiasing;
		main.scale.set(0.8, 0.8);
		main.animation.play("appear");
		main.updateHitbox();
		add(main);

		notch = new FlxText(250, 220, FlxG.width / 4.75, "Notch Cost");
		notch.setFormat(Paths.font("perpetua.ttf"), 23, FlxColor.WHITE, CENTER);
		notch.antialiasing = ClientPrefs.data.antialiasing;
		add(notch);

		desc1 = new FlxText(250, 330, FlxG.width / 4.75, "null");
		desc1.setFormat(Paths.font("perpetua.ttf"), 23, FlxColor.WHITE, LEFT);
		desc1.antialiasing = ClientPrefs.data.antialiasing;
		add(desc1);

		title = new FlxText(250, 170, FlxG.width / 4.75, "null");
		title.setFormat(Paths.font("perpetua.ttf"), 32, FlxColor.WHITE, CENTER);
		title.antialiasing = ClientPrefs.data.antialiasing;
		add(title);

		title2 = new FlxText(main.getGraphicMidpoint().x - main.width / 6, 170, 0, "help");
		title2.setFormat(Paths.font("perpetua.ttf"), 32, FlxColor.WHITE, CENTER);
		title2.antialiasing = ClientPrefs.data.antialiasing;
		title2.screenCenter(X);
		title2.x -= main.width / 1.58;
		title2.alpha = 0;
		add(title2);

		charmsy = new FlxSprite(title2.x, 220).loadGraphic('hymns:assets/hymns/charms/Lifeblood Seed/base.png');
		charmsy.antialiasing = ClientPrefs.data.antialiasing;
		charmsy.scale.set(0.4, 0.4);
		charmsy.updateHitbox();
		charmsy.x -= charmsy.width / 3.25;
		charmsy.alpha = 0;
		add(charmsy);

		purchase = new FlxText(main.getGraphicMidpoint().x - main.width / 6, 350, 0, "Purchase this Item?");
		purchase.setFormat(Paths.font("perpetua.ttf"), 32, FlxColor.WHITE, CENTER);
		purchase.antialiasing = ClientPrefs.data.antialiasing;
		purchase.screenCenter(X);
		purchase.x -= main.width / 1.58;
		purchase.alpha = 0;
		add(purchase);

		yes = new FlxText(main.getGraphicMidpoint().x - main.width / 6, 420, 0, "Yes");
		yes.setFormat(Paths.font("perpetua.ttf"), 32, FlxColor.WHITE, CENTER);
		yes.antialiasing = ClientPrefs.data.antialiasing;
		yes.screenCenter(X);
		yes.x -= main.width / 1.58;
		yes.alpha = 0;
		add(yes);

		selected2 = yes;

		no = new FlxText(main.getGraphicMidpoint().x - main.width / 6, 480, 0, "No");
		no.setFormat(Paths.font("perpetua.ttf"), 32, FlxColor.WHITE, CENTER);
		no.antialiasing = ClientPrefs.data.antialiasing;
		no.screenCenter(X);
		no.x -= main.width / 1.58;
		no.alpha = 0;
		add(no);

		pointer1 = new FlxSprite(0, 0);
		pointer1.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer1.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer1.animation.play('idle', true);
		add(pointer1);
		pointer1.antialiasing = ClientPrefs.data.antialiasing;
		pointer1.setGraphicSize(Std.int(pointer1.width * 0.27));
		pointer1.updateHitbox();
		pointer1.alpha = 0;

		pointer2 = new FlxSprite(0, 0);
		pointer2.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer2.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer2.animation.play('idle', true);
		add(pointer2);
		pointer2.antialiasing = ClientPrefs.data.antialiasing;
		pointer2.flipX = true;
		pointer2.setGraphicSize(Std.int(pointer2.width * 0.27));
		pointer2.updateHitbox();
		pointer2.alpha = 0;

		var spr = yes;

		pointer1.screenCenter(X);
		pointer1.y = spr.getGraphicMidpoint().y - (spr.height / 4);
		pointer1.x -= (spr.width / 2) + pointer1.width / 1.5;
		pointer1.animation.play('idle', true);

		pointer2.screenCenter(X);
		pointer2.y = spr.getGraphicMidpoint().y - (spr.height / 4);
		pointer2.x += (spr.width / 2) + pointer1.width / 1.5;
		pointer2.animation.play('idle', true);

		pointer1.x -= main.width / 1.58;
		pointer2.x -= main.width / 1.58;

		selector = new FlxSprite(25, 300).loadGraphic(Paths.image('Shop/selector', 'hymns'));
		selector.scale.set(0.7, 0.7);
		selector.updateHitbox();
		selector.antialiasing = ClientPrefs.data.antialiasing;
		selector.active = false;
		add(selector);

		arrowtop = new FlxSprite(100, 265).loadGraphic(Paths.image('Shop/shoparrow', 'hymns'));
		arrowtop.scale.set(0.6, 0.6);
		arrowtop.updateHitbox();
		arrowtop.antialiasing = ClientPrefs.data.antialiasing;
		arrowtop.active = false;
		add(arrowtop);

		arrowbot = new FlxSprite(100, 380).loadGraphic(Paths.image('Shop/shoparrow', 'hymns'));
		arrowbot.scale.set(0.6, 0.6);
		arrowbot.flipY = true;
		arrowbot.updateHitbox();
		arrowbot.antialiasing = ClientPrefs.data.antialiasing;
		arrowbot.active = false;
		add(arrowbot);

		arrowselection.push(arrowtop);
		arrowselection.push(arrowbot);

		titledesc.push(title);
		titledesc.push(desc1);

		DataSaver.loadData(DataSaver.saveFile);
		var rawData:Bool = DataSaver.charmsunlocked.get("Swindler");

		if (rawData == false) {
			addCharm("Swindler",
				"",
				0, "50", "swindler");
		} else {
			DataSaver.loadData(DataSaver.saveFile);
			var rawData1:Bool = DataSaver.charmsunlocked.get("Baldur's Blessing");
			var rawData2:Bool = DataSaver.charmsunlocked.get("Lifeblood Seed");
			var rawData3:Bool = DataSaver.charmsunlocked.get("Critical Focus");

			addCharm("Baldur's Blessing",
				"Finding yourself running into trouble down below? Baldur shells are so tough that they are said to protect the wearer from harm! However it does not seem indestructible, so do take care.",
				3, "250", "bb");

			addCharm("Lifeblood Seed",
				"Need a little bit of a boost? Then this charm is the thing for you! Lifeblood may be seen as a bit of a taboo, but it certainly will make you feel healthier! Just don’t let anyone know who sold it to you.",
				2, "175", "lb");

			addCharm("Critical Focus",
				"If you have trouble focusing in dangerous situations, this is the charm for you! I heard that it can help the wearer gather “SOUL” when in danger, whatever that means.",
				2, "450", "cf");

			if (rawData1 && rawData2 && rawData3) {
				purchasedall = true;
			}
		}

		gradient = new FlxSprite(0, 0).loadGraphic(Paths.image('Shop/grad', 'hymns'));
		gradient.scale.set(0.8, 0.8);
		gradient.updateHitbox();
		gradient.antialiasing = ClientPrefs.data.antialiasing;
		gradient.active = false;
		gradient.x -= 11 * 0.8 / 2;
		gradient.y -= 11 * 0.8 / 2;
		gradient.alpha = 0;
		add(gradient);

		if (charmList.length > 0) {
			generateNotches(charmList[selected][2]);
			title.text = charmList[selected][4][0];
			desc1.text = charmList[selected][4][1];
		}

		main.alpha = 0;
		notch.alpha = 0;
		desc1.alpha = 0;
		title.alpha = 0;
		selector.alpha = 0;
		arrowtop.alpha = 0;
		arrowbot.alpha = 0;

		for (notch2 in notches) {
			notch2.alpha = 0;
		}

		function callbackk() {
			DataSaver.loadData(DataSaver.saveFile);
			if (purchasedall) {
				FlxTween.tween(OverworldManager.instance.player, {x: 597.828381914635}, .75, {ease: FlxEase.quintOut});
				OverworldManager.instance.player.flipX = true;
				OverworldManager.instance.player.animation.play("interacts");
				OverworldManager.instance.player.offset.set(99.6 + 5, 145.8 + 2.5);

				function filly() {
					new FlxTimer().start(.75, function(tmr:FlxTimer) {
						OverworldManager.instance.scene.inshop = false;
					});
					FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
					OverworldManager.instance.player.status.cripple = false;
					OverworldManager.instance.player.animation.play("interacte");
				}

				FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});

				OverworldManager.instance.dialogue.openBox("Sly",
					[["Back for more? I’m afraid I have nothing left to offer you. You’ve cleaned me out."], ["I believe I might have more items locked away in my storeroom, but I seem to have lost the key. So, no more business between us I’m afraid! Until that key shows up again at least…"]],
					function() {
						filly();
					});
			} else {
				if (firsttime == false || DataSaver.slytries > 0) {
					if (notch.alpha == 0) {
						caninteractter = false;
						FlxG.sound.play(Paths.sound("Sly_shop_open", 'hymns'));
						FlxTween.tween(OverworldManager.instance.player, {x: 597.828381914635}, .75, {ease: FlxEase.quintOut});
						OverworldManager.instance.player.flipX = true;
						OverworldManager.instance.player.animation.play("interacts");
						OverworldManager.instance.player.offset.set(99.6 + 5, 145.8 + 2.5);

						main.animation.play("appear");
						main.alpha = 1;

						FlxTween.tween(notch, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(desc1, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(title, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(selector, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(arrowtop, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(arrowbot, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});

						for (notch2 in notches) {
							FlxTween.tween(notch2, {alpha: 1}, 1.3, {ease: FlxEase.quintOut});
						}

						for (i in 0...charmList.length) {
							var array = charmList[i];
							var charmGroup = array[1];

							FlxTween.tween(charmGroup, {alpha: 1}, .5, {ease: FlxEase.quintOut});
						}

						new FlxTimer().start(1, function(tmr:FlxTimer) {
							gradient.alpha = 1;
							caninteractter = true;
						});
						new FlxTimer().start(.75, function(tmr:FlxTimer) {
							OverworldManager.instance.scene.inshop = true;
						});
					} else {
						caninteractter = false;
						main.animation.play("appear", true, true);

						gradient.alpha = 0;
						FlxTween.tween(notch, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(desc1, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(title, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(selector, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(arrowtop, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(arrowbot, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});

						for (notch2 in notches) {
							FlxTween.tween(notch2, {alpha: 0}, 1.3, {ease: FlxEase.quintOut});
						}

						new FlxTimer().start(1, function(tmr:FlxTimer) {
							FlxTween.tween(main, {alpha: 0}, .5, {ease: FlxEase.quintOut});
						});

						OverworldManager.instance.player.status.cripple = false;
					}
				} else {
					function filly() {
						FlxG.sound.play(Paths.sound("Sly_shop_open", 'hymns'));

						main.animation.play("appear");
						main.alpha = 1;

						FlxTween.tween(notch, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(desc1, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(title, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(selector, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(arrowtop, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
						FlxTween.tween(arrowbot, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});

						for (notch2 in notches) {
							FlxTween.tween(notch2, {alpha: 1}, 1.3, {ease: FlxEase.quintOut});
						}

						for (i in 0...charmList.length) {
							var array = charmList[i];
							var charmGroup = array[1];

							FlxTween.tween(charmGroup, {alpha: 1}, .5, {ease: FlxEase.quintOut});
						}

						new FlxTimer().start(1, function(tmr:FlxTimer) {
							gradient.alpha = 1;
						});
						FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
						new FlxTimer().start(1.45, function(tmr:FlxTimer) {
							caninteractter = true;
							OverworldManager.instance.scene.inshop = true;
						});
					}

					firsttime = false;
					FlxTween.tween(OverworldManager.instance.player, {x: 597.828381914635}, .75, {ease: FlxEase.quintOut});
					OverworldManager.instance.player.flipX = true;
					OverworldManager.instance.player.animation.play("interacts");
					OverworldManager.instance.player.offset.set(99.6 + 5, 145.8 + 2.5);

					DataSaver.loadData(DataSaver.saveFile);
					var rawData:Bool = DataSaver.charmsunlocked.get("Swindler");

					if (rawData == false) {
						FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});
						OverworldManager.instance.dialogue.openBox("Sly",
							[["Ah, Hello! I knew we'd meet again. Seems like you've gotten yourself a bit of a makeover, hm?"]],
							function() {
								filly();
							});
					} else {
						if (DataSaver.slytries == 0) {
							FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});
							OverworldManager.instance.dialogue.openBox("Sly",
								[["Oh, it's been quite some time since I've played like that. I must admit that it was quite enjoyable! As much as it pains me...a battle lost is a battle lost. Here, take your reward and leave me to my Geo.. unless you plan to purchase some more of my wares…"]],
								function() {
									DataSaver.slytries++;
									DataSaver.saveSettings(DataSaver.saveFile);
									filly();
								});
						} else {
							filly();
							FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
						}
					}
				}
			}
		}
		callback = callbackk;

		// callback();
		// changeselection(0);
	}

	function addCharm(name, desc, notch, price, image) {
		DataSaver.loadData(DataSaver.saveFile);
		if (DataSaver.charmsunlocked.get(name) == null || DataSaver.charmsunlocked.get(name) == false) {
			var charmGroup:FlxSpriteGroup = new FlxSpriteGroup(0, 0);
			add(charmGroup);

			trace('hymns:assets/hymns/charms/' + name + '/base.png');
			var charm:FlxSprite = new FlxSprite(45, 305).loadGraphic('hymns:assets/hymns/images/Menus/Charm/charms/' + image + '.png');
			charm.antialiasing = ClientPrefs.data.antialiasing;
			charm.scale.set(0.17, 0.17);
			charm.updateHitbox();
			charmGroup.add(charm);

			var geo:FlxSprite = new FlxSprite(135, 325);
			geo.cameras = [camera];
			geo.frames = Paths.getSparrowAtlas('SoulMeter/geo', 'hymns');
			geo.scale.set(0.5, 0.5);
			geo.updateHitbox();
			geo.animation.addByPrefix('init', 'geo', 15, false);
			geo.animation.play('init', true);
			geo.antialiasing = ClientPrefs.data.antialiasing;
			charmGroup.add(geo);

			var txt:FlxText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
			txt.setFormat(Constants.UI_FONT, 21, FlxColor.WHITE, RIGHT);
			txt.x = geo.getGraphicMidpoint().x;
			txt.y = geo.getGraphicMidpoint().y - (geo.height / 1.25) - 2.5;
			txt.text = price;
			txt.antialiasing = ClientPrefs.data.antialiasing;
			charmGroup.add(txt);

			var dist = 2.0;
			if (charmList.length > 1) {
				dist = 1.6;
			}

			charmGroup.y += charmGroup.height * dist * charmList.length;
			charmGroup.alpha = 0;

			charmList.push(
				[charmGroup.height, charmGroup, notch, price, [name, desc], image
				]
			);
		}
	}

	function generateNotches(notche) {
		if (notches.length > 0) {
			for (i in 0...notches.length) {
				var notchie = notches[0];
				notches.remove(notchie);
				notchie.destroy();
			}
		}
		notch.visible = false;
		for (i in 0...notche) {
			notch.visible = true;
			var spacing:Float = 10;

			var notch = new FlxSprite(350, 260).loadGraphic(Paths.image('Shop/fillednotch', 'hymns'));
			notch.scale.set(0.5, 0.5);
			notch.updateHitbox();
			notch.antialiasing = ClientPrefs.data.antialiasing;
			add(notch);

			notch.x += (spacing + (notch.width / 3)) * i;
			notch.x -= (spacing + (notch.width / 3)) * ((notche - 1) / 2);
			notches.push(notch);
		}
	}

	function changeselection(amt:Int) {
		if (selected + amt != charmList.length && selected + amt != -1) {
			selected += amt;

			generateNotches(charmList[selected][2]);
			titledesc[0].text = charmList[selected][4][0];
			titledesc[1].text = charmList[selected][4][1];
			trace(charmList.length);
			for (i in 0...charmList.length) {
				var array = charmList[i];
				var charmGroup = array[1];
				var pos = i - selected;

				var dist = 2.0;
				if (pos > 1 || pos < -1) {
					dist = 1.6;
				}

				// var targetPos = (array[0] * dist * pos) - charmGroup.y;
				OGTween.num(charmGroup.y, (array[0] * dist * pos), .5, {ease: FlxEase.quintOut}, function(num) {
					charmGroup.setPosition(FlxG.width / 2 + 35, num);});
			}

			if (amt > 0) {
				arrowselection[1].y = 380 + 7.5;
				FlxTween.tween(arrowselection[1], {y: 380}, .5, {ease: FlxEase.quintOut});
			} else {
				if (amt < 0) {
					arrowselection[0].y = 265 - 7.5;
					FlxTween.tween(arrowselection[0], {y: 265}, .5, {ease: FlxEase.quintOut});
				}
			}
		}
	}

	var isbuying:Bool = false;
	var selected2:FlxSprite;

	override public function update(elapsed:Float) {
		main.update(elapsed);
		pointer1.update(elapsed);
		pointer2.update(elapsed);

		#if debug
		if (FlxG.keys.justPressed.J) {
			DataSaver.loadData(DataSaver.saveFile);
			DataSaver.geo += 1000;
			DataSaver.saveSettings(DataSaver.saveFile);
		}
		#end

		if (caninteractter && OverworldManager.instance.scene.inshop) {
			if (!isbuying) {
				if (controls.UI_DOWN_P) {
					changeselection(1);
				}
				if (controls.UI_UP_P) {
					changeselection(-1);
				}

				trace(controls.UI_UP_P);
			} else {
				if (controls.UI_DOWN_P) {
					if (selected2 == yes)
						selected2 = no;
					else
						selected2 = yes;

					pointer1.screenCenter(X);
					pointer1.y = selected2.getGraphicMidpoint().y - (selected2.height / 4);
					pointer1.x -= (selected2.width / 2) + pointer1.width / 1.5;
					pointer1.animation.play('idle', true);

					pointer2.screenCenter(X);
					pointer2.y = selected2.getGraphicMidpoint().y - (selected2.height / 4);
					pointer2.x += (selected2.width / 2) + pointer1.width / 1.5;
					pointer2.animation.play('idle', true);

					pointer1.x += main.width / 1.58;
					pointer1.x -= selected2.width + 5;
					pointer2.x += main.width / 1.58;
					pointer2.x -= selected2.width + 5;
				}
				if (controls.UI_UP_P) {
					if (selected2 == yes)
						selected2 = no;
					else
						selected2 = yes;

					pointer1.screenCenter(X);
					pointer1.y = selected2.getGraphicMidpoint().y - (selected2.height / 4);
					pointer1.x -= (selected2.width / 2) + pointer1.width / 1.5;
					pointer1.animation.play('idle', true);

					pointer2.screenCenter(X);
					pointer2.y = selected2.getGraphicMidpoint().y - (selected2.height / 4);
					pointer2.x += (selected2.width / 2) + pointer1.width / 1.5;
					pointer2.animation.play('idle', true);

					pointer1.x += main.width / 1.58;
					pointer1.x -= selected2.width + 5;
					pointer2.x += main.width / 1.58;
					pointer2.x -= selected2.width + 5;
				}
			}

			if (controls.BACK && OverworldManager.instance.scene.inshop) {
				if (!isbuying) {
					caninteractter = false;
					new FlxTimer().start(.25, function(tmr:FlxTimer) {
						callback();
						FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});

						for (i in 0...charmList.length) {
							var array = charmList[i];
							var charmGroup = array[1];

							FlxTween.tween(charmGroup, {alpha: 0}, .5, {ease: FlxEase.quintOut});
						}

						new FlxTimer().start(1.45, function(tmr:FlxTimer) {
							caninteractter = true;
							OverworldManager.instance.scene.inshop = false;
						});
					});
				} else {
					FlxTween.tween(notch, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(desc1, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(title, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(selector, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(arrowtop, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(arrowbot, {alpha: 1}, .6, {ease: FlxEase.quintOut});

					for (i in 0...charmList.length) {
						var array = charmList[i];
						var charmGroup = array[1];
						FlxTween.tween(charmGroup, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					}

					for (i in 0...notches.length) {
						var notchie = notches[i];
						FlxTween.tween(notchie, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					}

					FlxTween.tween(purchase, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(yes, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(no, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(title2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(charmsy, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(pointer1, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(pointer2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					isbuying = false;
				}
			}

			if (isbuying == false && notch.alpha != 0) {
				if (controls.ACCEPT) {
					caninteractter = false;
					isbuying = true;
					FlxTween.tween(notch, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(desc1, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(title, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(selector, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(arrowtop, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(arrowbot, {alpha: 0}, .6, {ease: FlxEase.quintOut});

					for (i in 0...charmList.length) {
						var array = charmList[i];
						var charmGroup = array[1];

						FlxTween.tween(charmGroup, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					}

					for (i in 0...notches.length) {
						var notchie = notches[i];
						FlxTween.tween(notchie, {alpha: 0}, .6, {ease: FlxEase.quintOut});
					}

					FlxTween.tween(purchase, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(yes, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(no, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(title2, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(charmsy, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(pointer1, {alpha: 1}, .6, {ease: FlxEase.quintOut});
					FlxTween.tween(pointer2, {alpha: 1}, .6, {ease: FlxEase.quintOut});

					purchase.text = "Purchase this Item?";
					title2.text = charmList[selected][4][0];

					title2.updateHitbox();
					title2.screenCenter(X);
					title2.x += main.width / 1.75;

					charmsy.loadGraphic('hymns:assets/hymns/images/Menus/Charm/charms/' + charmList[selected][5] + '.png');
					charmsy.antialiasing = ClientPrefs.data.antialiasing;
					charmsy.scale.set(0.4, 0.4);
					charmsy.updateHitbox();

					title2.x = main.x + main.width / 2 - title2.width / 2;

					new FlxTimer().start(.7, function(tmr:FlxTimer) {
						caninteractter = true;
					});
				}
			} else {
				if (controls.ACCEPT && isbuying == true) {
					DataSaver.loadData(DataSaver.saveFile);

					if (selected2 == yes) {
						if (DataSaver.geo >= Std.parseInt(charmList[selected][3])) {
							DataSaver.charmsunlocked.set(charmList[selected][4][0], true);
							DataSaver.geo -= Std.parseInt(charmList[selected][3]);
							DataSaver.saveSettings(DataSaver.saveFile);
							FlxG.sound.play(Paths.sound("geo_deplete_count_down", 'hymns'));

							if (charmList[selected][4][0] == "Swindler") {
								caninteractter = false;
								FlxTween.tween(purchase, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(yes, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(no, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(title2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(charmsy, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(pointer1, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(pointer2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								main.animation.play("appear", true, true);
								gradient.alpha = 0;

								FlxTween.tween(notch, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(desc1, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(title, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(selector, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(arrowtop, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(arrowbot, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});

								for (notch2 in notches) {
									FlxTween.tween(notch2, {alpha: 0}, 1.3, {ease: FlxEase.quintOut});
								}

								new FlxTimer().start(1, function(tmr:FlxTimer) {
									FlxTween.tween(main, {alpha: 0}, .5, {ease: FlxEase.quintOut});
								});

								function filly() {
									Difficulty.resetList();
									PlayState.storyDifficulty = 1;

									var songLowercase:String = Paths.formatToSongPath("Swindler");
									var poop:String = Highscore.formatSong(songLowercase, 1);

									PlayState.SONG = Song.loadFromJson(poop, songLowercase);
									PlayState.storyDifficulty = 1;
									PlayState.isStoryMode = true;
									LoadingState.loadAndSwitchState(new PlayState());

									FlxG.sound.music.volume = 0;
								}

								FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});
								new FlxTimer().start(.6, function(tmr:FlxTimer) {
									OverworldManager.instance.dialogue.openBox("Sly",
										[["Oh! You wish to sing? Hmm… it's rare for someone to challenge me..."], ["Alright, I accept! I must say that I am not much of a singer myself… but I am curious about your skills."]],
										function() {
											filly();
										});
								});
							} else {
								caninteractter = false;
								for (i in 0...charmList.length) {
									var array = charmList[i];
									var charmGroup = array[1];

									if (i == selected) {
										charmGroup.destroy();
									} else {
										// FlxTween.tween(charmGroup, {alpha: 1}, .6, {ease: FlxEase.quintOut});
									}
								}
								charmList.remove(charmList[selected]);
								isbuying = false;

								FlxTween.tween(purchase, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(yes, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(no, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(title2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(charmsy, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(pointer1, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								FlxTween.tween(pointer2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
								main.animation.play("appear", true, true);
								gradient.alpha = 0;

								FlxTween.tween(notch, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(desc1, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(title, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(selector, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(arrowtop, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
								FlxTween.tween(arrowbot, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});

								for (notch2 in notches) {
									FlxTween.tween(notch2, {alpha: 0}, 1.3, {ease: FlxEase.quintOut});
								}

								new FlxTimer().start(1, function(tmr:FlxTimer) {
									FlxTween.tween(main, {alpha: 0}, .5, {ease: FlxEase.quintOut});
								});

								function filly() {
									DataSaver.loadData(DataSaver.saveFile);
									var rawData1:Bool = DataSaver.charmsunlocked.get("Baldur's Blessing");
									var rawData2:Bool = DataSaver.charmsunlocked.get("Lifeblood Seed");
									var rawData3:Bool = DataSaver.charmsunlocked.get("Critical Focus");
									if (rawData1 && rawData2 && rawData3) {
										caninteractter = true;
										new FlxTimer().start(.75, function(tmr:FlxTimer) {
											OverworldManager.instance.scene.inshop = false;
										});
										purchasedall = true;
										callback();
										FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
									} else {
										FlxG.sound.play(Paths.sound("Sly_shop_open", 'hymns'));
										main.animation.play("appear");
										main.alpha = 1;
										new FlxTimer().start(1, function(tmr:FlxTimer) {
											gradient.alpha = 1;
										});

										FlxTween.tween(notch, {alpha: 1}, .6, {ease: FlxEase.quintOut});
										FlxTween.tween(desc1, {alpha: 1}, .6, {ease: FlxEase.quintOut});
										FlxTween.tween(title, {alpha: 1}, .6, {ease: FlxEase.quintOut});
										FlxTween.tween(selector, {alpha: 1}, .6, {ease: FlxEase.quintOut});
										FlxTween.tween(arrowtop, {alpha: 1}, .6, {ease: FlxEase.quintOut});
										FlxTween.tween(arrowbot, {alpha: 1}, .6, {ease: FlxEase.quintOut});

										for (i in 0...charmList.length) {
											var array = charmList[i];
											var charmGroup = array[1];
											FlxTween.tween(charmGroup, {alpha: 1}, .6, {ease: FlxEase.quintOut});
										}

										for (i in 0...notches.length) {
											var notchie = notches[i];
											FlxTween.tween(notchie, {alpha: 1}, .6, {ease: FlxEase.quintOut});
										}
										new FlxTimer().start(.7, function(tmr:FlxTimer) {
											caninteractter = true;
										});
										changeselection(0);
									}
								}

								FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});

								var rawData1:Bool = DataSaver.charmsunlocked.get("Baldur's Blessing");
								var rawData2:Bool = DataSaver.charmsunlocked.get("Lifeblood Seed");
								var rawData3:Bool = DataSaver.charmsunlocked.get("Critical Focus");
								if (rawData1 && rawData2 && rawData3) {
									new FlxTimer().start(.6, function(tmr:FlxTimer) {
										OverworldManager.instance.dialogue.openBox("Sly",
											[["I’m afraid I have nothing left to offer you. You’ve cleaned me out."]],
											function() {
												caninteractter = true;
												purchasedall = true;
												new FlxTimer().start(.75, function(tmr:FlxTimer) {
													OverworldManager.instance.scene.inshop = false;
												});
												OverworldManager.instance.player.status.cripple = false;
												OverworldManager.instance.player.animation.play("interacte");
												FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
											});
									});
								} else {
									new FlxTimer().start(.6, function(tmr:FlxTimer) {
										OverworldManager.instance.dialogue.openBox("Sly",
											[["Thank you for your kind patronage! I assure you, my other wares are worth a look at as well! They may even increase your chances at survival down below…"]],
											function() {
												filly();
											});
									});
								}
							}
						} else {
							isbuying = false;

							caninteractter = false;
							FlxTween.tween(purchase, {alpha: 0}, .6, {ease: FlxEase.quintOut});
							FlxTween.tween(yes, {alpha: 0}, .6, {ease: FlxEase.quintOut});
							FlxTween.tween(no, {alpha: 0}, .6, {ease: FlxEase.quintOut});
							FlxTween.tween(title2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
							FlxTween.tween(charmsy, {alpha: 0}, .6, {ease: FlxEase.quintOut});
							FlxTween.tween(pointer1, {alpha: 0}, .6, {ease: FlxEase.quintOut});
							FlxTween.tween(pointer2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
							main.animation.play("appear", true, true);
							gradient.alpha = 0;

							FlxTween.tween(notch, {alpha: 0.01}, 1.2, {ease: FlxEase.quintOut});
							FlxTween.tween(desc1, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
							FlxTween.tween(title, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
							FlxTween.tween(selector, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
							FlxTween.tween(arrowtop, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
							FlxTween.tween(arrowbot, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});

							for (notch2 in notches) {
								FlxTween.tween(notch2, {alpha: 0}, 1.3, {ease: FlxEase.quintOut});
							}

							new FlxTimer().start(1, function(tmr:FlxTimer) {
								FlxTween.tween(main, {alpha: 0}, .5, {ease: FlxEase.quintOut});
							});

							function filly() {
								caninteractter = true;
								new FlxTimer().start(.75, function(tmr:FlxTimer) {
									OverworldManager.instance.scene.inshop = false;
								});
								callback();
								FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
							}

							FlxTween.tween(OverworldManager.instance.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});
							new FlxTimer().start(.7, function(tmr:FlxTimer) {
								OverworldManager.instance.dialogue.openBox("Sly",
									[["Pockets feeling empty? If you are on the hunt for more geo, the ruins below have much to offer!"]],
									function() {
										filly();
									});
							});
						}
					} else {
						FlxTween.tween(notch, {alpha: 1}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(desc1, {alpha: 1}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(title, {alpha: 1}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(selector, {alpha: 1}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(arrowtop, {alpha: 1}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(arrowbot, {alpha: 1}, .6, {ease: FlxEase.quintOut});

						for (i in 0...charmList.length) {
							var array = charmList[i];
							var charmGroup = array[1];
							FlxTween.tween(charmGroup, {alpha: 1}, .6, {ease: FlxEase.quintOut});
						}

						for (i in 0...notches.length) {
							var notchie = notches[i];
							FlxTween.tween(notchie, {alpha: 1}, .6, {ease: FlxEase.quintOut});
						}

						FlxTween.tween(purchase, {alpha: 0}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(yes, {alpha: 0}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(no, {alpha: 0}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(title2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(charmsy, {alpha: 0}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(pointer1, {alpha: 0}, .6, {ease: FlxEase.quintOut});
						FlxTween.tween(pointer2, {alpha: 0}, .6, {ease: FlxEase.quintOut});
						isbuying = false;
					}
				}
			}
		}
	}
}

class FlxTween // I cant waste time in rewriting nld's awful code because of the imminent release, so  - Nex
{
	public static function tween(Object:Dynamic, Values:Dynamic, Duration:Float = 1, ?Options) {
		OGTween.cancelTweensOf(Object);
		return OGTween.tween(Object, Values, Duration, Options);
	}
}
