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

		stageproperties.minX = -295.70;
		stageproperties.maxX = 965.02;

		stageproperties.interactionpoints = [[740.54, "slypoint"]];
	}

	var sly:FlxSprite;
	var shop:Shop;
	var interactionBackdrop:FlxSprite;

	override public function create(?input:String) {
		var backgroundSpr1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_1_sly', 'hymns'));
		backgroundSpr1.scale.set(0.4, 0.4);
		backgroundSpr1.screenCenterXY();
		backgroundSpr1.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr1.scrollFactor.set(1, 1);
		backgroundSpr1.active = false;
		add(backgroundSpr1);

		var backgroundSpr2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/bg_2_sly', 'hymns'));
		backgroundSpr2.scale.set(0.4, 0.4);
		backgroundSpr2.screenCenterXY();
		backgroundSpr2.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr2.scrollFactor.set(1, 1);
		backgroundSpr2.active = false;
		add(backgroundSpr2);

		shop = new Shop();
		shop.screenCenterXY();
		shop.x += FlxG.width / 4;
		shop.cameras = [game.camDIALOG];
		add(shop);

		sly = new FlxSprite(0, 0);
		sly.frames = Paths.getSparrowAtlas('Overworld/SlyShop', 'hymns');
		sly.scale.set(0.36, 0.36);
		sly.updateHitbox();
		sly.screenCenterXY();
		sly.x += 250 * (0.25 / 0.36);
		sly.y += 225 * (0.25 / 0.36);
		sly.animation.addByPrefix('idle', 'SlyShopIdle0', 24, true);
		sly.animation.addByPrefix('turnidle', 'SlyShopIdleTurned0', 24, true);
		sly.animation.addByPrefix('turnLeft', 'SlyShopTurnR0', 24, false);
		sly.animation.addByIndices('turnLeftFrame', 'SlyShopTurnR0', [8], "", 24, false);
		sly.animation.addByPrefix('turnRight', 'SlyShopTurnL0', 24, false);
		// sly.animation.addByPrefix('talk', 'elderbug talk loop0', 24, true);
		// sly.animation.addByPrefix('talkL', 'elderbug talk loop left0', 24, true);
		sly.animation.play('idle', true);
		sly.flipX = true;
		sly.centerOrigin();
		sly.antialiasing = ClientPrefs.data.antialiasing;
		add(sly);

		slyshop = true;

		if (input == "swindler") {
			startPlayerNearSly = true;
		}
	}

	var created = false;
	var startPlayerNearSly = false;
	var slyTurned:Bool = false;

	var overlayShader:OverlayFilter;

	override public function createPost() {
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
			backgroundSpr3.screenCenterXY();
			backgroundSpr3.antialiasing = ClientPrefs.data.antialiasing;
			backgroundSpr3.scrollFactor.set(1, 1);
			backgroundSpr3.blend = ADD;
			backgroundSpr3.active = false;
			add(backgroundSpr3);
		}

		var backgroundSpr5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Stages/Shop/slyshop', 'hymns'));
		backgroundSpr5.scale.set(0.415, 0.415);
		backgroundSpr5.screenCenterXY();
		backgroundSpr5.antialiasing = ClientPrefs.data.antialiasing;
		backgroundSpr5.y -= 17;
		backgroundSpr5.x -= 117.5;
		backgroundSpr5.active = false;
		add(backgroundSpr5);

		// Shader
		if (ClientPrefs.data.shaders) {
			overlayShader = new OverlayFilter();
			FlxG.camera.addShader(overlayShader.shader);
		}

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

		game.player.y -= 80;
		game.player.oldy = game.player.y;
		// game.player.x -= 310;
		game.player.x = 261.8;

		if (startPlayerNearSly) {
			var point = stageproperties.interactionpoints[0];
			var extrarange:Float = 150;
			game.player.x = point[0];
		}
		game.player.flipX = true;
	}

	var interactionflair:FlxSprite;
	var interactiontext:FlxText;
	var scenery:Bool = false;

	function getAnimationName(spr:FlxSprite) {
		if (spr.animation != null && spr.animation.curAnim != null) {
			return spr.animation.curAnim.name;
		}
		return "";
	}

	var lastAnim = "";
	var lastFinished = false;

	override function update(elapsed:Float) {
		interactionflair.update(elapsed);
		sly.update(elapsed);
		if (shop != null)
			shop.update(elapsed);
		if ((game.player.x <= stageproperties.minX + 480) && scenery == false) {
			scenery = true;
			game.player.crippleStatus(true, "leaving shop");
			exitWalking = true;
			game.switchScenery(new Dirtmouth());
			// Controls.acceptTimer = true;
		}

		/*if(lastAnim != animName || lastFinished !=finish){
			lastAnim = animName;
			lastFinished = finish;
			trace(animName, finish);
		}*/

		// This could have been done better if I added onFinished earlier... lol oh well
		if (sly == null || sly.animation == null || sly.animation.curAnim == null)
			return;
		var finish = sly.animation.curAnim.finished;
		var animName = getAnimationName(sly);

		if (game.player.x > sly.x && animName != "turnidle" && !inshop) {
			sly.animation.play('turnRight', false);
			sly.animation.onFinish.add((anim) -> {
				if (anim == 'turnRight')
					sly.animation.play('turnidle', true);
			});
			slyTurned = true;
		} else if (game.player.x <= sly.x && animName != "idle" && !inshop) {
			sly.animation.play('turnLeft', false);
			sly.animation.onFinish.add((anim) -> {
				if (anim == 'turnLeft')
					sly.animation.play('idle', true);
			});
			slyTurned = false;
		}

		interactionpoint();
	}

	var inInteraction:Bool = false;
	var tweenflair:FlxTween;
	var tweentext:FlxTween;
	var tweenbg:FlxTween;

	function interactionpoint(?interactInput:String) {
		var hasfound = false;
		for (i in 0...stageproperties.interactionpoints.length) {
			var point = stageproperties.interactionpoints[i];
			var extrarange:Float = 150;

			if (point[0] - extrarange < game.player.x && point[0] + extrarange > game.player.x && !inshop) {
				hasfound = true;
				interactionflair.alpha = 1;
				interactionflair.x = point[0] - interactionflair.width / 4;
				interactiontext.alpha = 1;
				var flairPos = interactionflair.getGraphicMidpoint();
				interactiontext.x = flairPos.x - interactiontext.width / 2;

				interactionBackdrop.y = flairPos.y - interactionflair.height / 2.5;
				interactionBackdrop.x = flairPos.x - interactionflair.width / 3.25;

				flairPos.put();

				interactiontext.text = TM.checkTransl("Shop", "shop");

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

				if (controls.ACCEPT || startPlayerNearSly) {
					inInteraction = true;
					startPlayerNearSly = false;

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
	}

	function interaction(thing:String) {
		switch (thing) {
			case "slypoint":
				if (OverworldManager.instance.scene.inshop == false) {
					shop.callback();
					FlxG.state.closeSubState();

					OverworldManager.instance.scene.inshop = true;
					game.player.crippleStatus(true, "in shop, slypoint");
					if (slyTurned) {
						sly.animation.play('turnLeft', false);
						slyTurned = false;
					}
					new FlxTimer().start(0.2, function(tmr:FlxTimer) {
						sly.animation.play('idle', true);
						slyTurned = false;
					});
				}
		}
	}

	override public function destroy() {
		super.destroy();
		if (overlayShader != null) {
			FlxG.camera.removeShader(overlayShader.shader);
			overlayShader = null;
		}
	}
}
