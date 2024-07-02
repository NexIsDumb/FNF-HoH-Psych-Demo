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
	var sly:FlxSprite;
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
			[sly.x + sly.width / 1.45, "doorinteract"],
			[game.player.x + 10, "silly"]
		];
		trace(sly.x + sly.width / 1.45);
	}

	override public function create() {
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/bg', 'hymns'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0.7, 0.7);
		bg.screenCenterXY();
		bg.y -= 150;
		bg.updateHitbox();
		add(bg);

		var townmidbehind:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/townmidbehind', 'hymns'));
		townmidbehind.antialiasing = ClientPrefs.data.antialiasing;
		townmidbehind.scrollFactor.set(0.68, 0.68);
		townmidbehind.screenCenterXY();
		townmidbehind.updateHitbox();
		add(townmidbehind);

		var townmidsmallhouse:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/townmidsmallhouse', 'hymns'));
		townmidsmallhouse.antialiasing = ClientPrefs.data.antialiasing;
		townmidsmallhouse.scrollFactor.set(0.7, 0.7);
		townmidsmallhouse.screenCenterXY();
		townmidsmallhouse.updateHitbox();
		add(townmidsmallhouse);

		var townmidbighouse:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/townmidbighouse', 'hymns'));
		townmidbighouse.antialiasing = ClientPrefs.data.antialiasing;
		townmidbighouse.scrollFactor.set(0.73, 0.73);
		townmidbighouse.screenCenterXY();
		townmidbighouse.updateHitbox();
		add(townmidbighouse);

		var townmid:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/townmid', 'hymns'));
		townmid.antialiasing = ClientPrefs.data.antialiasing;
		townmid.scrollFactor.set(0.75, 0.75);
		townmid.screenCenterXY();
		townmid.updateHitbox();
		add(townmid);

		if (!ClientPrefs.data.lowQuality) {
			var lights2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth_Hymns_of_the_sorcerers_stone2_20230913200805', 'hymns'));
			lights2.antialiasing = ClientPrefs.data.antialiasing;
			lights2.blend = MULTIPLY;
			lights2.alpha = 0.8;
			lights2.scrollFactor.set(0.75, 0.75);
			lights2.screenCenterXY();
			lights2.y -= 50;
			lights2.updateHitbox();
			add(lights2);
		}

		var lamp1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lamp1', 'hymns'));
		lamp1.antialiasing = ClientPrefs.data.antialiasing;
		lamp1.scrollFactor.set(1.005, 1.005);
		lamp1.screenCenterXY();
		lamp1.updateHitbox();
		add(lamp1);
		lights4 = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth Hymns of the sorcerers stone3_20230910171515', 'hymns'));
		lights4.antialiasing = ClientPrefs.data.antialiasing;
		lights4.blend = SCREEN;
		lights4.screenCenterXY();
		lights4.y -= 50;
		lights4.scrollFactor.set(0.87, 0.87);
		lights4.updateHitbox();
		add(lights4);

		if (!ClientPrefs.data.lowQuality) {
			var lights3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth_Hymns_of_the_sorcerers_stone2_20230913201027', 'hymns'));
			lights3.antialiasing = ClientPrefs.data.antialiasing;
			lights3.blend = ADD;
			lights3.alpha = 0.2;
			lights3.screenCenterXY();
			lights3.updateHitbox();
			add(lights3);
		}

		var bench:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/bench', 'hymns'));
		bench.antialiasing = ClientPrefs.data.antialiasing;
		bench.screenCenterXY();
		bench.y += FlxG.height / 3 + 50;
		bench.updateHitbox();
		add(bench);

		var buildingfront4:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/buildingfront4', 'hymns'));
		buildingfront4.antialiasing = ClientPrefs.data.antialiasing;
		buildingfront4.scrollFactor.set(0.8, 0.8);
		buildingfront4.screenCenterXY();
		buildingfront4.updateHitbox();
		add(buildingfront4);

		var buildingfront3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/buildingfront3', 'hymns'));
		buildingfront3.antialiasing = ClientPrefs.data.antialiasing;
		buildingfront3.scrollFactor.set(0.85, 0.85);
		buildingfront3.screenCenterXY();
		buildingfront3.updateHitbox();
		add(buildingfront3);

		var buildingfront2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/buildingfront2', 'hymns'));
		buildingfront2.antialiasing = ClientPrefs.data.antialiasing;
		buildingfront2.scrollFactor.set(0.9, 0.9);
		buildingfront2.screenCenterXY();
		buildingfront2.updateHitbox();
		add(buildingfront2);

		var buildingfront1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/buildingfront1', 'hymns'));
		buildingfront1.antialiasing = ClientPrefs.data.antialiasing;
		buildingfront1.scrollFactor.set(0.95, 0.95);
		buildingfront1.screenCenterXY();
		buildingfront1.updateHitbox();
		add(buildingfront1);
		if (!ClientPrefs.data.lowQuality) {
			var lights5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth Hymns of the sorcerers stone3_20230910171511', 'hymns'));
			lights5.antialiasing = ClientPrefs.data.antialiasing;
			lights5.blend = SCREEN;
			lights5.screenCenterXY();
			lights5.updateHitbox();
			lights5.scrollFactor.set(0.9, 0.9);
			lights5.alpha = 0.5;
			add(lights5);
		}

		var lamp2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lamp2', 'hymns'));
		lamp2.antialiasing = ClientPrefs.data.antialiasing;
		lamp2.scrollFactor.set(1.005, 1.005);
		lamp2.screenCenterXY();
		lamp2.updateHitbox();
		add(lamp2);

		sly = new FlxSprite(0, 0);
		sly.frames = Paths.getSparrowAtlas('Overworld/DMShopSly', 'hymns');
		sly.scale.set(1.06, 1.06);
		sly.updateHitbox();
		sly.screenCenterXY();
		sly.y += 15;
		sly.x -= FlxG.width / 1.35;
		sly.animation.addByPrefix('door', 'ShopDoorIdleClosed', 15, false);
		sly.animation.addByPrefix('open', 'ShopDoorCloseToOpen', 15, false);
		sly.animation.play('door', true);
		sly.antialiasing = ClientPrefs.data.antialiasing;
		add(sly);

		DataSaver.loadData(DataSaver.saveFile);
		if (DataSaver.unlocked.exists("slydoor")) {
			if (DataSaver.unlocked.get("slydoor") != null) {
				sly.animation.play('open', true);
				sly.y -= 125;
			}
		}

		var stagstation:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/stagstation', 'hymns'));
		stagstation.antialiasing = ClientPrefs.data.antialiasing;
		stagstation.screenCenterXY();
		stagstation.updateHitbox();
		add(stagstation);

		var corniferandbretta:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/corniferandbretta', 'hymns'));
		corniferandbretta.antialiasing = ClientPrefs.data.antialiasing;
		corniferandbretta.screenCenterXY();
		corniferandbretta.updateHitbox();
		corniferandbretta.scrollFactor.set(1.005, 1.005);
		add(corniferandbretta);

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

	override public function createPost() {
		add(playerfog);
		game.player.benchpos = [
			(stageproperties.minCam + stageproperties.maxCam) / 2 - (game.player.width / 2),
			game.player.y - 20
		];
		game.player.oldy = game.player.y;

		var roadmain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/roadmain', 'hymns'));
		roadmain.antialiasing = ClientPrefs.data.antialiasing;
		roadmain.screenCenterXY();
		roadmain.y += 100;
		roadmain.updateHitbox();
		add(roadmain);

		var roadmain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/roadmain', 'hymns'));
		roadmain.antialiasing = ClientPrefs.data.antialiasing;
		roadmain.screenCenterXY();
		roadmain.updateHitbox();
		add(roadmain);

		var road2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/road2', 'hymns'));
		road2.antialiasing = ClientPrefs.data.antialiasing;
		road2.scrollFactor.set(1.05, 1.05);
		road2.screenCenterXY();
		road2.updateHitbox();
		add(road2);

		var road3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/road3', 'hymns'));
		road3.antialiasing = ClientPrefs.data.antialiasing;
		road3.scrollFactor.set(1.1, 1.1);
		road3.screenCenterXY();
		road3.updateHitbox();
		add(road3);

		var road4:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/road4', 'hymns'));
		road4.antialiasing = ClientPrefs.data.antialiasing;
		road4.scrollFactor.set(1.15, 1.15);
		road4.screenCenterXY();
		road4.updateHitbox();
		add(road4);

		var road5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/road5', 'hymns'));
		road5.antialiasing = ClientPrefs.data.antialiasing;
		road5.scrollFactor.set(1.2, 1.2);
		road5.screenCenterXY();
		road5.updateHitbox();
		add(road5);

		var poles:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/poles', 'hymns'));
		poles.antialiasing = ClientPrefs.data.antialiasing;
		poles.screenCenterXY();
		poles.updateHitbox();
		poles.scrollFactor.set(1.2, 1.2);
		add(poles);

		fences = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/fences', 'hymns'));
		fences.antialiasing = ClientPrefs.data.antialiasing;
		fences.screenCenterXY();
		fences.updateHitbox();
		fences.scrollFactor.set(1.2, 1.2);
		add(fences);

		var lamplights:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lamplights', 'hymns'));
		lamplights.antialiasing = ClientPrefs.data.antialiasing;
		lamplights.screenCenterXY();
		lamplights.updateHitbox();
		lamplights.scrollFactor.set(1.005, 1.005);
		add(lamplights);

		if (!ClientPrefs.data.lowQuality) {
			var lights1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth Hymns of the sorcerers stone3_20230910171523', 'hymns'));
			lights1.antialiasing = ClientPrefs.data.antialiasing;
			lights1.blend = ADD;
			lights1.screenCenterXY();
			lights1.updateHitbox();
			lights1.alpha = 0.75;
			lights1.scrollFactor.set(1.005, 1.005);
			add(lights1);
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
		sly.update(elapsed);
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

	function interactionpoint() {
		var hasfound = false;
		for (i in 0...stageproperties.interactionpoints.length) {
			var point = stageproperties.interactionpoints[i];
			var extrarange:Float = 150;

			if ((point[1] == "doorinteract" && sly.animation.curAnim.name == "open") || !(point[1] == "doorinteract") && !cutscene) {
				if (point[0] - extrarange < game.player.x && point[0] + extrarange > game.player.x) {
					hasfound = true;

					interactiontext.text = TM.checkTransl("Listen", "listen");
					if (sly.animation.curAnim.name == "open") {
						if (point[1] == "doorinteract") {
							interactiontext.text = TM.checkTransl("Enter", "enter");
						}
					}

					if (point[1] == "silly") {
						interactiontext.text = TM.checkTransl("Rest", "rest");
					}
					if (game.player.status.bench == true) {
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

		game.campos = [sly.getGraphicMidpoint().x + 300, sly.getGraphicMidpoint().y + 125];
		FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.35}, 2.5, {ease: FlxEase.quintOut});
		FlxTween.tween(fences, {alpha: 0.45}, 1.5, {ease: FlxEase.quintOut});

		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			if (elderbug.animation.curAnim.name == "talkL") {
				elderbug.animation.play('turnLeftFrame');
			} else {
				elderbug.animation.play('idle');
			}
			sly.animation.play('open', true);
			FlxG.sound.play(Paths.sound('bathhouse_door_open', 'hymns'));
			sly.y -= 125;
			new FlxTimer().start(2.5, function(tmr:FlxTimer) {
				game.campos = [0.0, 0.0];
				FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.35}, 2.5, {ease: FlxEase.quintOut});
				FlxTween.tween(fences, {alpha: 1}, 1.5, {ease: FlxEase.quintOut});

				DataSaver.loadData(DataSaver.saveFile);
				DataSaver.unlocked.set("slydoor", "open");
			});
		});
	}

	function interaction(thing:String) {
		DataSaver.loadData(DataSaver.saveFile);
		switch (thing) {
			case "elderbuginteract":
				if (!doingelderbuginteract) {
					doingelderbuginteract = true;
					indialogue = true;
					FlxTween.tween(game.camHUD, {alpha: 0}, .5, {ease: FlxEase.quintOut});
					function call() {
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
									new FlxTimer().start(.7, function(tmr:FlxTimer) {
										doingelderbuginteract = false;
									});
								});
							}
							add(charmsaquire);
						});
					}

					game.player.animation.play("interacts");
					game.player.offset.set(99.6 + 5, 145.8 + 2.5);

					if (elderbug.animation.curAnim.name == "turnLeft") {
						FlxTween.tween(game.player, {x: 62.9243881445225}, .75, {ease: FlxEase.quintOut});

						game.player.flipX = true;
						elderbug.animation.play('talkL');
					} else {
						FlxTween.tween(game.player, {x: 378.033862008456}, .75, {ease: FlxEase.quintOut});

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
								call
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
											PlayState.storyDifficulty = 1;

											var songLowercase:String = Paths.formatPath("First-Steps");
											var poop:String = Highscore.formatSong(songLowercase, 1);
											trace(poop);

											DataSaver.loadData(DataSaver.saveFile);
											DataSaver.doingsong = "First-Steps";
											DataSaver.saveSettings(DataSaver.saveFile);

											PlayState.SONG = Song.loadFromJson(poop, songLowercase);
											PlayState.storyDifficulty = 1;
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
											PlayState.storyDifficulty = 1;

											var songLowercase:String = Paths.formatPath("First-Steps");
											var poop:String = Highscore.formatSong(songLowercase, 1);
											trace(poop);

											DataSaver.loadData(DataSaver.saveFile);
											DataSaver.doingsong = "First-Steps";
											DataSaver.saveSettings(DataSaver.saveFile);

											PlayState.SONG = Song.loadFromJson(poop, songLowercase);
											PlayState.storyDifficulty = 1;
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
									function() {
										indialogue = false;
										FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
										game.player.status.cripple = false;
										new FlxTimer().start(.7, function(tmr:FlxTimer) {
											doingelderbuginteract = false;
										});
									}
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
												function() {
													indialogue = false;
													FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
													game.player.status.cripple = false;
													new FlxTimer().start(.7, function(tmr:FlxTimer) {
														doingelderbuginteract = false;
													});
												}
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
												var randomlines = [
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

												lightcd = true;

												game.dialogue.openBox("Elderbug",
													[randomlines[FlxG.random.int(0, randomlines.length - 1)]],
													function() {
														indialogue = false;
														FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
														game.player.status.cripple = false;
														new FlxTimer().start(.7, function(tmr:FlxTimer) {
															doingelderbuginteract = false;
														});

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
												function() {
													indialogue = false;
													FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
													game.player.status.cripple = false;
													new FlxTimer().start(.7, function(tmr:FlxTimer) {
														doingelderbuginteract = false;
													});
												}
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
											function() {
												indialogue = false;
												FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
												game.player.status.cripple = false;
												new FlxTimer().start(.7, function(tmr:FlxTimer) {
													doingelderbuginteract = false;
												});
											}
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
										function() {
											indialogue = false;
											FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
											game.player.status.cripple = false;
											new FlxTimer().start(.7, function(tmr:FlxTimer) {
												doingelderbuginteract = false;
											});
										}
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
											var randomlines = [
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

											lightcd = true;

											game.dialogue.openBox("Elderbug",
												[randomlines[FlxG.random.int(0, randomlines.length - 1)]],
												function() {
													indialogue = false;
													FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
													game.player.status.cripple = false;
													new FlxTimer().start(.7, function(tmr:FlxTimer) {
														doingelderbuginteract = false;
													});

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
											function() {
												indialogue = false;
												FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
												game.player.status.cripple = false;
												new FlxTimer().start(.7, function(tmr:FlxTimer) {
													doingelderbuginteract = false;
												});
											}
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
										function() {
											indialogue = false;
											FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
											game.player.status.cripple = false;
											new FlxTimer().start(.7, function(tmr:FlxTimer) {
												doingelderbuginteract = false;
											});
										}
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
									function() {
										indialogue = false;
										FlxTween.tween(game.camHUD, {alpha: 1}, .5, {ease: FlxEase.quintOut});
										game.player.status.cripple = false;
										new FlxTimer().start(.7, function(tmr:FlxTimer) {
											doingelderbuginteract = false;
										});
									}
								);
								DataSaver.saveSettings(DataSaver.saveFile);
							}
					}
				}

			case "doorinteract": game.switchScenery(new SlyShop());

			case "silly":
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
	}
}
