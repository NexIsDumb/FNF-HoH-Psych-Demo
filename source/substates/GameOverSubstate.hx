package substates;

import backend.WeekData;
import objects.Character;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import states.StoryMenuState;
import states.FreeplayState;
import overworld.*;

class GameOverSubstate extends MusicBeatSubstate {
	public var boyfriends:Character;

	var camFollow:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'VBF_DIES';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	var soundstart:FlxSound;
	var soundloop:FlxSound;
	var soundend:FlxSound;

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'VBF_DIES';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';

		var _song = PlayState.SONG;
		if (_song != null) {
			if (_song.gameOverChar != null && _song.gameOverChar.trim().length > 0)
				characterName = _song.gameOverChar;
			if (_song.gameOverSound != null && _song.gameOverSound.trim().length > 0)
				deathSoundName = _song.gameOverSound;
			if (_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0)
				loopSoundName = _song.gameOverLoop;
			if (_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0)
				endSoundName = _song.gameOverEnd;
		}
	}

	override function create() {
		instance = this;
		PlayState.instance.callOnScripts('onGameOverStart', []);

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float) {
		super();

		PlayState.instance.setOnScripts('inGameOver', true);

		Conductor.songPosition = 0;

		boyfriends = PlayState.instance.boyfriendd;

		FlxG.sound.play(Paths.sound("deathhymn", "hymns"));

		boyfriends.playAnim('firstDeath');

		camFollow = new FlxObject(camX, camY, 1, 1);
		// FlxG.camera.focusOn(new FlxPoint((PlayState.instance.camGame.x * (1 - PlayState.instance.defaultCamZoom + 1)) + (PlayState.instance.camGame.width/2) * (1 - PlayState.instance.defaultCamZoom + 1), (PlayState.instance.camGame.y * (1 - PlayState.instance.defaultCamZoom + 1)) + (PlayState.instance.camGame.height/2) * (1 - PlayState.instance.defaultCamZoom + 1)));
		add(camFollow);

		if (PlayState.SONG.song.toLowerCase() == "swindler") {
			FlxG.sound.play("songs:assets/songs/swindler/gameoverStart.ogg");
			soundloop = FlxG.sound.load("songs:assets/songs/swindler/gameoverLoop.ogg");
			soundloop.looped = true;
			soundend = FlxG.sound.load("songs:assets/songs/swindler/gameoverEnd.ogg");
			FlxTween.tween(FlxG.camera, {zoom: 1.5}, 2.5, {ease: FlxEase.circOut});
		} else {
			soundloop = FlxG.sound.load("songs:assets/songs/lichen/gameOverLichLoop.ogg");
			soundloop.looped = true;
			soundend = FlxG.sound.load("songs:assets/songs/lichen/gameOverLichEnd.ogg");
			FlxTween.tween(FlxG.camera, {zoom: 1.2}, 2.5, {ease: FlxEase.circOut});
			camFollow.setPosition(boyfriends.getMidpoint().x + boyfriends.width / 2, boyfriends.getMidpoint().y - boyfriends.height / 2);
			if (boyfriends.curCharacter == "vbflichendead") {
				camFollow.setPosition(boyfriends.getMidpoint().x + boyfriends.width / 3, boyfriends.getMidpoint().y - boyfriends.height / 3.5);
			}
		}
		FlxTween.tween(PlayState.instance.blackahhh, {alpha: .8}, 4, {ease: FlxEase.circOut});
		FlxTween.tween(PlayState.instance.playerfog, {alpha: .5}, 4, {ease: FlxEase.circOut});
	}

	public var startedDeath:Bool = false;

	var isFollowingAlready:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);
		boyfriends.update(elapsed);

		PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		if (controls.ACCEPT) {
			endBullshit();
		}

		if (controls.BACK) {
			#if desktop DiscordClient.resetClientID(); #end
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;

			Mods.loadTopMod();
			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new OverworldManager());
			else
				MusicBeatState.switchState(new FreeplayState());

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
		}

		if (boyfriends.animation.curAnim != null) {
			if (boyfriends.animation.curAnim.name == 'firstDeath' && boyfriends.animation.curAnim.finished && startedDeath)
				boyfriends.playAnim('deathLoop');

			if (boyfriends.animation.curAnim.name == 'firstDeath') {
				if (boyfriends.animation.curAnim.curFrame >= 12 && !isFollowingAlready) {
					FlxG.camera.follow(camFollow, LOCKON, 0);
					updateCamera = true;
					isFollowingAlready = true;
				}

				if (boyfriends.animation.curAnim.finished && !playingDeathSound) {
					startedDeath = true;
					if (PlayState.SONG.stage == 'tank') {
						playingDeathSound = true;
						coolStartDeath(0.2);

						var exclude:Array<Int> = [];
						// if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];

						FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
							if (!isEnding) {
								FlxG.sound.music.fadeIn(0.2, 1, 4);
							}
						});
					} else
						coolStartDeath();
				}
			}
		}

		FlxG.camera.followLerp = FlxMath.bound(elapsed * 0.6 / (FlxG.updateFramerate / 60), 0, 1);

		if (FlxG.sound.music.playing) {
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void {
		soundloop.play(true);
	}

	function endBullshit():Void {
		if (!isEnding) {
			isEnding = true;
			boyfriends.playAnim('deathConfirm', true);
			soundloop.stop();
			soundend.play(false);
			FlxTween.tween(PlayState.instance.blackahhh, {alpha: 0}, 1, {ease: FlxEase.circOut});
			FlxTween.tween(PlayState.instance.playerfog, {alpha: 0}, 1, {ease: FlxEase.circOut});
			new FlxTimer().start(0.7, function(tmr:FlxTimer) {
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
					DataSaver.loadData(DataSaver.saveFile);
					if (DataSaver.doingsong == "First-Steps") {
						MusicBeatState.resetState();
					} else {
						MusicBeatState.resetState();
					}
				});
			});
			PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
		}
	}

	override function destroy() {
		instance = null;
		super.destroy();
	}
}
