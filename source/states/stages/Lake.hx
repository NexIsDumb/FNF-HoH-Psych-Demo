package states.stages;

import objects.Character;
import openfl.display.BlendMode;
import shaders.stages.Lake;
import backend.ObjectBlendMode;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import flixel.math.FlxRandom;
import shaders.Shaders;
import Math;

class Lake extends BaseStage {
	var fogshader:FogEffect;
	var mossknightdeath:FlxSprite;

	public var alubas:Array<FlxSprite> = [];
	public var turnalubas:Array<Int> = [];

	override function create() {
		if (!ClientPrefs.data.lowQuality) {
			fogshader = new FogEffect();
			// backerground.shader = fogshader.shader;
		}

		var backgroundSpr1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/back_lichen', 'hymns'));
		backgroundSpr1.screenCenterXY();
		backgroundSpr1.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr1.scale.set(2, 2);
		backgroundSpr1.scrollFactor.set(.75, .75);
		backgroundSpr1.active = false;
		add(backgroundSpr1);

		var backgroundSpr2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/foliage_lichen', 'hymns'));
		backgroundSpr2.screenCenterXY();
		backgroundSpr2.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr2.scale.set(2, 2);
		backgroundSpr2.scrollFactor.set(.85, .925);
		backgroundSpr2.active = false;
		add(backgroundSpr2);

		var floaticious = FlxG.random.float(.45, .55);
		var aluba:FlxSprite = new FlxSprite(0, 0);
		aluba.frames = Paths.getSparrowAtlas('Stages/Lake/Aluba', 'hymns');
		aluba.scale.set(floaticious, floaticious);
		aluba.updateHitbox();
		aluba.screenCenterXY();
		aluba.y -= 350;
		aluba.y -= FlxG.random.int(0, 75);
		aluba.animation.addByPrefix('idle', 'aluba idle', 24, true);
		aluba.animation.addByPrefix('turn', 'aluba turn', 24, false);
		aluba.animation.addByPrefix('flap', 'aluba wing flap', 24, false);
		aluba.antialiasing = ClientPrefs.data.antialiasing;
		aluba.animation.play('idle');
		aluba.scrollFactor.set(0.85, 0.95);
		aluba.ID = 0;
		aluba.flipX = FlxG.random.bool(50);
		add(aluba);
		alubas.push(aluba);
		turnalubas.push(FlxG.random.int(2, 8));

		var floaticious = FlxG.random.float(.45, .55);
		var aluba:FlxSprite = new FlxSprite(0, 0);
		aluba.frames = Paths.getSparrowAtlas('Stages/Lake/Aluba', 'hymns');
		aluba.scale.set(floaticious, floaticious);
		aluba.updateHitbox();
		aluba.screenCenterXY();
		aluba.y -= 550;
		aluba.y -= FlxG.random.int(165, 250);
		aluba.animation.addByPrefix('idle', 'aluba idle', 24, true);
		aluba.animation.addByPrefix('turn', 'aluba turn', 24, false);
		aluba.animation.addByPrefix('flap', 'aluba wing flap', 24, false);
		aluba.antialiasing = ClientPrefs.data.antialiasing;
		aluba.animation.play('idle');
		aluba.scrollFactor.set(0.85, 0.95);
		aluba.ID = 0;
		aluba.flipX = FlxG.random.bool(50);
		add(aluba);
		alubas.push(aluba);
		turnalubas.push(FlxG.random.int(2, 8));

		var backgroundSpr3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/godray_lichen', 'hymns'));
		backgroundSpr3.screenCenterXY();
		backgroundSpr3.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr3.scale.set(1.8, 1.8);
		backgroundSpr3.scrollFactor.set(1, 1);
		backgroundSpr3.active = false;
		add(backgroundSpr3);

		var backgroundSpr4:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/lake_lichen', 'hymns'));
		backgroundSpr4.screenCenterXY();
		backgroundSpr4.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr4.scale.set(2, 2);
		backgroundSpr4.scrollFactor.set(0.95, 0.95);
		add(backgroundSpr4);

		var backgroundSpr4:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/lake_lichen', 'hymns'));
		backgroundSpr4.screenCenterXY();
		backgroundSpr4.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr4.scale.set(2, 2);
		backgroundSpr4.scrollFactor.set(1, 1);
		backgroundSpr4.updateHitbox();
		backgroundSpr4.x -= 250;
		// backgroundSpr4.y += 150;
		if (!ClientPrefs.data.lowQuality) {
			backgroundSpr4.shader = fogshader.shader;
		}
		add(backgroundSpr4);

		var backgroundSpr5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/hut_lichen', 'hymns'));
		backgroundSpr5.screenCenterXY();
		backgroundSpr5.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr5.scale.set(2, 2);
		backgroundSpr5.scrollFactor.set(1, 1);
		backgroundSpr5.active = false;
		add(backgroundSpr5);

		mossknightdeath = new FlxSprite(0, 0);
		mossknightdeath.frames = Paths.getSparrowAtlas('Stages/Lake/Moss_Knight_Death', 'hymns');
		mossknightdeath.updateHitbox();
		mossknightdeath.screenCenterXY();
		mossknightdeath.y += 750;
		mossknightdeath.x -= FlxG.width * 1.175;
		mossknightdeath.animation.addByPrefix('die', 'moss knight dies', 24, false);
		// mossknightdeath.animation.play('die', true);
		mossknightdeath.alpha = 0;
		mossknightdeath.antialiasing = ClientPrefs.data.antialiasing;
		add(mossknightdeath);
	}

