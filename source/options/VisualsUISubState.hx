package options;

import flixel.addons.transition.FlxTransitionableState;

class VisualsUISubState extends BaseOptionsMenu {
	public function new() {
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; // for Discord Rich Presence

		// options

		var noteSkins:Array<String> = Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared');
		if (noteSkins.length > 0) {
			if (!noteSkins.contains(ClientPrefs.data.noteSkin))
				ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin; // Reset to default if saved noteskin couldnt be found

			noteSkins.insert(0, ClientPrefs.defaultData.noteSkin); // Default skin always comes first
			var option:Option = new Option('Note Skins',
				"Select your prefered Note skin.",
				'noteSkin',
				'string',
				noteSkins);
			addOption(option);
		}

		var noteSplashes:Array<String> = Mods.mergeAllTextsNamed('images/noteSplashes/list.txt', 'shared');
		if (noteSplashes.length > 0) {
			if (!noteSplashes.contains(ClientPrefs.data.splashSkin))
				ClientPrefs.data.splashSkin = ClientPrefs.defaultData.splashSkin; // Reset to default if saved splashskin couldnt be found

			noteSplashes.insert(0, ClientPrefs.defaultData.splashSkin); // Default skin always comes first
			var option:Option = new Option('Note Splashes',
				"Select your prefered Note Splash variation or turn it off.",
				'splashSkin',
				'string',
				noteSplashes);
			addOption(option);
		}

		var option:Option = new Option('Note Splash Opacity',
			'How much transparent should the Note Splashes be.',
			'splashAlpha',
			'percent');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool');
		addOption(option);

		/*var option:Option = new Option('Translations',
				"Select your prefered translation of the game.",
				'language',
				'string',
				TM.getLanguages());
			addOption(option);
			option.onChange = onChangeLanguage; */

		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides the FPS Counter.',
			'showFPS',
			'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		#if desktop
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to hide this game from Discord Now Playing.",
			'discordRPC',
			'bool');
		addOption(option);
		#end

		super();

		/*if (OptionsState.restartVisuals != null) {
			changeSelection(OptionsState.restartVisuals);
			OptionsState.restartVisuals = null;
		}*/
	}

	var changedMusic:Bool = false;

	function onChangePauseMusic() {
		if (ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	/*function onChangeLanguage() {
		TM.setTransl();
		ClientPrefs.saveSettings();

		OptionsState.restartVisuals = curSelected;
		FlxTransitionableState.skipNextTransOut = true;
		FlxTransitionableState.skipNextTransIn = true;
		MusicBeatState.resetState();
	}*/
	override function destroy() {
		if (changedMusic && !OptionsState.onPlayState)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter() {
		if (Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end
}
