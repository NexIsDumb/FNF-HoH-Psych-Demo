package states.stages;

import objects.Character;
import openfl.display.BlendMode;
import backend.ObjectBlendMode;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import shaders.stages.Lake;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import shaders.Shaders;

class Dirtmouth extends BaseStage {
	public var group:FlxTypedSpriteGroup<FlxSprite>;

	var thefog:Array<FlxSprite> = [];
	var infectionAmbience:FlxTypedEmitter<FlxParticle>;
	var sly:FlxSprite;
	var playerfog:FlxSprite;

	override function create() {
		group = new FlxTypedSpriteGroup(0, 0, 30);
		group.screenCenterXY();
		add(group);

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/bg', 'hymns'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0.7, 0.7);
		bg.scale.set(2.5, 2.5);
		bg.updateHitbox();
		bg.screenCenterXY();
		bg.y -= 150;
		add(bg);

		var townmidbehind:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/townmidbehind', 'hymns'));
		townmidbehind.antialiasing = ClientPrefs.data.antialiasing;
		townmidbehind.scrollFactor.set(0.68, 0.68);
		townmidbehind.scale.set(2.5, 2.5);
		townmidbehind.updateHitbox();
		townmidbehind.screenCenterXY();
		add(townmidbehind);

		var townmidsmallhouse:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/townmidsmallhouse', 'hymns'));
		townmidsmallhouse.antialiasing = ClientPrefs.data.antialiasing;
		townmidsmallhouse.scrollFactor.set(0.7, 0.7);
		townmidsmallhouse.scale.set(2.5, 2.5);
		townmidsmallhouse.updateHitbox();
		townmidsmallhouse.screenCenterXY();
		add(townmidsmallhouse);

		var townmidbighouse:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/townmidbighouse', 'hymns'));
		townmidbighouse.antialiasing = ClientPrefs.data.antialiasing;
		townmidbighouse.scrollFactor.set(0.73, 0.73);
		townmidbighouse.scale.set(2.5, 2.5);
		townmidbighouse.updateHitbox();
		townmidbighouse.screenCenterXY();
		add(townmidbighouse);

		var townmid:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/townmid', 'hymns'));
		townmid.antialiasing = ClientPrefs.data.antialiasing;
		townmid.scrollFactor.set(0.75, 0.75);
		townmid.scale.set(2.5, 2.5);
		townmid.updateHitbox();
		townmid.screenCenterXY();
		add(townmid);

		if (!ClientPrefs.data.lowQuality) {
			var lights2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth_Hymns_of_the_sorcerers_stone2_20230913200805', 'hymns'));
			lights2.antialiasing = ClientPrefs.data.antialiasing;
			ObjectBlendMode.blendMode(lights2, "multiply");
			lights2.alpha = 0.8;
			lights2.scrollFactor.set(0.75, 0.75);
			lights2.scale.set(2.5, 2.5);
			lights2.updateHitbox();
			lights2.screenCenterXY();
			lights2.y -= 50;
			add(lights2);
		}

		var lamp1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lamp1', 'hymns'));
		lamp1.antialiasing = ClientPrefs.data.antialiasing;
		lamp1.scrollFactor.set(1.005, 1.005);
		lamp1.scale.set(2.5, 2.5);
		lamp1.updateHitbox();
		lamp1.screenCenterXY();
		add(lamp1);

		if (!ClientPrefs.data.lowQuality) {
			var lights4:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth Hymns of the sorcerers stone3_20230910171515', 'hymns'));
			lights4.antialiasing = ClientPrefs.data.antialiasing;
			ObjectBlendMode.blendMode(lights4, "screen");
			lights4.scale.set(2.5, 2.5);
			lights4.updateHitbox();
			lights4.screenCenterXY();
			lights4.y -= 50;
			lights4.scrollFactor.set(0.87, 0.87);
			add(lights4);

			var lights3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth_Hymns_of_the_sorcerers_stone2_20230913201027', 'hymns'));
			lights3.antialiasing = ClientPrefs.data.antialiasing;
			ObjectBlendMode.blendMode(lights3, "add");
			lights3.alpha = 0.2;
			lights3.scale.set(2.5, 2.5);
			lights3.updateHitbox();
			lights3.screenCenterXY();
			add(lights3);
		}

		var bench:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/bench', 'hymns'));
		bench.antialiasing = ClientPrefs.data.antialiasing;
		bench.scale.set(2.6, 2.6);
		bench.updateHitbox();
		bench.screenCenterXY();
		bench.y += FlxG.height / 1.5 + 240;
		add(bench);

		if (!ClientPrefs.data.lowQuality) {
			var lights5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth Hymns of the sorcerers stone3_20230910171511', 'hymns'));
			lights5.antialiasing = ClientPrefs.data.antialiasing;
			ObjectBlendMode.blendMode(lights5, "screen");
			lights5.scale.set(2.5, 2.5);
			lights5.updateHitbox();
			lights5.screenCenterXY();
			lights5.scrollFactor.set(0.9, 0.9);
			lights5.alpha = 0.5;
			add(lights5);
		}

		sly = new FlxSprite(0, 0);
		sly.frames = Paths.getSparrowAtlas('Overworld/DMShopSly', 'hymns');
		sly.scale.set(2.56, 2.56);
		sly.updateHitbox();
		sly.screenCenterXY();
		sly.y += 45;
		sly.x -= FlxG.width * 1.85;
		sly.animation.addByPrefix('door', 'ShopDoorIdleClosed', 15, false);
		sly.animation.addByPrefix('open', 'ShopDoorCloseToOpen', 15, false);
		sly.animation.play('door', true);
		sly.antialiasing = ClientPrefs.data.antialiasing;
		add(sly);

		DataSaver.loadData(DataSaver.saveFile);
		if (DataSaver.unlocked.exists("slydoor")) {
			if (DataSaver.unlocked.get("slydoor") != null) {
				sly.animation.play('open', true);
				sly.y -= Std.int(125 * 2.41509434);
			}
		}

		var stagstation:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/stagstation', 'hymns'));
		stagstation.antialiasing = ClientPrefs.data.antialiasing;
		stagstation.scale.set(2.5, 2.5);
		stagstation.updateHitbox();
		stagstation.screenCenterXY();
		add(stagstation);

		var corniferandbretta:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/corniferandbretta', 'hymns'));
		corniferandbretta.antialiasing = ClientPrefs.data.antialiasing;
		corniferandbretta.scale.set(2.5, 2.5);
		corniferandbretta.updateHitbox();
		corniferandbretta.screenCenterXY();
		corniferandbretta.scrollFactor.set(1.005, 1.005);
		add(corniferandbretta);

		playerfog = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/glow', 'hymns'));
		playerfog.antialiasing = ClientPrefs.data.antialiasing;
		ObjectBlendMode.blendMode(playerfog, "add");
		playerfog.scale.set(2.41509434, 2.41509434);
		playerfog.updateHitbox();
		playerfog.alpha = 0.75;
	}

