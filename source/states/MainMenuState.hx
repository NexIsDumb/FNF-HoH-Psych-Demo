package states;

import backend.WeekData;
import backend.Achievements;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import objects.AchievementPopup;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import hxcodec.flixel.*;
import overworld.*;
import flash.system.System;
import backend.Highscore;

#if sys
import sys.thread.Thread;
#end

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.1hymns'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxText>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'Start Game',
		'Options',
		'Credits',
		'Discord',
		'Quit Game'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var video:FlxVideo;
	var bg:FlxSprite;
	var pointer1:FlxSprite;
	var pointer2:FlxSprite;
	
	var caninteract:Bool = true;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		FlxG.save.bind('hymns', CoolUtil.getSavePath());

		FlxG.mouse.visible = false;

		ClientPrefs.loadPrefs();

		Highscore.load();

		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		
		bg = new FlxSprite(-80).makeGraphic(1280, 720, FlxColor.BLACK);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		if(video == null){
			video = new FlxVideo();
			video.play('assets/videos/Classic.mp4', true);
			video.alpha = 0;
		}
		
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;

		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);

		var scale:Float = 1;

		for (i in 0...optionShit.length)
		{
			var optionText:FlxText = new FlxText(0, 0, 0, optionShit[i], 12);
			optionText.setFormat(Paths.font("trajan.ttf"), 22, FlxColor.WHITE, CENTER);
			optionText.text = optionShit[i];
			optionText.screenCenter();
			optionText.y += FlxG.height/10;
			optionText.y += 45 * i;
			optionText.antialiasing = ClientPrefs.data.antialiasing;
			optionText.ID = i;
			menuItems.add(optionText);
		}

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
		pointer2.animation.play('idle', true);
		add(pointer2);
		pointer2.antialiasing = ClientPrefs.data.antialiasing;
		pointer2.flipX = true;
		pointer2.setGraphicSize(Std.int(pointer2.width * 0.25));
		pointer2.updateHitbox();

		//FlxG.camera.follow(camFollow, null, 0);

		versionShit = new FlxText(210, FlxG.height - 24, 0, Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.antialiasing = ClientPrefs.data.antialiasing;
		versionShit.setFormat(Paths.font("trajan.ttf"), 15, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		versionShit.y = menuItems.members[optionShit.length-1].y + 2.5;

		lilgayguy = new FlxSprite(FlxG.width-210, FlxG.height - 217.5).loadGraphic(Paths.image('Menus/Main/lilgayguy', 'hymns'));
		add(lilgayguy);
		lilgayguy.antialiasing = ClientPrefs.data.antialiasing;
		lilgayguy.setGraphicSize(Std.int(lilgayguy.width * 0.23));
		lilgayguy.updateHitbox();
		lilgayguy.x -= lilgayguy.width/2;

		title = new FlxSprite(1088, 0).loadGraphic(Paths.image('Menus/Main/title', 'hymns'));
		title.setGraphicSize(Std.int(title.width * 0.4));
		title.updateHitbox();
		title.screenCenter();
		title.y -= FlxG.height/5;
		add(title);
		title.antialiasing = ClientPrefs.data.antialiasing;

		changeItem();

		super.create();
	}

	var versionShit:FlxText;
	var lilgayguy:FlxSprite;
	var title:FlxSprite;

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if(FlxG.sound.music != null){
			if (FlxG.sound.music.volume < 0.8)
			{
				FlxG.sound.music.volume += 0.5 * elapsed;
				if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
			}
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if(video != null){
			if(video.bitmapData != null){
				bg.loadGraphic(video.bitmapData);
				bg.setGraphicSize(1280,720);
				bg.updateHitbox();
				bg.screenCenter();
			}
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'Discord' || optionShit[curSelected] == 'Quit Game')
				{
					switch(optionShit[curSelected]) { 
						case 'Discord' : 
							CoolUtil.browserLoad('https://discord.gg/hymns');

						case 'Quit Game' :
							System.exit(0);
					}
				}
				else
				{
					selectedSomethin = true;

					for (spr in menuItems.members) {
						FlxTween.tween(spr, {alpha: 0}, .25, {ease: FlxEase.circOut});
					}
					FlxTween.tween(pointer1, {alpha: 0}, .25, {ease: FlxEase.circOut});
					FlxTween.tween(pointer2, {alpha: 0}, .25, {ease: FlxEase.circOut});
					FlxTween.tween(versionShit, {alpha: 0}, .25, {ease: FlxEase.circOut});
					FlxTween.tween(lilgayguy, {alpha: 0}, .25, {ease: FlxEase.circOut});
					FlxTween.tween(title, {alpha: 0}, .25, {ease: FlxEase.circOut});

					FlxG.sound.play(Paths.sound('confirmMenu'));

					new FlxTimer().start(.35, function(tmr:FlxTimer) {
						new FlxTimer().start(.5, function(tmr:FlxTimer) {
							video.dispose();
							video = null;
						});
								
						var daChoice:String = optionShit[curSelected];

						switch (daChoice)
						{
							//case 'Storymode':
								//MusicBeatState.switchState(new OverworldManager());
							case 'Start Game':
								MusicBeatState.switchState(new SaveState());
							case 'Credits':
								MusicBeatState.switchState(new CreditsState());
							case 'Options':
								LoadingState.loadAndSwitchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
								}
						}
					});
				}
			}
			#if desktop
			else if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxText)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxText)
		{
			if (spr.ID == curSelected)
				{
					pointer1.screenCenter(X);
					pointer1.y = spr.getGraphicMidpoint().y - (spr.height/2);
					pointer1.x -= (spr.width/2) + pointer1.width/1.5;
					pointer1.animation.play('idle', true);
		
					pointer2.screenCenter(X);
					pointer2.y = spr.getGraphicMidpoint().y - (spr.height/2);
					pointer2.x += (spr.width/2) + pointer1.width/1.5;
					pointer2.animation.play('idle', true);
				}
		});
	}
}