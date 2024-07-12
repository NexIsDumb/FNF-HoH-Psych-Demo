package overworld.scenes;

import haxe.macro.Type.MethodKind;
import objects.Character;
import openfl.display.BlendMode;
import backend.ObjectBlendMode;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import overworld.scenes.charms.*;
import overworld.scenes.*;
import backend.Difficulty;
import backend.WeekData;
import backend.Highscore;
import backend.Song;

class Dirtmouth extends BaseScene {
	public var group:FlxTypedSpriteGroup<FlxSprite>;

	var fog:FlxSprite;
	var thefog:Array<FlxSprite> = [];
	var infectionAmbience:FlxTypedEmitter<FlxParticle>;
	var lights4:FlxSprite;
	var elderbug:FlxSprite;
	var slyShopSprite:FlxSprite;
	var playerfog:FlxSprite;
	var interactionBackdrop:FlxSprite;

	override public function new() {
		super();
	}

	override public function variableInitialize() {
		stageproperties.minCam = -592;
		stageproperties.maxCam = 1879;

		stageproperties.minX = stageproperties.minCam - FlxG.width + game.player.width * 1.5;
		stageproperties.maxX = stageproperties.maxCam + FlxG.width - game.player.width * 2.5;

		stageproperties.interactionpoints = [
			[elderbug.x, "elderbuginteract"],
			[slyShopSprite.x + slyShopSprite.width / 1.45, "doorinteract"],
			[game.player.x + 10, "silly"]
		];
		trace(slyShopSprite.x + slyShopSprite.width / 1.45);
	}