	override function createPost() {
		add(playerfog);

		var roadmain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/roadmain', 'hymns'));
		roadmain.antialiasing = ClientPrefs.data.antialiasing;
		roadmain.scale.set(2.5, 2.5);
		roadmain.updateHitbox();
		roadmain.screenCenterXY();
		add(roadmain);

		var road2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/road2', 'hymns'));
		road2.antialiasing = ClientPrefs.data.antialiasing;
		road2.scrollFactor.set(1.05, 1.05);
		road2.scale.set(2.5, 2.5);
		road2.updateHitbox();
		road2.screenCenterXY();
		add(road2);

		var road3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/road3', 'hymns'));
		road3.antialiasing = ClientPrefs.data.antialiasing;
		road3.scrollFactor.set(1.1, 1.1);
		road3.scale.set(2.5, 2.5);
		road3.updateHitbox();
		road3.screenCenterXY();
		add(road3);

		var road4:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/road4', 'hymns'));
		road4.antialiasing = ClientPrefs.data.antialiasing;
		road4.scrollFactor.set(1.15, 1.15);
		road4.scale.set(2.5, 2.5);
		road4.updateHitbox();
		road4.screenCenterXY();
		add(road4);

		var road5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/road5', 'hymns'));
		road5.antialiasing = ClientPrefs.data.antialiasing;
		road5.scrollFactor.set(1.2, 1.2);
		road5.scale.set(2.5, 2.5);
		road5.updateHitbox();
		road5.screenCenterXY();
		add(road5);

		var poles:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/poles', 'hymns'));
		poles.antialiasing = ClientPrefs.data.antialiasing;
		poles.scale.set(2.5, 2.5);
		poles.updateHitbox();
		poles.screenCenterXY();
		poles.scrollFactor.set(1.2, 1.2);
		add(poles);

		var fences:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/fences', 'hymns'));
		fences.antialiasing = ClientPrefs.data.antialiasing;
		fences.scale.set(2.5, 2.5);
		fences.updateHitbox();
		fences.screenCenterXY();
		fences.scrollFactor.set(1.2, 1.2);
		add(fences);

		var lamplights:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lamplights', 'hymns'));
		lamplights.antialiasing = ClientPrefs.data.antialiasing;
		lamplights.scale.set(2.5, 2.5);
		lamplights.updateHitbox();
		lamplights.screenCenterXY();
		lamplights.scrollFactor.set(1.005, 1.005);
		add(lamplights);

		if (!ClientPrefs.data.lowQuality) {
			var lights1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lighting/Dirtmouth Hymns of the sorcerers stone3_20230910171523', 'hymns'));
			lights1.antialiasing = ClientPrefs.data.antialiasing;
			ObjectBlendMode.blendMode(lights1, "add");
			lights1.scale.set(2.5, 2.5);
			lights1.updateHitbox();
			lights1.screenCenterXY();
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
		ObjectBlendMode.blendMode(fog, "add");
		add(fog);

		fog.x -= FlxG.width * 4;
		pos = fog.x;
		fog.y -= 360;
		thefog.push(fog);
		ypos = fog.y;
		fog.y += FlxG.random.int(-200, 100);

		new FlxTimer().start(9, function(tmr:FlxTimer) {
			var fog:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/dmfogtextu1', 'hymns'));
			fog.antialiasing = ClientPrefs.data.antialiasing;
			fog.alpha = 0.75;
			fog.scale.set(8, 8);
			fog.updateHitbox();
			fog.screenCenterXY();
			ObjectBlendMode.blendMode(fog, "add");
			add(fog);

			fog.x -= FlxG.width * 4;
			fog.y -= 400;
			thefog.push(fog);
			ypos = fog.y;
			fog.y += FlxG.random.int(-200, 100);
		}, 2);

		chromaticAbberation = new ChromaticAbberation(0.00001);
		add(chromaticAbberation);
		var filter1:ShaderFilter = new ShaderFilter(chromaticAbberation.shader);

		camGame.setFilters([filter1]);

		_piss = game.soulMeter != null && isStoryMode && !seenCutscene && songName == "first-steps"; // life tutorial  - Nex
	}

	private var _piss:Bool;

	override function countdownTick(count:Countdown, num:Int) {
		if (_piss) {
			game.startedCountdown = false;
			game.soulMeter.soulCooldown = true;

			new FlxTimer().start(2, function(_) {
				new FlxTimer().start(2, function(_) game.soulMeter.changeMasks(-(game.soulMeter.masks / 2)));
				FlxTween.tween(game.soulMeter, {soul: 99}, 3, {ease: FlxEase.quintOut});

				new FlxTimer().start(3, function(_) {
					var lifeTut = new LifeTutorial();
					lifeTut.cameras = [game.camHUD];
					lifeTut.call = function() new FlxTimer().start(1.2, function(_) {
						game.soulMeter.soulCooldown = false;
						game.startedCountdown = true;
						game.setSongTime(0);
						lifeTut.destroy();
					});
					lifeTut.y -= 22;
					add(lifeTut);
				});
			});
		}

		super.countdownTick(count, num);
	}

	var angle = 0.5;

	var pos:Float = 0;
	var ypos:Float = 0;

	override function update(elapsed:Float) {
		chromaticAbberation.update(elapsed);
		sly.update(elapsed);
		for (i in 0...thefog.length) {
			var fog = thefog[i];
			fog.x += FlxG.random.int(15, 20) * (ClientPrefs.data.framerate / 60);
			fog.angle += angle * FlxG.random.int(-2, 2, [0]) * (ClientPrefs.data.framerate / 60);
			fog.y += FlxG.random.int(-5, 5) * (ClientPrefs.data.framerate / 60);

			if (!fog.isOnScreen() && fog.x > pos + FlxG.width / 1.25) {
				fog.angle = 0;
				fog.loadGraphic(Paths.image('Overworld/dmfogtextu' + FlxG.random.int(1, 3), 'hymns'));
				fog.x = pos;
				fog.y = ypos;
				fog.y += FlxG.random.int(-200, 100);

				angle = angle * FlxG.random.int(-1, 1, [0]);
				fog.alpha = FlxG.random.float(0.5, 0.8);
			}
		}
		playerfog.x = PlayState.instance.boyfriend.x - (playerfog.width / 2) + (PlayState.instance.boyfriend.width / 2);
		playerfog.y = PlayState.instance.boyfriend.y - (playerfog.height / 2) + (PlayState.instance.boyfriend.height / 2);
	}
}

class LifeTutorial extends FlxSpriteGroup { // copied from the charmacquired screen  - Nex
	public var call = function() {};

