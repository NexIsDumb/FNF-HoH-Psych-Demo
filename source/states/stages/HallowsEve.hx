package states.stages;

import objects.Character;
import openfl.display.BlendMode;
import shaders.Fog;

class HallowsEve extends BaseStage {
	var fogshader:FogEffect;

	override function create() {
		var farback:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stage/abyss', 'hymns'));
		farback.screenCenterXY();
		farback.antialiasing = ClientPrefs.data.antialiasing;
		farback.scrollFactor.set(0.7, 0.7);
		farback.scale.set(1.3, 1.3);
		add(farback);
		var backerground:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stage/backerground', 'hymns'));
		backerground.screenCenterXY();
		backerground.antialiasing = ClientPrefs.data.antialiasing;
		backerground.scrollFactor.set(0.8, 0.8);
		backerground.scale.set(1.3, 1.3);
		fogshader = new FogEffect();
		backerground.shader = fogshader.shader;
		add(backerground); // this one
		var background:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stage/background', 'hymns'));
		background.screenCenterXY();
		background.antialiasing = ClientPrefs.data.antialiasing;
		background.scrollFactor.set(0.9, 0.9);
		background.scale.set(1.3, 1.3);
		add(background);
		var main:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stage/main', 'hymns'));
		main.screenCenterXY();
		main.antialiasing = ClientPrefs.data.antialiasing;
		main.scrollFactor.set(1, 1);
		main.scale.set(1.3, 1.3);
		add(main);
	}

	override function createPost() {
		var foreground:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stage/foreground', 'hymns'));
		foreground.screenCenterXY();
		foreground.antialiasing = ClientPrefs.data.antialiasing;
		foreground.scrollFactor.set(1.1, 1.1);
		foreground.scale.set(1.3, 1.3);
		add(foreground);

		var overlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stage/overlay', 'hymns'));
		overlay.screenCenterXY();
		overlay.antialiasing = ClientPrefs.data.antialiasing;
		overlay.scrollFactor.set(1, 1);
		overlay.scale.set(1.4, 1.4);
		overlay.blend = BlendMode.SUBTRACT;
		add(overlay);
	}

	override function update(elapsed:Float) {
		if (fogshader != null) {
			fogshader.update(elapsed);
		}
	}
}
