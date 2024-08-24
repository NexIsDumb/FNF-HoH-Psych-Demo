package states;

import flixel.input.keyboard.FlxKey;
import openfl.Lib;
#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideoSprite;
#end

class SplashScreen extends flixel.FlxState {
	/**
	 * @since 4.8.0
	 */
	public static var muted:Bool = #if html5 true #else false #end;

	private var _cachedMuted:Bool;

	#if VIDEOS_ALLOWED
	var intro:FlxVideoSprite;
	#end

	override public function create():Void {
		super.create();

		FlxG.save.bind('hymns', CoolUtil.getSavePath());
		ClientPrefs.loadPrefs();
		DataSaver.fontScale = 1;
		backend.TransManager.languageFont = null;
		backend.TransManager.languageFontDialogue = null;
		TM.setTransl();

		@:privateAccess FlxG.keys._nativeCorrection.set("0_43", FlxKey.PLUS);

		#if VIDEOS_ALLOWED
		if (muted) {
			_cachedMuted = FlxG.sound.muted;
			FlxG.sound.muted = true;
		}

		if ((intro = new FlxVideoSprite()).load(Paths.video("splash"))) {
			intro.bitmap.onFormatSetup.add(function():Void {
				if (intro.bitmap != null && intro.bitmap.bitmapData != null) {
					intro.setGraphicSize(FlxG.width);
					intro.updateHitbox();
					intro.screenCenter();
				}
			});
			intro.bitmap.onEndReached.add(onComplete);
			intro.antialiasing = ClientPrefs.data.antialiasing;
			intro.play();
			add(intro);
		} else
		#end
		{
			onComplete();
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (Controls.instance.ACCEPT)
			onComplete();
	}

	private var fired:Bool = false;

	function onComplete():Void {
		if (fired) // Precautions because of the skippable part  - Nex
			return;
		fired = true;

		#if VIDEOS_ALLOWED
		if (intro != null)
			intro.destroy();
		#end

		FlxG.sound.muted = _cachedMuted;
		// FlxG.switchState(new MainMenuState());
		if (!ClientPrefs.data.hasShownLanguageSelection || FlxG.keys.pressed.ALT) {
			LanguageSelection.fromSplash = true;
			FlxG.switchState(new LanguageSelection());
			ClientPrefs.data.hasShownLanguageSelection = true;
		} else {
			FlxG.switchState(new MainMenuState());
		}
		@:privateAccess FlxG.game._gameJustStarted = true;
	}
}