	override public function create() {
		// Add everything that isn't added later in createPost
		var sprites:Array<Dynamic> = [
			{
				name: 'bg',
				image: 'Overworld/bg',
				scrollFactor: {x: 0.7, y: 0.7},
				yOffset: -150
			},
			{name: 'townmidbehind', image: 'Overworld/townmidbehind', scrollFactor: {x: 0.68, y: 0.68}},
			{name: 'townmidsmallhouse', image: 'Overworld/townmidsmallhouse', scrollFactor: {x: 0.7, y: 0.7}},
			{name: 'townmidbighouse', image: 'Overworld/townmidbighouse', scrollFactor: {x: 0.73, y: 0.73}},
			{name: 'townmid', image: 'Overworld/townmid', scrollFactor: {x: 0.75, y: 0.75}},
			{
				name: 'lights2',
				image: 'Overworld/lighting/lights2',
				scrollFactor: {x: 0.75, y: 0.75},
				blend: MULTIPLY,
				alpha: 0.8,
				yOffset: -50
			},
			{name: 'lamp1', image: 'Overworld/lamp1', scrollFactor: {x: 1.005, y: 1.005}},
			{
				name: 'lights4',
				image: 'Overworld/lighting/lights4',
				scrollFactor: {x: 0.87, y: 0.87},
				blend: SCREEN,
				yOffset: -50
			},
			{
				name: 'lights3',
				image: 'Overworld/lighting/lights3',
				scrollFactor: {x: 0.9, y: 0.9},
				blend: ADD,
				alpha: 0.2
			},
			{name: 'bench', image: 'Overworld/bench', yOffset: FlxG.height / 3 + 50},
			{name: 'buildingfront4', image: 'Overworld/buildingfront4', scrollFactor: {x: 0.8, y: 0.8}},
			{name: 'buildingfront3', image: 'Overworld/buildingfront3', scrollFactor: {x: 0.85, y: 0.85}},
			{name: 'buildingfront2', image: 'Overworld/buildingfront2', scrollFactor: {x: 0.9, y: 0.9}},
			{name: 'buildingfront1', image: 'Overworld/buildingfront1', scrollFactor: {x: 0.95, y: 0.95}},
			{
				name: 'lights5',
				image: 'Overworld/lighting/lights5',
				scrollFactor: {x: 0.9, y: 0.9},
				blend: SCREEN,
				alpha: 0.5
			},
			{name: 'lamp2', image: 'Overworld/lamp2', scrollFactor: {x: 1.005, y: 1.005}},
			{
				name: 'slyShopSprite',
				frames: 'Overworld/DMShopSly',
				scrollFactor: {x: 1.06, y: 1.06},
				yOffset: 15,
				xOffset: -FlxG.width / 1.35
			},
			{name: 'stagstation', image: 'Overworld/stagstation'},
			{name: 'corniferandbretta', image: 'Overworld/corniferandbretta', scrollFactor: {x: 1.005, y: 1.005}}
		];
		for (sprite in sprites)
			makeSprites(sprite);

		// Is shop unlocked
		DataSaver.loadData(DataSaver.saveFile);
		if (DataSaver.unlocked.exists("slydoor")) {
			if (DataSaver.unlocked.get("slydoor") != null) {
				slyShopSprite.animation.play('open', true);
				slyShopSprite.y -= 125;
			}
		}

		// Adding character:

		elderbug = new FlxSprite(0, 0);
		elderbug.frames = Paths.getSparrowAtlas('Overworld/Elderbug', 'hymns');
		elderbug.scale.set(0.33, 0.33);
		elderbug.updateHitbox();
		elderbug.screenCenterXY();
		elderbug.y += 160;
		elderbug.x -= FlxG.width / 4;
		elderbug.animation.addByPrefix('idle', 'elderbug town idle0', 24, true);
		elderbug.animation.addByPrefix('turnLeft', 'elderbug turn left0', 24, false);
		elderbug.animation.addByIndices('turnLeftFrame', 'elderbug turn left0', [9], "", 24, false);
		elderbug.animation.addByPrefix('turnRight', 'elderbug turn left0', 24, false);
		elderbug.animation.addByPrefix('talk', 'elderbug talk loop0', 24, true);
		elderbug.animation.addByPrefix('talkL', 'elderbug talk loop left0', 24, true);
		elderbug.animation.play('idle', true);
		elderbug.centerOrigin();
		elderbug.antialiasing = ClientPrefs.data.antialiasing;
		add(elderbug);

		// Prompt Flair for interaction
		interactionflair = new FlxSprite(0, elderbug.getGraphicMidpoint().y - elderbug.height * 2.25);
		interactionflair.scale.set(0.9, 0.9);
		interactionflair.updateHitbox();
		interactionflair.frames = Paths.getSparrowAtlas('Overworld/PromptFlair', 'hymns');
		interactionflair.animation.addByPrefix("appear", "promptappear", 24, false);
		interactionflair.animation.addByPrefix("idle", "promptidle", 24, true);
		interactionflair.animation.addByPrefix("disappear", "promptdisappear", 24, false);
		interactionflair.animation.play("disappear");
		interactionflair.alpha = 0;

		playerfog = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/glow', 'hymns'));
		playerfog.antialiasing = ClientPrefs.data.antialiasing;
		playerfog.blend = ADD;
		playerfog.scale.set(0.8, 0.8);
		playerfog.updateHitbox();
		playerfog.alpha = 0.65;
	}

	var fences:FlxSprite;

