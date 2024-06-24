package substates;

import flixel.FlxObject;
import objects.Character;
import overworld.*;
import states.FreeplayState;

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
		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		PlayState.instance.callOnScripts('onGameOverStart', []);
		#end

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float) {
		super();

		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		PlayState.instance.setOnScripts('inGameOver', true);
		#end

		Conductor.songPosition = 0;

		boyfriends = PlayState.instance.boyfriendd;

		FlxG.sound.play(Paths.sound("deathhymn", "hymns"));

		boyfriends.playAnim('firstDeath');

		camFollow = new FlxObject(camX, camY, 1, 1);
		// FlxG.camera.focusOn(new FlxPoint((PlayState.instance.camGame.x * (1 - PlayState.instance.defaultCamZoom + 1)) + (PlayState.instance.camGame.width/2) * (1 - PlayState.instance.defaultCamZoom + 1), (PlayState.instance.camGame.y * (1 - PlayState.instance.defaultCamZoom + 1)) + (PlayState.instance.camGame.height/2) * (1 - PlayState.instance.defaultCamZoom + 1)));
		add(camFollow);

		if (PlayState.instance.formattedSong == "swindler") {
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
			var pos = boyfriends.getMidpoint();
			camFollow.setPosition(pos.x + boyfriends.width / 2, pos.y - boyfriends.height / 2);
			if (boyfriends.curCharacter == "vbflichendead") {
				camFollow.setPosition(pos.x + boyfriends.width / 3, pos.y - boyfriends.height / 3.5);
			}
			pos.put();
		}
		FlxTween.tween(PlayState.instance.blackahhh, {alpha: .8}, 4, {ease: FlxEase.circOut});
		FlxTween.tween(PlayState.instance.playerfog, {alpha: .5}, 4, {ease: FlxEase.circOut});
	}

	public var startedDeath:Bool = false;

	var isFollowingAlready:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);
		boyfriends.update(elapsed);

		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		PlayState.instance.callOnScripts('onUpdate', [elapsed]);
		#end

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
			#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
			PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
			#end
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
					playingDeathSound = true;
					coolStartDeath();
				}
			}
		}

		FlxG.camera.followLerp = FlxMath.bound(elapsed * 0.6 / (FlxG.updateFramerate / 60), 0, 1);

		if (FlxG.sound.music.playing) {
			Conductor.songPosition = FlxG.sound.music.time;
		}
		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
		#end
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
			#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
			PlayState.instance.callOnScripts('onGameOverConfirm', [true]);
			#end
		}
	}

	override function destroy() {
		instance = null;
		super.destroy();
	}
}