	var hasfinished:Bool = false;
	var controls(get, never):Controls;

	private function get_controls() {
		return Controls.instance;
	}

	var dissapear = function() {};

	public function new() {
		super();

		var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeSolid(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackShit.alpha = 0;
		add(blackShit);

		var collected = new FlxText(0, 0, FlxG.width * 2, "Higher beings, these words are for you alone.");
		collected.setFormat(Paths.font("perpetua.ttf"), 48, FlxColor.WHITE, CENTER);
		collected.antialiasing = ClientPrefs.data.antialiasing;
		collected.screenCenterXY();
		collected.y -= FlxG.height / 3;
		collected.alpha = 0;
		add(collected);

		var flair:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/Warning_Fleur0008', 'hymns'));
		flair.antialiasing = ClientPrefs.data.antialiasing;
		flair.y = collected.y + collected.height;
		flair.scale.set(0.4, 0.4);
		flair.updateHitbox();
		flair.screenCenterX();
		flair.alpha = 0;
		add(flair);

		var desc1 = new FlxText(0, 0, FlxG.width * 2, "Your great strength marks you amongst us.\nFocus your soul and you shall achieve feats of which others can only dream.");
		desc1.setFormat(Paths.font("perpetua.ttf"), 30, FlxColor.WHITE, CENTER);
		desc1.antialiasing = ClientPrefs.data.antialiasing;
		desc1.screenCenterXY();
		desc1.y = flair.y + flair.height * 1.5;
		desc1.alpha = 0;
		add(desc1);

		var bench:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/lifeTut', 'hymns'));
		bench.antialiasing = ClientPrefs.data.antialiasing;
		bench.scale.set(0.225, 0.225);
		bench.updateHitbox();
		bench.screenCenterXY();
		bench.y += 100;
		bench.alpha = 0;
		add(bench);

		var desc2 = new FlxText(0, 0, FlxG.width * 2, "Collect SOUL by hitting notes.\nOnce enough SOUL is collected, hold SPACE while not singing to focus SOUL and heal.");
		desc2.setFormat(Paths.font("perpetua.ttf"), 27, FlxColor.WHITE, CENTER);
		desc2.antialiasing = ClientPrefs.data.antialiasing;
		desc2.screenCenterXY();
		desc2.y += 300;
		desc2.alpha = 0;
		add(desc2);

		FlxTween.tween(blackShit, {alpha: .7}, 1.2, {ease: FlxEase.quintOut});
		FlxTween.tween(collected, {alpha: 1}, 1, {ease: FlxEase.quintOut});
		FlxTween.tween(flair, {alpha: 1}, 1, {ease: FlxEase.quintOut});

		FlxG.sound.play(Paths.sound('spell_information_screen', 'hymns'));

		new FlxTimer().start(1, function(tmr:FlxTimer) {
			FlxTween.tween(desc1, {alpha: 1}, 1, {ease: FlxEase.quintOut});
		});

		new FlxTimer().start(2.25, function(tmr:FlxTimer) {
			FlxTween.tween(bench, {alpha: 1}, 1, {ease: FlxEase.quintOut});
			FlxTween.tween(desc2, {alpha: 1}, 1, {ease: FlxEase.quintOut});
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				hasfinished = true;
			});
		});

		dissapear = function() {
			FlxTween.tween(blackShit, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
			FlxTween.tween(collected, {alpha: 0}, 1, {ease: FlxEase.quintOut});
			FlxTween.tween(flair, {alpha: 0}, 1, {ease: FlxEase.quintOut});

			FlxTween.tween(bench, {alpha: 0}, 1, {ease: FlxEase.quintOut});
			FlxTween.tween(desc2, {alpha: 0}, 1, {ease: FlxEase.quintOut});
			FlxTween.tween(desc1, {alpha: 0}, 1, {ease: FlxEase.quintOut});
		}
	}

	var hasconfirmed:Bool = false;

	override function update(elapsed:Float) {
		if (hasfinished && !hasconfirmed && controls.ACCEPT) {
			hasconfirmed = true;
			dissapear();
			call();
		}
	}
}
