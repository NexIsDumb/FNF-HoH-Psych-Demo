package substates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import overworld.*;
import options.*;
import backend.*;
import states.*;

class PauseSubState extends MusicBeatSubstate {
	var grpMenuShit:FlxTypedGroup<FlxText>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Options', 'Exit to Dirtmouth', 'Exit to menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:FlxText;
	var flair1:FlxSprite;
	var flair2:FlxSprite;
	var pointer1:FlxSprite;
	var pointer2:FlxSprite;
	var curTime:Float = Math.max(0, Conductor.songPosition);

	// var botplayText:FlxText;
	var offsetthingy:Int = 160;

	public static var silly:Bool = false;

	public static var songName:String = '';

	public function new(x:Float, y:Float) {
		super();

		menuItems = menuItemsOG;

		if (!PlayState.isStoryMode) {
			menuItems = ['Resume', 'Restart Song', 'Options', 'Exit to Dirtmouth', 'Exit to Freeplay'];
			menuItemsOG = ['Resume', 'Restart Song', 'Options', 'Exit to Dirtmouth', 'Exit to Freeplay'];
		} else {
			menuItems = ['Resume', 'Restart Song', 'Options', 'Exit to Dirtmouth', 'Exit to menu'];
			menuItemsOG = ['Resume', 'Restart Song', 'Options', 'Exit to Dirtmouth', 'Exit to menu'];
		}

		if (silly) {
			menuItems = ['Resume', 'Options', 'Exit to Freeplay', 'Exit to menu'];
			menuItemsOG = ['Resume', 'Options', 'Exit to Freeplay', 'Exit to menu'];
		}

		var bg:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 1.4), Std.int(FlxG.height * 1.4), FlxColor.BLACK);
		bg.alpha = 0.5;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20 * 1.4, 150, 0, "", 32);
		if (!silly) {
			levelInfo.text += PlayState.SONG.song;
		}
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Constants.UI_FONT, 46);
		levelInfo.updateHitbox();
		levelInfo.antialiasing = ClientPrefs.data.antialiasing;
		add(levelInfo);

		var blueballedTxt:FlxText = new FlxText(20 * 1.4, (15 + 70) * 1.6, 0, "", 32);
		if (!silly) {
			// blueballedTxt.text = blueballedTxt.translationPub("You have died") + " " + PlayState.deathCounter + " " + blueballedTxt.translationPub("times.") + blueballedTxt.suffixPub("");
		} else {
			blueballedTxt.visible = false;
		}
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('trajan.ttf'), 28);
		blueballedTxt.updateHitbox();
		blueballedTxt.antialiasing = ClientPrefs.data.antialiasing;
		add(blueballedTxt);

		practiceText = new FlxText(20 * 1.4, (15 + 101) * 1.4, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('trajan.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		// add(practiceText);

		var chartingText:FlxText = new FlxText(20 * 1.4, (15 + 101) * 1.4, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('trajan.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		if (!silly) {
			chartingText.visible = PlayState.chartingMode;
		} else {
			chartingText.visible = false;
		}
		chartingText.antialiasing = ClientPrefs.data.antialiasing;
		add(chartingText);

		blueballedTxt.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 200}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		chartingText.screenCenterX();
		practiceText.screenCenterX();
		blueballedTxt.screenCenterX();
		levelInfo.screenCenterX();

		chartingText.x += offsetthingy;
		practiceText.x += offsetthingy;
		blueballedTxt.x += offsetthingy;
		levelInfo.x += offsetthingy;

		grpMenuShit = new FlxTypedGroup<FlxText>();
		add(grpMenuShit);

		pointer1 = new FlxSprite(0, 0);
		pointer1.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer1.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer1.animation.play('idle', true);
		add(pointer1);
		pointer1.antialiasing = ClientPrefs.data.antialiasing;
		pointer1.setGraphicSize(Std.int(pointer1.width * 0.35));
		pointer1.updateHitbox();

		pointer2 = new FlxSprite(0, 0);
		pointer2.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer2.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer2.animation.play('idle', true);
		add(pointer2);
		pointer2.antialiasing = ClientPrefs.data.antialiasing;
		pointer2.flipX = true;
		pointer2.setGraphicSize(Std.int(pointer2.width * 0.35));
		pointer2.updateHitbox();

		regenMenu();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		FlxG.cameras.list[FlxG.cameras.list.length - 1].zoom -= 0.2;
	}

	var holdTime:Float = 0;

	override function update(elapsed:Float) {
		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP) {
			changeSelection(-1);
		}
		if (downP) {
			changeSelection(1);
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected) {
			case 'Skip Time':
				if (controls.UI_LEFT_P) {
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P) {
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if (controls.UI_LEFT || controls.UI_RIGHT) {
					holdTime += elapsed;
					if (holdTime > 0.5) {
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if (curTime >= FlxG.sound.music.length)
						curTime -= FlxG.sound.music.length;
					else if (curTime < 0)
						curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted) {
			if (menuItems == difficultyChoices) {
				if (menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.chartingMode = false;
					return;
				}

				menuItems = menuItemsOG;
				regenMenu();
			}

			switch (daSelected) {
				case "Resume":
					close();
					new FlxTimer().start(.05, function(tmr:FlxTimer) {
						FlxG.cameras.list[FlxG.cameras.list.length - 1].zoom += 0.2;
					});

					FlxG.camera.followLerp = 1;
					persistentUpdate = true;

					if (silly == true) {
						if (FlxG.sound.music != null) {
							FlxG.sound.music.resume();
						}
					} else {
						// new FlxTimer().start(.5, function(tmr:FlxTimer) {
						// PlayState.debouncey = true;
						// });
					}
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case "Restart Song":
					DataSaver.saveSettings(DataSaver.saveFile);
					restartSong();
				case "Options":
					DataSaver.saveSettings(DataSaver.saveFile);
					MusicBeatState.switchState(new OptionsState());
					if (!silly) {
						OptionsState.onPlayState = true;
					} else {
						OptionsState.fromOverworld = true;
					}

				case "Leave Charting Mode":
					restartSong();
					PlayState.chartingMode = false;
				case 'Skip Time':
					if (curTime < Conductor.songPosition) {
						PlayState.startOnTime = curTime;
						restartSong(true);
					} else {
						if (curTime != Conductor.songPosition) {
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case "End Song":
					close();
					PlayState.instance.finishSong(true);
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case "Exit to menu":
					DataSaver.saveSettings(DataSaver.saveFile);

					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					MusicBeatState.switchState(new MainMenuState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;

				case "Exit to Dirtmouth":
					DataSaver.saveSettings(DataSaver.saveFile);
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					MusicBeatState.switchState(new OverworldManager());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;

				case "Exit to Freeplay":
					DataSaver.saveSettings(DataSaver.saveFile);
					DataSaver.loadData(DataSaver.saveFile);
					var rawData:Bool = DataSaver.charmsunlocked.get(Swindler);
					if (rawData) {
						PlayState.deathCounter = 0;
						PlayState.seenCutscene = false;
						MusicBeatState.switchState(new FreeplayState());
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						PlayState.changedDifficulty = false;
						PlayState.chartingMode = false;
					}
			}
		}
	}

	public static function restartSong(noTrans:Bool = false) {
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if (noTrans) {
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		} else {
			MusicBeatState.resetState();
		}
	}

	override function destroy() {
		super.destroy();
	}

	function changeSelection(change:Int = 0):Void {
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		grpMenuShit.forEach(function(spr:FlxText) {
			spr.updateHitbox();

			if (spr.ID == curSelected) {
				var add:Float = 0;
				if (menuItems.length > 4) {
					add = grpMenuShit.length * 8;
				}
				pointer1.screenCenterX();
				pointer1.y = spr.getGraphicMidpoint().y - (spr.height * 0.5);
				pointer1.x -= (spr.width / 1.55);
				pointer1.x += offsetthingy;
				pointer1.animation.play('idle', true);

				pointer2.screenCenterX();
				pointer2.y = spr.getGraphicMidpoint().y - (spr.height * 0.5);
				pointer2.x += (spr.width / 1.55) + offsetthingy;
				pointer2.animation.play('idle', true);
				spr.centerOffsets();
			}
		});
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			// var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			// item.isMenuItem = true;
			// item.targetY = i;
			// grpMenuShit.add(item);

			var item = new FlxText(120, 50 * i + 290 * 1.3, menuItems[i], 24);
			item.scrollFactor.set();
			item.setFormat(Constants.UI_FONT, 26, FlxColor.WHITE, CENTER);
			item.screenCenterX();
			item.x += offsetthingy - 1;
			item.antialiasing = ClientPrefs.data.antialiasing;
			item.ID = i;
			grpMenuShit.add(item);

			var rawData:Bool = DataSaver.charmsunlocked.get(Swindler);
			if (!rawData) {
				if (menuItems[i] == "Exit to Freeplay") {
					item.color = FlxColor.fromRGB(150, 150, 150);
				}
			}
		}

		flair1 = new FlxSprite();
		flair1.frames = Paths.getSparrowAtlas('Menus/Pause/pausefleurtop', 'hymns');
		flair1.animation.addByPrefix('idle', "pause up", 24, false);
		flair1.animation.play('idle');
		flair1.antialiasing = ClientPrefs.data.antialiasing;
		flair1.setGraphicSize(Std.int(flair1.width * 0.6));
		add(flair1);
		flair1.screenCenterXY();
		flair1.y -= 115 * 0.3;
		flair1.x += offsetthingy;

		flair2 = new FlxSprite();
		flair2.frames = Paths.getSparrowAtlas('Menus/Pause/pausefleurbottom', 'hymns');
		flair2.animation.addByPrefix('idle', "pause down", 24, false);
		flair2.animation.play('idle');
		flair2.antialiasing = ClientPrefs.data.antialiasing;
		flair2.setGraphicSize(Std.int(flair1.width * 0.6));
		add(flair2);
		flair2.screenCenterXY();
		flair2.y += 145 * 1.6 + (50 * (menuItems.length - 4));
		flair2.x += offsetthingy;

		curSelected = 0;
		changeSelection();
	}

	function updateSkipTextStuff() {
		if (skipTimeText == null)
			return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText() {
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}
