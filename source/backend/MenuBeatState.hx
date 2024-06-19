package backend;

import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideoSprite;
#end

class MenuBeatState extends MusicBeatState {
	#if VIDEOS_ALLOWED
	public static var bgVideo:FlxVideoSprite = null;
	#end

	override function create() {
		super.create();

		#if VIDEOS_ALLOWED
		if (bgVideo == null) {
			if ((bgVideo = new FlxVideoSprite()).load(Paths.video("Classic") /*, [':no-audio']*/)) { // keeping it disabled for now cuz of the tons of no audio warnings  - Nex
				bgVideo.bitmap.onFormatSetup.add(() -> {
					bgVideo.setGraphicSize(FlxG.width, FlxG.height);
					bgVideo.updateHitbox();
				});
				bgVideo.bitmap.onEndReached.add(() -> {
					bgVideo.stop();
					bgVideo.bitmap.position = 0;
					bgVideo.play();
				});

				bgVideo.antialiasing = ClientPrefs.data.antialiasing;
				bgVideo.scrollFactor.set();
				insert(0, bgVideo);
				bgVideo.play();
			} else
				removeVideo();
		} else
			insert(0, bgVideo);
		#end
	}

	#if VIDEOS_ALLOWED
	public inline function removeVideo() {
		if (bgVideo == null)
			return;

		bgVideo.destroy();
		bgVideo = null;
	}
	#end

	override public function destroy() {
		#if VIDEOS_ALLOWED
		remove(bgVideo);
		@:privateAccess
		if (!(FlxG.game._requestedState is MenuBeatState))
			removeVideo();
		#end

		super.destroy();
	}
}
