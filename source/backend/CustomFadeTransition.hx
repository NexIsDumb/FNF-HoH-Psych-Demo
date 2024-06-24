package backend;

import flixel.util.FlxGradient;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;

	private var leTween:FlxTween = null;

	public static var nextCamera:FlxCamera;

	var isTransIn:Bool = false;
	var transBlack:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = FlxMath.bound(FlxG.camera.zoom, 0.05, 1);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);

		transBlack = new FlxSprite().makeSolid(width * 2, height * 2, FlxColor.BLACK);
		transBlack.scale.x = width * 2;
		transBlack.updateHitbox();
		transBlack.scrollFactor.set();
		transBlack.screenCenter();
		transBlack.alpha = 0;
		add(transBlack);

		if (isTransIn) {
			transBlack.alpha = 1;
			FlxTween.tween(transBlack, {alpha: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
				ease: FlxEase.linear
			});
		} else {
			transBlack.alpha = 0;
			leTween = FlxTween.tween(transBlack, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
					if (finishCallback != null) {
						finishCallback();
					}
				},
				ease: FlxEase.linear
			});
		}

		if (nextCamera != null) {
			transBlack.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	override function destroy() {
		if (leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}
