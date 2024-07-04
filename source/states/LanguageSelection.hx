package states;

import states.MainMenuState;

class LanguageSelection extends MenuBeatState {
	private var grpOptions:FlxTypedGroup<FlxText>;

	var languages = TM.getLanguages();

	private var curSelected:Int = 0;

	var defaultFont = "TrajanPro-Regular.ttf";

	public static var fromSplash:Bool = false;

	function openSelectedSubstate() {
		for (spr in grpOptions.members) {
			FlxTween.tween(spr, {alpha: 0}, .25, {ease: FlxEase.circOut});
		}
		FlxTween.tween(pointer1, {alpha: 0}, .25, {ease: FlxEase.circOut});
		FlxTween.tween(pointer2, {alpha: 0}, .25, {ease: FlxEase.circOut});
		FlxTween.tween(statetext, {alpha: 0}, .25, {ease: FlxEase.circOut});
		fleur.animation.play('idle', true, true);
		new FlxTimer().start(.35, function(tmr:FlxTimer) {
			// if (label != 'Note Colors' && label != 'Back') {
			//	statetext.text = label;
			//	statetext.screenCenterX();
			//	FlxTween.tween(statetext, {alpha: 1}, .25, {ease: FlxEase.circOut});
			//	fleur.animation.play('idle', true, false);
			// } else {
			FlxTween.tween(fleur, {alpha: 0}, .25, {ease: FlxEase.circOut});
			// }

			ClientPrefs.data.language = languages[curSelected];
			TM.setTransl();
			ClientPrefs.saveSettings();

			new FlxTimer().start(0.35, function(tmr:FlxTimer) {
				if (fromSplash) {
					MusicBeatState.switchState(new MainMenuState());
				} else {
					MusicBeatState.switchState(new options.OptionsState());
				}
			});
		});
	}

	var pointer1:FlxSprite;
	var pointer2:FlxSprite;
	var fleur:FlxSprite;
	var statetext:FlxText;

	var openingsub:Bool = true;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		persistentUpdate = persistentDraw = true;
		selectedsumn = false;

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...languages.length - 1) {
			var lang = languages[i];
			if (TM.languageNames.exists(lang)) {
				lang = TM.languageNames[lang];
			}

			var font = defaultFont;
			var hasFontSuffix = true;
			if (lang.endsWith("[jap]")) {
				font = "asian.otf";
			} else if (lang.endsWith("[chi]")) {
				font = "asian.otf";
			} else if (lang.endsWith("[ukr]")) {
				font = "krka.ttf";
			} else if (lang.endsWith("[rus]")) {
				font = "krka.ttf";
			} else {
				hasFontSuffix = false;
			}
			if (hasFontSuffix) {
				lang = lang.substr(0, lang.length - 5);
			}
			var optionText:FlxText = new FlxText(0, 0, 0, lang, 12);
			optionText.setFormat(Paths.font(font), 18, FlxColor.WHITE, CENTER);
			optionText.screenCenterXY();
			optionText.y -= FlxG.height / 6;
			optionText.y += 50 * i;
			optionText.antialiasing = ClientPrefs.data.antialiasing;
			optionText.ID = i;
			grpOptions.add(optionText);

			if (font == "asian.otf") {
				optionText.offset.y += 6;
			}
		}

		fleur = new FlxSprite(0, 0);
		fleur.frames = Paths.getSparrowAtlas('Menus/Options/warning-fleur', 'hymns');
		fleur.animation.addByPrefix('idle', "warningfleur", 24, false);
		fleur.animation.play('idle', true);
		add(fleur);
		fleur.antialiasing = ClientPrefs.data.antialiasing;
		fleur.setGraphicSize(Std.int(fleur.width * 0.475));
		fleur.updateHitbox();
		fleur.screenCenterXY();
		fleur.y -= 200;

		statetext = new FlxText(0, 0, 0, "Languages", 12);
		statetext.setFormat(Paths.font(defaultFont), 34, FlxColor.WHITE, CENTER);
		statetext.screenCenterXY();
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

		updatePointers(grpOptions.members[0]);

		FlxG.camera.scroll.y = 40;

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		if (openingsub == false) {
			fleur.animation.play('idle', true, true);
			FlxTween.tween(statetext, {alpha: 0}, .25, {ease: FlxEase.circOut});
			new FlxTimer().start(.35, function(tmr:FlxTimer) {
				statetext.text = "Options";
				statetext.screenCenterX();
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

		// var wantedY = curSelected * 20;
		// FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, wantedY, FlxMath.bound(elapsed * 10, 0, 1));

		statetext.screenCenterX();
		for (spr in grpOptions.members) {
			spr.screenCenterX();
		}

		if (FlxG.state == this && subState == null) {
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}

			if (!fromSplash && controls.BACK)
				MusicBeatState.switchState(new options.OptionsState());

			if (controls.ACCEPT)
				openSelectedSubstate();
		}
	}

	function updatePointers(spr:FlxSprite) {
		var pos = spr.getGraphicMidpoint();
		pointer1.screenCenterX();
		pointer1.y = pos.y - (spr.height / 2);
		pointer1.x -= (spr.width / 2) + pointer1.width / 1.5;
		pointer1.animation.play('idle', true);

		pointer2.screenCenterX();
		pointer2.y = pos.y - (spr.height / 2);
		pointer2.x += (spr.width / 2) + pointer1.width / 1.5;
		pointer2.animation.play('idle', true);

		pos.put();
	}

	function changeSelection(change:Int = 0) {
		curSelected = CoolUtil.mod(curSelected + change, grpOptions.length);

		pointer1.alpha = 1;
		pointer2.alpha = 1;

		updatePointers(grpOptions.members[curSelected]);

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy() {
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}
