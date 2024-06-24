package backend;

import flixel.addons.ui.FlxUIState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxState;

class MusicBeatState extends FlxUIState {
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;

	public var controls(get, never):Controls;

	private function get_controls() {
		return Controls.instance;
	}

	public static var camBeat:FlxCamera;

	override function create() {
		camBeat = FlxG.camera;
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		#if MODS_ALLOWED Mods.updatedOnState = false; #end

		super.create();

		if (!skip) {
			openSubState(new CustomFadeTransition(0.7, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
		timePassedOnState = 0;
	}

	public static var timePassedOnState:Float = 0;

	override function update(elapsed:Float) {
		// everyStep();
		var oldStep:Int = curStep;
		timePassedOnState += elapsed;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep) {
			if (curStep > 0)
				stepHit();

			if (PlayState.SONG != null) {
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		#if (debug && sys)
		if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.Z) {
			FlxTransitionableState.skipNextTransOut = true;
			FlxTransitionableState.skipNextTransIn = true;
			MusicBeatState.switchState(new states.debug.DebugSongSelect());
		}
		if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.X) {
			FlxTransitionableState.skipNextTransOut = true;
			FlxTransitionableState.skipNextTransIn = true;
			MusicBeatState.switchState(new states.debug.DebugStateSelect());
		}
		#end

		if (FlxG.save.data != null)
			FlxG.save.data.fullscreen = FlxG.fullscreen;

		stagesFunc(function(stage:BaseStage) {
			stage.update(elapsed);
		});

		super.update(elapsed);
	}

	private function updateSection():Void {
		if (stepsToDo < 1)
			stepsToDo = Math.round(getBeatsOnSection() * 4);
		while (curStep >= stepsToDo) {
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void {
		if (curStep < 0)
			return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length) {
			if (PlayState.SONG.notes[i] != null) {
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if (stepsToDo > curStep)
					break;

				curSection++;
			}
		}

		if (curSection > lastSection)
			sectionHit();
	}

	private function updateBeat():Void {
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep / 4;
	}

	private function updateCurStep():Void {
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState = null) {
		if (nextState == null)
			nextState = FlxG.state;
		if (nextState == FlxG.state) {
			resetState();
			return;
		}

		if (FlxTransitionableState.skipNextTransIn)
			FlxG.switchState(nextState);
		else
			startTransition(nextState);
		FlxTransitionableState.skipNextTransIn = false;
	}

	public static function resetState() {
		if (FlxTransitionableState.skipNextTransIn)
			FlxG.resetState();
		else
			startTransition();
		FlxTransitionableState.skipNextTransIn = false;
	}

	// Custom made Trans in
	public static function startTransition(nextState:FlxState = null) {
		if (nextState == null)
			nextState = FlxG.state;

		FlxG.state.openSubState(new CustomFadeTransition(0.6, false));
		if (nextState == FlxG.state)
			CustomFadeTransition.finishCallback = function() FlxG.resetState();
		else
			CustomFadeTransition.finishCallback = function() FlxG.switchState(nextState);
	}

	public static function getState():MusicBeatState {
		return cast(FlxG.state, MusicBeatState);
	}

	public function stepHit():Void {
		stagesFunc(function(stage:BaseStage) {
			stage.curStep = curStep;
			stage.curDecStep = curDecStep;
			stage.stepHit();
		});

		if (curStep % 4 == 0)
			beatHit();
	}

	public var stages:Array<BaseStage> = [];

	public function beatHit():Void {
		// trace('Beat: ' + curBeat);
		stagesFunc(function(stage:BaseStage) {
			stage.curBeat = curBeat;
			stage.curDecBeat = curDecBeat;
			stage.beatHit();
		});
	}

	public function sectionHit():Void {
		// trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
		stagesFunc(function(stage:BaseStage) {
			stage.curSection = curSection;
			stage.sectionHit();
		});
	}

	function stagesFunc(func:BaseStage->Void) {
		for (stage in stages)
			if (stage != null && stage.exists && stage.active)
				func(stage);
	}

	function getBeatsOnSection() {
		var val:Null<Float> = 4;
		if (PlayState.SONG != null && PlayState.SONG.notes[curSection] != null)
			val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}

	var _message:FlxText;
	var message(get, null):FlxText;

	function get_message():FlxText {
		if (_message == null) {
			_message = new FlxText(0, 0, FlxG.width);
			_message.size = 26;
			_message.borderSize = 1.25;
			_message.alignment = CENTER;
			_message.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			_message.scrollFactor.set();
			_message.screenCenterXY();
			_message.alpha = 0;
		}

		return _message;
	}

	var messageTween:FlxTween;

	public function showMessage(text:String = "", level = 0, delayUntilFade:Float = 0.5):Void {
		// TODO: Add message queue
		message.alpha = 1;

		message.color = switch (level) {
			case 0: 0xFFffffff; // Info
			case 1: 0xFFff0000; // Error
			case 2: 0xFFffFF00; // Warning
			case 3: 0xFF00FF00; // Good
			default: 0xFFffffff;
		}
		message.text = text;

		message.screenCenterXY();

		remove(message, true);
		add(message);

		message.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		if (messageTween != null) {
			messageTween.cancel();
		}
		messageTween = FlxTween.tween(message, {alpha: 0}, 1.3, {
			startDelay: delayUntilFade,
			onComplete: (v) -> {
				remove(message, true);
			}
		});
	}
}