	function makeSprites(sprite:Dynamic) {
		var addedSprite:FlxSprite;
		// TODO: replace Reflect.hasField with something faster
		if (!Reflect.hasField(sprite, 'frames')) {
			addedSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(sprite.image, 'hymns'));
		} else {
			addedSprite = new FlxSprite(0, 0);
			addedSprite.frames = Paths.getSparrowAtlas(sprite.frames, 'hymns');
		}
		addedSprite.antialiasing = ClientPrefs.data.antialiasing;
		if (Reflect.hasField(sprite, 'scrollFactor')) {
			addedSprite.scrollFactor.set(sprite.scrollFactor.x, sprite.scrollFactor.y);
		}
		addedSprite.screenCenterXY();
		addedSprite.updateHitbox();
		if (Reflect.hasField(sprite, 'yOffset')) {
			addedSprite.y += sprite.yOffset;
		}
		if (Reflect.hasField(sprite, 'xOffset')) {
			addedSprite.x += sprite.xOffset;
		}
		if (Reflect.hasField(sprite, 'blend')) {
			addedSprite.blend = sprite.blend;
		}
		if (Reflect.hasField(sprite, 'alpha')) {
			addedSprite.alpha = sprite.alpha;
		}
		// trace(sprite.name);
		switch (sprite.name) {
			case "lights4": lights4 = addedSprite;
			case "slyShopSprite":
				addedSprite.animation.addByPrefix('door', 'ShopDoorIdleClosed', 15, false);
				addedSprite.animation.addByPrefix('open', 'ShopDoorCloseToOpen', 15, false);
				addedSprite.animation.play('door', true);
				slyShopSprite = addedSprite;
			case "fences": fences = addedSprite;
		}
		add(addedSprite);
		return addedSprite;
	}

	override public function createPost() {
		add(playerfog);
		game.player.benchpos = [
			(stageproperties.minCam + stageproperties.maxCam) / 2 - (game.player.width / 2),
			game.player.y - 20
		];
		game.player.oldy = game.player.y;

		var sprites:Array<Dynamic> = [
			{
				name: "roadmain",
				image: 'Overworld/roadmain',
				yOffset: 100,
				scrollFactor: {x: 1, y: 1}
			},
			{
				name: "roadmain2",
				image: 'Overworld/roadmain',
				yOffset: 0,
				scrollFactor: {x: 1, y: 1}
			},
			{name: "road2", image: 'Overworld/road2', scrollFactor: {x: 1.05, y: 1.05}},
			{name: "road3", image: 'Overworld/road3', scrollFactor: {x: 1.1, y: 1.1}},
			{name: "road4", image: 'Overworld/road4', scrollFactor: {x: 1.15, y: 1.15}},
			{name: "road5", image: 'Overworld/road5', scrollFactor: {x: 1.2, y: 1.2}},
			{name: "poles", image: 'Overworld/poles', scrollFactor: {x: 1.2, y: 1.2}},
			{name: "fences", image: 'Overworld/fences', scrollFactor: {x: 1.2, y: 1.2}},
			{name: "lamplights", image: 'Overworld/lamplights', scrollFactor: {x: 1.005, y: 1.005}}
		];
		for (sprite in sprites)
			makeSprites(sprite);

		if (!ClientPrefs.data.lowQuality) {
			makeSprites({
				name: 'lights1',
				image: 'Overworld/lighting/lights1',
				scrollFactor: {x: 1.005, y: 1.005},
				blend: ADD,
				alpha: 0.75
			});
		}

		var fog:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/dmfogtextu1', 'hymns'));
		fog.antialiasing = ClientPrefs.data.antialiasing;
		fog.alpha = 0.75;
		fog.scale.set(8, 8);
		fog.updateHitbox();
		fog.screenCenterXY();
		fog.blend = ADD;
		add(fog);

		fog.x -= FlxG.width * 4.25;
		pos = fog.x;
		fog.y -= 775;
		thefog.push(fog);
		ypos = fog.y;
		fog.y -= FlxG.random.int(25, 50);

		new FlxTimer().start(10, function(tmr:FlxTimer) {
			var fog:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/dmfogtextu2', 'hymns'));
			fog.antialiasing = ClientPrefs.data.antialiasing;
			fog.alpha = 0.75;
			fog.scale.set(8, 8);
			fog.updateHitbox();
			fog.screenCenterXY();
			fog.blend = ADD;
			add(fog);

			fog.x -= FlxG.width * 4;
			fog.y -= 775;
			thefog.push(fog);
			ypos = fog.y;
			fog.y -= FlxG.random.int(25, 50);
		});

		// interactionflair
		interactionBackdrop = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/textthing', 'hymns'));
		interactionBackdrop.antialiasing = ClientPrefs.data.antialiasing;
		interactionBackdrop.alpha = 0;
		interactionBackdrop.updateHitbox();
		add(interactionBackdrop);

		add(interactionflair);

		interactiontext = new FlxText(0, interactionflair.getGraphicMidpoint().y - interactionflair.height / 5, 0, 'Interact', 28);
		interactiontext.setFormat(Constants.UI_FONT, 32, FlxColor.WHITE, CENTER);
		interactiontext.antialiasing = ClientPrefs.data.antialiasing;
		interactiontext.alpha = 0;
		add(interactiontext);
	}

	var interactionflair:FlxSprite;
	var interactiontext:FlxText;

	var angle = 0.5;
	var pos:Float = 0;
	var ypos:Float = 0;
	var indialogue = false;

	override function update(elapsed:Float) {
		elderbug.update(elapsed);
		slyShopSprite.update(elapsed);
		interactionflair.update(elapsed);
		if (charmsaquire != null) {
			charmsaquire.update(elapsed);
		}
		playerfog.x = game.player.x - (playerfog.width / 2);
		playerfog.y = game.player.y - (playerfog.height / 2) + (game.player.height / 2);
		for (i in 0...thefog.length) {
			var fog = thefog[i];
			fog.x += FlxG.random.int(10, 15) * (ClientPrefs.data.framerate / 60);
			fog.angle += angle * FlxG.random.int(-2, 2, [0]) * (ClientPrefs.data.framerate / 60);
			fog.y += FlxG.random.int(-5, 5) * (ClientPrefs.data.framerate / 60);

			if (!fog.isOnScreen()) {
				fog.angle = 0;
				fog.loadGraphic(Paths.image('Overworld/dmfogtextu' + FlxG.random.int(1, 3), 'hymns'));
				pos = game.camFollow.x - (FlxG.width * 3.5);
				fog.x = pos;
				fog.y = ypos;
				fog.y -= FlxG.random.int(25, 50);

				angle = angle * FlxG.random.int(-1, 1, [0]);
				fog.alpha = FlxG.random.float(0.5, 0.8);
			}
		}

		var totallythexvalue = lights4.x + (lights4.width / 2);
		var distancefromcenter = (FlxG.width * 4) - Math.abs(totallythexvalue - game.player.x) / (FlxG.width * 2) - 5119;
		if (game.player.x > (totallythexvalue - (game.player.width / 2) - (FlxG.width)) && game.player.x < (totallythexvalue + (FlxG.width))) {
			lights4.alpha = lights4.alpha + (distancefromcenter - lights4.alpha) * CoolUtil.boundTo(elapsed * 4.2, 0, 1);
		} else {
			lights4.alpha = lights4.alpha + (.5 - lights4.alpha) * CoolUtil.boundTo(elapsed * 4.2, 0, 1);
		}

		if (game.player.x < elderbug.x) {
			if (elderbug.animation.curAnim.name != "talkL") {
				if (elderbug.animation.curAnim.name != "turnLeft" && elderbug.animation.curAnim.name != "turnLeftFrame") {
					elderbug.animation.play('turnLeft');
				}
			} else {
				if (!indialogue) {
					elderbug.animation.play('turnLeftFrame');
				}
			}
		} else {
			if (elderbug.animation.curAnim.name != "talk") {
				if (elderbug.animation.curAnim.name != "turnRight" && elderbug.animation.curAnim.name != "idle") {
					elderbug.animation.play('turnRight', true, true);
				}
				if (elderbug.animation.curAnim.name == "turnRight" && elderbug.animation.curAnim.finished) {
					elderbug.animation.play('idle');
				}
			} else {
				if (!indialogue) {
					elderbug.animation.play('idle');
				}
			}
		}

		interactionpoint();
	}

	var nothingyoudopls:Bool = false;

	var inInteraction:Bool = false;
	var tweenflair:FlxTween;
	var tweentext:FlxTween;
	var tweenbg:FlxTween;

	function getAnimationName(spr:FlxSprite) {
		if (spr.animation != null && spr.animation.curAnim != null) {
			return spr.animation.curAnim.name;
		}
		return "";
	}

	function interactionpoint() {
		var hasfound = false;
		for (i in 0...stageproperties.interactionpoints.length) {
			var point = stageproperties.interactionpoints[i];
			var extrarange:Float = 150;

			if ((point[1] == "doorinteract" && getAnimationName(slyShopSprite) == "open") || !(point[1] == "doorinteract") && !cutscene) {
				if (point[0] - extrarange < game.player.x && point[0] + extrarange > game.player.x) {
					hasfound = true;

					interactiontext.text = TM.checkTransl("Listen", "listen");
					if (getAnimationName(slyShopSprite) == "open") {
						if (point[1] == "doorinteract") {
							interactiontext.text = TM.checkTransl("Enter", "enter");
						}
					}

					if (point[1] == "silly") {
						interactiontext.text = TM.checkTransl("Rest", "rest");
					}
					if (game.player.status.bench == true) {
						if (getAnimationName(interactionflair) != "disappear") {
							interactionflair.animation.play("disappear", true);
							if (tweenflair != null) {
								tweenflair.cancel();
								tweentext.cancel();
								tweenbg.cancel();
							}
							tweenflair = FlxTween.tween(interactionflair, {alpha: 0}, .5, {ease: FlxEase.quintOut});
							tweentext = FlxTween.tween(interactiontext, {alpha: 0}, .5, {ease: FlxEase.quintOut});
							tweenbg = FlxTween.tween(interactionBackdrop, {alpha: 0}, .5, {ease: FlxEase.quintOut});
						}
					} else {
						interactionflair.alpha = 1;
						interactionflair.x = point[0] - interactionflair.width / 4;
						interactiontext.alpha = 1;
						interactiontext.x = interactionflair.getGraphicMidpoint().x - interactiontext.width / 2;

						interactionBackdrop.y = interactionflair.getGraphicMidpoint().y - interactionflair.height / 2.5;
						interactionBackdrop.x = interactionflair.getGraphicMidpoint().x - interactionflair.width / 3.25;

						if (interactionflair.animation.curAnim.name != "idle") {
							if (interactionflair.animation.curAnim.name == "appear" && interactionflair.animation.curAnim.finished) {
								interactionflair.animation.play("idle");
							}
							if (interactionflair.animation.curAnim.name != "idle" && interactionflair.animation.curAnim.name != "appear") {
								interactionflair.animation.play("appear");
								if (tweenflair != null) {
									tweenflair.cancel();
									tweentext.cancel();
									tweenbg.cancel();
								}
								tweenflair = FlxTween.tween(interactionflair, {alpha: 1}, .5, {ease: FlxEase.quintOut});
								tweentext = FlxTween.tween(interactiontext, {alpha: 1}, .5, {ease: FlxEase.quintOut});
								tweenbg = FlxTween.tween(interactionBackdrop, {alpha: .4}, .5, {ease: FlxEase.quintOut});
							}
						}
					}

					if (!nothingyoudopls) {
						if (controls.ACCEPT) {
							inInteraction = true;
							interaction(point[1]);
						}
					}
				}
			}
		}
		if (hasfound == false) {
			if (interactionflair.animation.curAnim.name != "disappear") {
				interactionflair.animation.play("disappear", true);
				if (tweenflair != null) {
					tweenflair.cancel();
					tweentext.cancel();
					tweenbg.cancel();
				}
				tweenflair = FlxTween.tween(interactionflair, {alpha: 0}, .5, {ease: FlxEase.quintOut});
				tweentext = FlxTween.tween(interactiontext, {alpha: 0}, .5, {ease: FlxEase.quintOut});
				tweenbg = FlxTween.tween(interactionBackdrop, {alpha: 0}, .5, {ease: FlxEase.quintOut});
			}
		}
	}

	var doingelderbuginteract:Bool = false;
	var charmsaquire:CharmAcquireElderbug;
	var cutscene:Bool = false;
	var lightcd:Bool = false;

	function dooropen() {
		cutscene = true;

		game.campos = [
			slyShopSprite.getGraphicMidpoint().x + 300,
			slyShopSprite.getGraphicMidpoint().y + 125
		];
		FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.35}, 2.5, {ease: FlxEase.quintOut});
		FlxTween.tween(fences, {alpha: 0.45}, 1.5, {ease: FlxEase.quintOut});

		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			if (elderbug.animation.curAnim.name == "talkL") {
				elderbug.animation.play('turnLeftFrame');
			} else {
				elderbug.animation.play('idle');
			}
			slyShopSprite.animation.play('open', true);
			FlxG.sound.play(Paths.sound('bathhouse_door_open', 'hymns'));
			slyShopSprite.y -= 125;
			new FlxTimer().start(2.5, function(tmr:FlxTimer) {
				game.campos = [0.0, 0.0];
				FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.35}, 2.5, {ease: FlxEase.quintOut});
				FlxTween.tween(fences, {alpha: 1}, 1.5, {ease: FlxEase.quintOut});

				DataSaver.loadData(DataSaver.saveFile);
				DataSaver.unlocked.set("slydoor", "open");
			});
		});
	}

	function elderbugClose() {
		new FlxTimer().start(.7, function(tmr:FlxTimer) {
			doingelderbuginteract = false;
		});
	}

	function closeElderDialogue() {
		indialogue = false;
		FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
		game.player.status.cripple = false;
		elderbugClose();
	}

	public var logicLevel = 0;

	function elderbugLogic() {
		if (!doingelderbuginteract) {
			doingelderbuginteract = true;
			indialogue = true;
			FlxTween.tween(game.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});
			function addMelodicShell() {
				indialogue = false;
				new FlxTimer().start(1.25, function(tmr:FlxTimer) {
					DataSaver.charmsunlocked.set(MelodicShell, true);
					DataSaver.saveSettings(DataSaver.saveFile);
					charmsaquire = new CharmAcquireElderbug();
					charmsaquire.cameras = [game.camDIALOG];
					charmsaquire.y -= 25;
					charmsaquire.call = function() {
						FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
						game.player.status.cripple = false;
						new FlxTimer().start(1.25, function(tmr:FlxTimer) {
							charmsaquire.destroy();
							remove(charmsaquire, true);
							elderbugClose();
						});
					}
					add(charmsaquire);
				});
			}

			var randomElderlines = [
				[
					TM.checkTransl("The couple at the map shop.. Oh, I wish nothing but the best for those two. If only they could have setup shop some place larger.. I can't stand watching the wife bend down to walk through that door, Such a tall bug she is.", "elderbug-dialog-7")
				],
				[
					TM.checkTransl("The shopkeep? He seems to have everything in that little store of his! I'd be careful if you're looking to purchase from him.. He drives quite a hard bargain for his wares, that bug.", "elderbug-dialog-8")
				],
				[
					TM.checkTransl("Many used to come in search of a kingdom just below where we stand. Hallownest, it was called. The greatest kingdom there ever was I've been told. It's since become ruin, the sickly air below enough to drive one mad!", "elderbug-dialog-9")
				]
			];
			game.player.animation.play("interacts");
			game.player.offset.set(99.6 + 5, 145.8 + 2.5);

			if (elderbug.animation.curAnim.name == "turnLeft") {
				FlxTween.tween(game.player, {x: 62.92}, .75, {ease: FlxEase.quintOut});

				game.player.flipX = true;
				elderbug.animation.play('talkL');
			} else {
				FlxTween.tween(game.player, {x: 378.03}, .75, {ease: FlxEase.quintOut});

				game.player.flipX = false;
				elderbug.animation.play('talk');
			}

			game.player.status.cripple = true;

			switch (DataSaver.elderbugstate) {
				case 0:
					game.dialogue.openBox("Elderbug",
						[
							[
								TM.checkTransl("Ah, Traveler! You've returned! I could have sworn you had just passed by me a minute ago. You seemed to have dropped this on your way down. Here, take it.", "elderbug-dialog-1")
							]
						],
						addMelodicShell
					);
					DataSaver.elderbugstate++;
					DataSaver.saveSettings(DataSaver.saveFile);

				case 1:
					DataSaver.loadData(DataSaver.saveFile);
					var rawData:Bool = DataSaver.charms.get(MelodicShell);

					if (rawData == true) {
						DataSaver.loadData(DataSaver.saveFile);

						if (DataSaver.diedonfirststeps == false) {
							game.dialogue.openBox("Elderbug",
								[
									[
										TM.checkTransl("Here, why don't try it out right now? A bit of practice shouldn't do any harm. Besides, I do appreciate the extra company.", "elderbug-dialog-2")
									]
								],
								function() {
									Difficulty.resetList();
									PlayState.storyDifficulty = Difficulty.NORMAL;

									var songLowercase:String = Paths.formatPath("First Steps");
									var poop:String = Highscore.formatSong(songLowercase, Difficulty.NORMAL);
									trace(poop);

									DataSaver.loadData(DataSaver.saveFile);
									DataSaver.doingsong = "First Steps";
									DataSaver.saveSettings(DataSaver.saveFile);

									PlayState.SONG = Song.loadFromJson(poop, songLowercase);
									PlayState.isStoryMode = true;
									LoadingState.loadAndSwitchState(new PlayState());

									FlxG.sound.music.volume = 0;
								}
							);
							DataSaver.saveSettings(DataSaver.saveFile);
						} else {
							game.dialogue.openBox("Elderbug",
								[
									[
										TM.checkTransl("I apologize, my singing must be a little rusty. Lets try that again, Traveler.", "elderbug-dialog-3")
									]
								],
								function() {
									Difficulty.resetList();
									PlayState.storyDifficulty = Difficulty.NORMAL;

									var songLowercase:String = Paths.formatPath("First Steps");
									var poop:String = Highscore.formatSong(songLowercase, Difficulty.NORMAL);
									trace(poop);

									DataSaver.loadData(DataSaver.saveFile);
									DataSaver.doingsong = "First Steps";
									DataSaver.saveSettings(DataSaver.saveFile);

									PlayState.SONG = Song.loadFromJson(poop, songLowercase);
									PlayState.isStoryMode = true;
									LoadingState.loadAndSwitchState(new PlayState());

									FlxG.sound.music.volume = 0;
								}
							);
							DataSaver.saveSettings(DataSaver.saveFile);
						}
					} else {
						game.dialogue.openBox("Elderbug",
							[
								[
									TM.checkTransl("Traveler, that nail of yours appears to be in quite the sorry state. It won't do you any good down there. Perhaps that charm of yours can be of use to you.", "elderbug-dialog-4")
								]
							],
							closeElderDialogue
						);
						DataSaver.saveSettings(DataSaver.saveFile);
					}
				case 6:
					if (DataSaver.charmsunlocked.get(Swindler) == false) {
						FlxTween.tween(game.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});
						game.dialogue.openBox("Elderbug",
							[
								[
									TM.checkTransl("Oh my, I haven't felt such enjoyment in quite a long time!", "elderbug-dialog-5")
								],
							],
							function() {
								dooropen();

								new FlxTimer().start(6.75, function(tmr:FlxTimer) {
									if (elderbug.animation.curAnim.name == "turnLeftFrame") {
										elderbug.animation.play('talkL');
									} else {
										elderbug.animation.play('talk');
									}
									game.dialogue.openBox("Elderbug",
										[
											[
												TM.checkTransl("Oh, It seems we caught the attention of our shopkeep! Perhaps you should pay them a visit? I believe they have might have something that may aid you in your travels.", "elderbug-dialog-6")
											]
										],
										closeElderDialogue
									);
								});
							}
						);
						DataSaver.elderbugstate++;
						DataSaver.saveSettings(DataSaver.saveFile);
					} else {
						if (DataSaver.charmsunlocked.get(Swindler) == false || DataSaver.interacts[1] == true) {
							DataSaver.loadData(DataSaver.saveFile);
							var rawData1:Bool = DataSaver.charmsunlocked.get(BaldursBlessing);
							var rawData2:Bool = DataSaver.charmsunlocked.get(LifebloodSeed);
							var rawData3:Bool = DataSaver.charmsunlocked.get(CriticalFocus);
							if (!(rawData1 || rawData2 || rawData3) || DataSaver.interacts[2] == true) {
								if (DataSaver.lichendone == false || DataSaver.interacts[0] == true) {
									if (lightcd == false) {
										var randomlines = randomElderlines;

										lightcd = true;

										game.dialogue.openBox("Elderbug",
											[randomlines[FlxG.random.int(0, randomlines.length - 1)]],
											function() {
												closeElderDialogue();

												new FlxTimer().start(.5, function(tmr:FlxTimer) {
													lightcd = false;
												});
											}
										);
									}
								} else {
									DataSaver.interacts[0] = true;
									game.dialogue.openBox("Elderbug",
										[
											[
												TM.checkTransl("You seem exhausted, Traveler. I take it you've ventured down to the leafy caverns below? It's quite a beautiful sight, really.", "elderbug-dialog-10")
											],
											[
												TM.checkTransl("I suggest you take a rest on that bench before heading out again. I assure you it's quite comfortable.", "elderbug-dialog-11")
											]
										],
										closeElderDialogue
									);
									DataSaver.saveSettings(DataSaver.saveFile);
								}
							} else {
								DataSaver.interacts[2] = true;
								game.dialogue.openBox("Elderbug",
									[
										[
											TM.checkTransl("Oh, I see you've bought from that shopkeep have you? You look quite ready for your next venture. but remember to be careful out there, who knows what you may run into in those caverns.", "elderbug-dialog-12")
										]
									],
									closeElderDialogue
								);
								DataSaver.saveSettings(DataSaver.saveFile);
							}
						} else {
							DataSaver.interacts[1] = true;
							game.dialogue.openBox("Elderbug",
								[
									[
										TM.checkTransl("You seem exhausted, Traveler. Looks like you had put up a hard fight for a bargain.", "elderbug-dialog-13")
									],
									[
										TM.checkTransl("I suggest you take a rest on that bench before heading out again. I assure you it's quite comfortable.", "elderbug-dialog-11")
									]
								],
								closeElderDialogue
							);
							DataSaver.saveSettings(DataSaver.saveFile);
						}
					}
				case 7:
					DataSaver.loadData(DataSaver.saveFile);

					if (DataSaver.charmsunlocked.get(Swindler) == false || DataSaver.interacts[1] == true) {
						DataSaver.loadData(DataSaver.saveFile);
						var rawData1:Bool = DataSaver.charmsunlocked.get(BaldursBlessing);
						var rawData2:Bool = DataSaver.charmsunlocked.get(LifebloodSeed);
						var rawData3:Bool = DataSaver.charmsunlocked.get(CriticalFocus);
						if (!(rawData1 || rawData2 || rawData3) || DataSaver.interacts[2] == true) {
							if (DataSaver.lichendone == false || DataSaver.interacts[0] == true) {
								if (lightcd == false) {
									var randomlines = randomElderlines;

									lightcd = true;

									game.dialogue.openBox("Elderbug",
										[randomlines[FlxG.random.int(0, randomlines.length - 1)]],
										function() {
											closeElderDialogue();

											new FlxTimer().start(.5, function(tmr:FlxTimer) {
												lightcd = false;
											});
										}
									);
								}
							} else {
								DataSaver.interacts[0] = true;
								game.dialogue.openBox("Elderbug",
									[
										[
											TM.checkTransl("You seem exhausted, Traveler. I take it you've ventured down to the leafy caverns below? It's quite a beautiful sight, really.", "elderbug-dialog-10")
										],
										[
											TM.checkTransl("I suggest you take a rest on that bench before heading out again. I assure you it's quite comfortable.", "elderbug-dialog-11")
										]
									],
									closeElderDialogue
								);
								DataSaver.saveSettings(DataSaver.saveFile);
							}
						} else {
							DataSaver.interacts[2] = true;
							game.dialogue.openBox("Elderbug",
								[
									[
										TM.checkTransl("Oh, I see you've bought from that shopkeep have you? You look quite ready for your next venture. but remember to be careful out there, who knows what you may run into in those caverns.", "elderbug-dialog-12")
									]
								],
								closeElderDialogue
							);
							DataSaver.saveSettings(DataSaver.saveFile);
						}
					} else {
						DataSaver.interacts[1] = true;
						game.dialogue.openBox("Elderbug",
							[
								[
									TM.checkTransl("You seem exhausted, Traveler. Looks like you had put up a hard fight for a bargain.", "elderbug-dialog-13")
								],
								[
									TM.checkTransl("I suggest you take a rest on that bench before heading out again. I assure you it's quite comfortable.", "elderbug-dialog-11")
								]
							],
							closeElderDialogue
						);
						DataSaver.saveSettings(DataSaver.saveFile);
					}
			}
		}
	}

	function benchLogic() {
		if (game.player.status.bench == false) {
			game.player.status.bench = true;
			game.player.flipX = false;
			FlxG.state.persistentUpdate = true;

			var charmsub = new CharmSubState(0, 0, game.camCHARM);
			charmsub.cameras = [game.camCHARM];
			game.camCHARM.alpha = 0;
			game.openSubState(charmsub);
			FlxTween.tween(game.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});
			FlxTween.tween(game.camCHARM, {alpha: 1}, .5, {ease: FlxEase.quintOut});
		}
	}

	function interaction(thing:String) {
		DataSaver.loadData(DataSaver.saveFile);
		if (logicLevel == 0) {
			switch (thing) {
				case "elderbuginteract": elderbugLogic();
				case "doorinteract": game.switchScenery(new SlyShop());
				case "silly": benchLogic();
			}
		}
	}
}
