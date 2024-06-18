package states.stages;

import objects.Character;
import openfl.display.BlendMode;
import shaders.Overlay;
import shaders.Shaders;
import backend.ObjectBlendMode;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import flixel.math.FlxRandom;
import Math;

class Shop extends BaseStage {
	var spotlight:FlxSprite;
	var isspotlighting:Bool = false;

	override function create() {
		var backgroundSpr1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_1_sly', 'hymns'));
		backgroundSpr1.screenCenter();
		backgroundSpr1.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr1.scrollFactor.set(1, 1);
		backgroundSpr1.active = false;
		add(backgroundSpr1);

		var backgroundSpr2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_2_sly', 'hymns'));
		backgroundSpr2.screenCenter();
		backgroundSpr2.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr2.scrollFactor.set(1, 1);
		backgroundSpr2.active = false;
		add(backgroundSpr2);
	}

	override function createPost() {
		if (!ClientPrefs.data.lowQuality) {
			var backgroundSpr3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_blend_sly', 'hymns'));
			backgroundSpr3.screenCenter();
			backgroundSpr3.antialiasing = ClientPrefs.data.antialiasing;
			backgroundSpr3.scrollFactor.set(1, 1);
			ObjectBlendMode.blendMode(backgroundSpr3, "add");
			backgroundSpr3.active = false;
			add(backgroundSpr3);
		}

		var OverlayShader = new OverlayFilter();
		var filter:ShaderFilter = new ShaderFilter(OverlayShader.shader);

		chromaticAbberation = new ChromaticAbberation(0.00001);
		add(chromaticAbberation);
		var filter1:ShaderFilter = new ShaderFilter(chromaticAbberation.shader);

		camGame.setFilters([filter, filter1]);

		var backgroundSpr5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_3_sly', 'hymns'));
		backgroundSpr5.scale.set(1.05, 1.05);
		backgroundSpr5.updateHitbox();
		backgroundSpr5.screenCenter();
		backgroundSpr5.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr5.scrollFactor.set(1.15, 1.15);
		backgroundSpr5.active = false;
		add(backgroundSpr5);

		spotlight = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/spotlight', 'hymns'));
		spotlight.screenCenter();
		spotlight.x -= 150;
		spotlight.y -= 300;
		spotlight.antialiasing = ClientPrefs.data.antialiasing;
		spotlight.scrollFactor.set(1, 1);
		spotlight.alpha = 0;
		spotlight.active = false;
		ObjectBlendMode.blendMode(spotlight, "multiply");
		add(spotlight);
	}

	override function update(elapsed:Float) {
		chromaticAbberation.update(elapsed);
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		switch (eventName) {
			case 'Swindler - Spotlight':
				if (isspotlighting == false) {
					isspotlighting = true;
					FlxTween.tween(spotlight, {alpha: .85}, 5, {ease: FlxEase.circOut});
					FlxTween.tween(spotlight, {x: spotlight.x + 700, y: spotlight.y + 700}, 2, {ease: FlxEase.backOut, startDelay: 5});
				} else {
					FlxTween.tween(spotlight, {alpha: 0}, 3, {ease: FlxEase.backOut});
					FlxTween.tween(spotlight.scale, {x: 1.8, y: 1.8}, 3, {ease: FlxEase.backOut});
					isspotlighting = false;
				}
		}
	}
}
