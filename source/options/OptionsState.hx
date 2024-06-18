package options;

import states.MainMenuState;
import backend.StageData;
import flixel.addons.transition.FlxTransitionableState;
import hxcodec.flixel.*;
import overworld.*;

class OptionsState extends MusicBeatState {
	var options:Array<String> = ['Note Colors', 'Controls', 'Graphics', 'Visuals and UI', 'Gameplay', 'Back'];
	private var grpOptions:FlxTypedGroup<FlxText>;

	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	public static var video:FlxVideo;
	public static var fromOverworld:Bool = false;

	function openSelectedSubstate(label:String) {
		for (spr in grpOptions.members) {
			FlxTween.tween(spr, {alpha: 0}, .25, {ease: FlxEase.circOut});
		}
		FlxTween.tween(pointer1, {alpha: 0}, .25, {ease: FlxEase.circOut});
		FlxTween.tween(pointer2, {alpha: 0}, .25, {ease: FlxEase.circOut});
		FlxTween.tween(statetext, {alpha: 0}, .25, {ease: FlxEase.circOut});
		fleur.animation.play('idle', true, true);
		new FlxTimer().start(.35, function(tmr:FlxTimer) {
			if (label != 'Note Colors' && label != 'Back') {
				statetext.text = label;
				statetext.screenCenter(X);
				FlxTween.tween(statetext, {alpha: 1}, .25, {ease: FlxEase.circOut});
				fleur.animation.play('idle', true, false);
			} else {
				FlxTween.tween(fleur, {alpha: 0}, .25, {ease: FlxEase.circOut});
			}

			switch (label) {
				case 'Note Colors': openSubState(new options.NotesSubState());
				case 'Controls': openSubState(new options.ControlsSubState());
				case 'Graphics': openSubState(new options.GraphicsSettingsSubState());
				case 'Visuals and UI': openSubState(new options.VisualsUISubState());
				case 'Gameplay': openSubState(new options.GameplaySettingsSubState());
				case 'Back':
					openingsub = true;
					FlxG.sound.play(Paths.sound('cancelMenu'));

					new FlxTimer().start(.5, function(tmr:FlxTimer) {
						video.dispose();
						video = null;
					});

					if (onPlayState) {
						StageData.loadDirectory(PlayState.SONG);
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.sound.music.volume = 0;
					} else {
						if (fromOverworld) {
							LoadingState.loadAndSwitchState(new OverworldManager());
							FlxG.sound.music.volume = 0;
						} else {
							MusicBeatState.switchState(new MainMenuState());
						}
					}
			}
		});
	}

	var pointer1:FlxSprite;
	var pointer2:FlxSprite;
	var fleur:FlxSprite;
	var statetext:FlxText;

	var bg:FlxSprite;
	var openingsub:Bool = true;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		persistentUpdate = persistentDraw = true;
		selectedsumn = false;

		if (video == null) {
			video = new FlxVideo();
			video.play('assets/videos/Classic.mp4', true);
			video.alpha = 0;
		}

