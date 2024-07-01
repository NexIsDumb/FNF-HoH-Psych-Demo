package substates;

import backend.WeekData;
import objects.Character;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import states.FreeplayState;
import overworld.*;

class SillySub extends MusicBeatSubstate {
	var camFollow:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	public static var instance:SillySub;

	public var dialogue:Dialogue;

	override function create() {
		instance = this;
		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		PlayState.instance.callOnScripts('onGameOverStart', []);
		#end

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float) {
		super();

		dialogue = new Dialogue();
		dialogue.screenCenterXY();
		dialogue.y -= 200;
		dialogue.x += 10;
		dialogue.cameras = [PlayState.instance.camOtheristic];
		add(dialogue);

		dialogue.openBox("Elderbug",
			[
				[
					TM.checkTransl("I apologize, my singing must be a little rusty. Lets try that again, Traveler.", "elderbug-dialog-3")
				]
			],
			function() {
				MusicBeatState.resetState();
			}
		);
	}

	public var startedDeath:Bool = false;

	var isFollowingAlready:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);

		FlxG.camera.followLerp = FlxMath.bound(elapsed * 0.6 / (FlxG.updateFramerate / 60), 0, 1);

		if (FlxG.sound.music.playing) {
			Conductor.songPosition = FlxG.sound.music.time;
		}
		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
		#end

		dialogue.update(elapsed);
	}

	var isEnding:Bool = false;

	override function destroy() {
		instance = null;
		super.destroy();
	}
}
