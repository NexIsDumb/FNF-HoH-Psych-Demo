package overworld.scenes;

import haxe.macro.Type.MethodKind;
import objects.Character;
import openfl.display.BlendMode;
import backend.ObjectBlendMode;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import overworld.scenes.charms.*;
import overworld.*;
import shaders.Overlay;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import shaders.Shaders;

class SlyShop extends BaseScene {
	override public function new() {
		super();
	}

	override public function variableInitialize() {
		// stageproperties.minCam = -592;
		// stageproperties.maxCam = 1879;347.5

		stageproperties.minCam = 600.5;
		stageproperties.maxCam = 600.5;

		stageproperties.minX = -295.700198223638;
		stageproperties.maxX = 965.020300349376;

		stageproperties.interactionpoints = [[740.542147539586, "slypoint"]];
	}

	var sly:FlxSprite;
	var shop:Shop;
	var interactionBackdrop:FlxSprite;

	override public function create() {
		var backgroundSpr1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_1_sly', 'hymns'));
		backgroundSpr1.scale.set(0.4, 0.4);
		backgroundSpr1.screenCenter();
		backgroundSpr1.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr1.scrollFactor.set(1, 1);
		backgroundSpr1.active = false;
		add(backgroundSpr1);

		var backgroundSpr2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_2_sly', 'hymns'));
		backgroundSpr2.scale.set(0.4, 0.4);
		backgroundSpr2.screenCenter();
		backgroundSpr2.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr2.scrollFactor.set(1, 1);
		backgroundSpr2.active = false;
		add(backgroundSpr2);

		shop = new Shop();
		shop.screenCenter();
		shop.x += FlxG.width / 4;
		shop.cameras = [game.camDIALOG];
		add(shop);

		slyshop = true;
	}

	override public function createPost() {
		sly = new FlxSprite(0, 0);
		sly.frames = Paths.getSparrowAtlas('Overworld/SlyShop (1)', 'hymns');
		sly.scale.set(0.24, 0.24);
		sly.updateHitbox();
		sly.screenCenter();
		sly.x += 250;
		sly.y += 225;
		sly.animation.addByPrefix('idle', 'SlyShopidle', 24, true);
		sly.animation.play('idle', true);
		sly.flipX = true;
		sly.centerOrigin();
		sly.antialiasing = ClientPrefs.data.antialiasing;
		add(sly);

		interactionflair = new FlxSprite(0, sly.y - 120);
		interactionflair.scale.set(0.9, 0.9);
		interactionflair.updateHitbox();
		interactionflair.frames = Paths.getSparrowAtlas('Overworld/PromptFlair', 'hymns');
		interactionflair.animation.addByPrefix("appear", "promptappear", 24, false);
		interactionflair.animation.addByPrefix("idle", "promptidle", 24, true);
		interactionflair.animation.addByPrefix("disappear", "promptdisappear", 24, false);
		interactionflair.animation.play("disappear");
		interactionflair.alpha = 0;

		if (!ClientPrefs.data.lowQuality) {
			var backgroundSpr3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_blend_sly', 'hymns'));
			backgroundSpr3.scale.set(0.4, 0.4);
			backgroundSpr3.y -= 50;
			backgroundSpr3.x += 10;
			backgroundSpr3.screenCenter();
			backgroundSpr3.antialiasing = ClientPrefs.data.antialiasing;
			backgroundSpr3.scrollFactor.set(1, 1);
			ObjectBlendMode.blendMode(backgroundSpr3, "add");
			backgroundSpr3.active = false;
			add(backgroundSpr3);
		}

		var backgroundSpr5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/slyshop', 'hymns'));
		backgroundSpr5.scale.set(0.415, 0.415);
		backgroundSpr5.screenCenter();
		backgroundSpr5.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr5.y -= 17;
		backgroundSpr5.x -= 117.5;
		backgroundSpr5.active = false;
		add(backgroundSpr5);

		// Shader
		var OverlayShader = new OverlayFilter();
		var filter:ShaderFilter = new ShaderFilter(OverlayShader.shader);
		FlxG.camera.setFilters([filter]);

		interactionBackdrop = new FlxSprite(0, 0).loadGraphic(Paths.image('Overworld/textthing', 'hymns'));
		interactionBackdrop.antialiasing = ClientPrefs.data.antialiasing;
		interactionBackdrop.alpha = 0;
		interactionBackdrop.updateHitbox();
		add(interactionBackdrop);

		add(interactionflair);

		interactiontext = new FlxText(0, interactionflair.getGraphicMidpoint().y - interactionflair.height / 5, 0, 'Interact', 28);
		interactiontext.setFormat(Paths.font("trajan.ttf"), 32, FlxColor.WHITE, CENTER);
		interactiontext.antialiasing = ClientPrefs.data.antialiasing;
		interactiontext.alpha = 0;
		add(interactiontext);

		game.player.y -= 100;
		game.player.oldy = game.player.y;
		game.player.x -= 310;
		game.player.flipX = true;
	}

	var interactionflair:FlxSprite;
	var interactiontext:FlxText;
	var scenery:Bool = false;

	override function update(elapsed:Float) {
		interactionflair.update(elapsed);
		sly.update(elapsed);
		if (shop != null)
			shop.update(elapsed);
		if ((game.player.x <= stageproperties.minX + 480) && scenery == false) {
			scenery = true;
			game.player.status.cripple = true;
			game.switchScenery(new Dirtmouth());
		}

		interactionpoint();
	}

	var inInteraction:Bool = false;
	var tweenflair:FlxTween;
	var tweentext:FlxTween;
	var tweenbg:FlxTween;

	function interactionpoint() {
		var hasfound = false;
		for (i in 0...stageproperties.interactionpoints.length) {
			var point = stageproperties.interactionpoints[i];
			var extrarange:Float = 150;

			if (point[0] - extrarange < game.player.x && point[0] + extrarange > game.player.x && !inshop) {
				hasfound = true;
				interactionflair.alpha = 1;
				interactionflair.x = point[0] - interactionflair.width / 4;
				interactiontext.alpha = 1;
				interactiontext.x = interactionflair.getGraphicMidpoint().x - interactiontext.width / 2;

				interactionBackdrop.y = interactionflair.getGraphicMidpoint().y - interactionflair.height / 2.5;
				interactionBackdrop.x = interactionflair.getGraphicMidpoint().x - interactionflair.width / 3.25;

				interactiontext.text = "Shop";

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

				if (controls.ACCEPT) {
					inInteraction = true;
					interaction(point[1]);
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

		if (FlxG.keys.justPressed.SPACE) {
			trace(game.player.x);
		}
	}

	function interaction(thing:String) {
		switch (thing) {
			case "slypoint":
				if (OverworldManager.instance.scene.inshop == false) {
					shop.callback();
					FlxG.state.closeSubState();

					OverworldManager.instance.scene.inshop = true;
					game.player.status.cripple = true;
				}
		}
	}
}