		bg = new FlxSprite(-80).makeGraphic(1280, 720, FlxColor.BLACK);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...options.length - 1) {
			var optionText:FlxText = new FlxText(0, 0, 0, options[i], 12);
			optionText.setFormat(Paths.font("trajan.ttf"), 18, FlxColor.WHITE, CENTER);
			optionText.screenCenter();
			optionText.y -= FlxG.height / 6;
			optionText.y += 50 * i;
			optionText.antialiasing = ClientPrefs.data.antialiasing;
			optionText.ID = i;
			grpOptions.add(optionText);
		}

		var optionText:FlxText = new FlxText(0, 0, 0, "Back", 12);
		optionText.setFormat(Paths.font("trajan.ttf"), 18, FlxColor.WHITE, CENTER);
		optionText.screenCenter();
		optionText.y -= FlxG.height / 6;
		optionText.y += 50 * 8;
		optionText.ID = 5;
		optionText.antialiasing = ClientPrefs.data.antialiasing;
		grpOptions.add(optionText);

		fleur = new FlxSprite(0, 0);
		fleur.frames = Paths.getSparrowAtlas('Menus/Options/warning-fleur', 'hymns');
		fleur.animation.addByPrefix('idle', "warningfleur", 24, false);
		fleur.animation.play('idle', true);
		add(fleur);
		fleur.antialiasing = ClientPrefs.data.antialiasing;
		fleur.setGraphicSize(Std.int(fleur.width * 0.475));
		fleur.updateHitbox();
		fleur.screenCenter();
		fleur.y -= 200;

		statetext = new FlxText(0, 0, 0, "Options", 12);
		statetext.setFormat(Paths.font("trajan.ttf"), 34, FlxColor.WHITE, CENTER);
		statetext.screenCenter();
		statetext.y = fleur.y - 40;
		statetext.antialiasing = ClientPrefs.data.antialiasing;
		add(statetext);

		pointer1 = new FlxSprite(0, 0);
		pointer1.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer1.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer1.animation.play('idle', true);
		add(pointer1);
		pointer1.antialiasing = ClientPrefs.data.antialiasing;
		pointer1.setGraphicSize(Std.int(pointer1.width * 0.25));
		pointer1.updateHitbox();

		pointer2 = new FlxSprite(0, 0);
		pointer2.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer2.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		//	pointer2.animation.play('idle', true);
		add(pointer2);
		pointer2.antialiasing = ClientPrefs.data.antialiasing;
		pointer2.flipX = true;
		pointer2.setGraphicSize(Std.int(pointer2.width * 0.25));
		pointer2.updateHitbox();

		var spr = grpOptions.members[0];
		pointer1.screenCenter(X);
		pointer1.y = spr.getGraphicMidpoint().y - (spr.height / 2);
		pointer1.x -= (spr.width / 2) + pointer1.width / 1.5;
		// pointer1.animation.play('idle', true);

		pointer2.screenCenter(X);
		pointer2.y = spr.getGraphicMidpoint().y - (spr.height / 2);
		pointer2.x += (spr.width / 2) + pointer1.width / 1.5;
		ClientPrefs.saveSettings();

		changeSelection(0);

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		if (openingsub == false) {
			fleur.animation.play('idle', true, true);
			FlxTween.tween(statetext, {alpha: 0}, .25, {ease: FlxEase.circOut});
			new FlxTimer().start(.35, function(tmr:FlxTimer) {
				statetext.text = "Options";
				statetext.screenCenter(X);
				FlxTween.tween(statetext, {alpha: 1}, .25, {ease: FlxEase.circOut});
				fleur.animation.play('idle', true, false);
				FlxTween.tween(fleur, {alpha: 1}, .25, {ease: FlxEase.circOut});

				ClientPrefs.saveSettings();

				for (spr in grpOptions.members) {
					FlxTween.tween(spr, {alpha: 1}, .25, {ease: FlxEase.circOut});
				}
				FlxTween.tween(pointer1, {alpha: 1}, .25, {ease: FlxEase.circOut});
				FlxTween.tween(pointer2, {alpha: 1}, .25, {ease: FlxEase.circOut});
				changeSelection(0);
			});
		} else {
			openingsub = false;
		}
	}

	public static var selectedsumn:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (video != null) {
			if (video.bitmapData != null) {
				bg.loadGraphic(video.bitmapData);
				bg.setGraphicSize(1280, 720);
				bg.updateHitbox();
				bg.screenCenter();
			}
		}

		statetext.screenCenter(X);
		for (spr in grpOptions.members) {
			spr.screenCenter(X);
		}

		if (FlxG.state == this && subState == null) {
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}

			if (controls.BACK) {
				for (spr in grpOptions.members) {
					FlxTween.tween(spr, {alpha: 0}, .25, {ease: FlxEase.circOut});
				}
				FlxTween.tween(pointer1, {alpha: 0}, .25, {ease: FlxEase.circOut});
				FlxTween.tween(pointer2, {alpha: 0}, .25, {ease: FlxEase.circOut});
				FlxTween.tween(statetext, {alpha: 0}, .25, {ease: FlxEase.circOut});
				fleur.animation.play('idle', true, true);

				new FlxTimer().start(.35, function(tmr:FlxTimer) {
					FlxTween.tween(fleur, {alpha: 0}, .25, {ease: FlxEase.circOut});
					openingsub = true;
					FlxG.sound.play(Paths.sound('cancelMenu'));

					new FlxTimer().start(.5, function(tmr:FlxTimer) {
						video.dispose();
						video = null;
					});

					if (onPlayState) {
						StageData.loadDirectory(PlayState.SONG);
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.sound.music.volume = 0;
					} else {
						if (fromOverworld) {
							LoadingState.loadAndSwitchState(new OverworldManager());
							FlxG.sound.music.volume = 0;
						} else {
							MusicBeatState.switchState(new MainMenuState());
						}
					}
				});
			} else if (controls.ACCEPT)
				openSelectedSubstate(options[curSelected]);
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		pointer1.alpha = 1;
		pointer2.alpha = 1;

		var bullShit:Int = 0;

		for (spr in grpOptions.members) {
			if (spr.ID == curSelected) {
				pointer1.screenCenter(X);
				pointer1.y = spr.getGraphicMidpoint().y - (spr.height / 2);
				pointer1.x -= (spr.width / 2) + pointer1.width / 1.5;
				pointer1.animation.play('idle', true);

				pointer2.screenCenter(X);
				pointer2.y = spr.getGraphicMidpoint().y - (spr.height / 2);
				pointer2.x += (spr.width / 2) + pointer1.width / 1.5;
				pointer2.animation.play('idle', true);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy() {
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}
