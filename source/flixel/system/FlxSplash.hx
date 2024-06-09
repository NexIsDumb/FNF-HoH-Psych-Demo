package flixel.system;

#if VIDEOS_ALLOWED
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

class FlxSplash extends FlxState
{
	public static var nextState:Class<FlxState>;

	/**
	 * @since 4.8.0
	 */
	public static var muted:Bool = #if html5 true #else false #end;

	var intro:VideoHandler;
	private var _cachedMuted:Bool;

	override public function create():Void
	{
		intro = new VideoHandler();
		intro.play(Paths.video("splash"));
		intro.onEndReached.add(onComplete, true);

		if (muted) {
			_cachedMuted = FlxG.sound.muted;
			FlxG.sound.muted = true;
		}
	}

	override public function destroy():Void
	{
		if(intro != null) intro.dispose();
		super.destroy();
	}

	function onComplete():Void
	{
		FlxG.sound.muted = _cachedMuted;
		FlxG.switchState(Type.createInstance(nextState, []));
		FlxG.game._gameJustStarted = true;
	}
}
