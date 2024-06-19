package flixel.system;

import openfl.Lib;
#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideoSprite;
#end

class FlxSplash extends FlxState {
	public static var nextState:Class<FlxState>;

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

		#if VIDEOS_ALLOWED
		if (muted) {
			_cachedMuted = FlxG.sound.muted;
			FlxG.sound.muted = true;
		}

		if ((intro = new FlxVideoSprite()).load(Paths.video("splash"))) {
			intro.bitmap.onFormatSetup.add(() -> {
				intro.setGraphicSize(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
				intro.updateHitbox();
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
		FlxG.switchState(Type.createInstance(nextState, []));
		FlxG.game._gameJustStarted = true;
	}
}