	override function createPost() {
		if (!ClientPrefs.data.lowQuality) {
			var backgroundSpr8:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/overlay_2', 'hymns'));
			backgroundSpr8.screenCenterXY();
			backgroundSpr8.antialiasing = ClientPrefs.data.antialiasing;
			backgroundSpr8.scale.set(2, 2);
			backgroundSpr8.scrollFactor.set(1, 1);
			backgroundSpr8.active = false;
			backgroundSpr8.blend = ADD;
			add(backgroundSpr8);
		}

		var backgroundSpr6:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/front_lichen', 'hymns'));
		backgroundSpr6.screenCenterXY();
		backgroundSpr6.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr6.scale.set(2, 2);
		backgroundSpr6.scrollFactor.set(1.2, 1.2);
		backgroundSpr6.active = false;
		add(backgroundSpr6);

		if (!ClientPrefs.data.lowQuality) {
			var backgroundSpr7:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Lake/overlay_1', 'hymns'));
			backgroundSpr7.antialiasing = ClientPrefs.data.antialiasing;
			backgroundSpr7.scale.set(FlxG.width, 2);
			backgroundSpr7.screenCenterXY();
			backgroundSpr7.scrollFactor.set(1, 1);
			backgroundSpr7.active = false;
			backgroundSpr7.blend = ADD;
			add(backgroundSpr7);
		}

		chromaticAbberation = new ChromaticAbberation(0.00001);
		add(chromaticAbberation);
		var filter1:ShaderFilter = new ShaderFilter(chromaticAbberation.shader);

		if (!ClientPrefs.data.shaders) {
			var bloom = new BloomEffect();
			var filter2:ShaderFilter = new ShaderFilter(bloom.shader);
			camHUD.alpha = 0;

			camGame.setFilters([filter2, filter1]);
		} else {
			camGame.setFilters([filter1]);
		}
	}

	override function update(elapsed:Float) {
		chromaticAbberation.update(elapsed);
		if (fogshader != null) {
			fogshader.update(elapsed);
		}
		if (alubas != null) {
			for (i in 0...alubas.length) {
				var aluba = alubas[i];
				if (turnalubas[i] != -10) {
					if (aluba != null) {
						var speed = 60 / ClientPrefs.data.framerate;
						var vel = 2.5 * speed;

						if (aluba.flipX == false) {
							aluba.x -= 1 * speed + vel * (aluba.ID / 100) * (ClientPrefs.data.framerate / 60);
						} else {
							aluba.x += 1 * speed + vel * (aluba.ID / 100) * (ClientPrefs.data.framerate / 60);
						}

						if (aluba.ID == 0) {
							aluba.animation.play('flap');
							aluba.ID = 100;
							turnalubas[i] -= 1;
							trace(aluba.x);
							if (turnalubas[i] == 0 || Math.floor(aluba.x) == Math.floor(-1752.14364491962)) {
								turnalubas[i] = -10;
								aluba.animation.play('turn');
							} else {
								FlxTween.num(100, 0, 2.5, {ease: FlxEase.quadOut}, function(num) {
									aluba.ID = Std.int(num);});
							}
						} else {
							if (aluba.animation.curAnim.finished && aluba.animation.curAnim.name == "flap") {
								aluba.animation.play('idle');
							}
						}
					}
				} else {
					if (aluba.animation.curAnim.finished) {
						aluba.flipX = !aluba.flipX;
						aluba.animation.play('idle');

						turnalubas[i] = FlxG.random.int(3, 8);
						FlxTween.num(100, 0, 2.5, {ease: FlxEase.quadOut}, function(num) {
							aluba.ID = Std.int(num);});
					}
				}
			}
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		switch (eventName) {
			case "Mossknight":
				dad.alpha = 0;
				mossknightdeath.animation.play('die');
				mossknightdeath.alpha = 1;
				new FlxTimer().start((1 / 24) * 45, function(tmr:FlxTimer) {
					mossknightdeath.alpha = 0;
				});
		}
	}
}
