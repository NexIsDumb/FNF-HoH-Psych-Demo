package options;

class GameplaySettingsSubState extends BaseOptionsMenu {
	public function new() {
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; // for Discord Rich Presence

		// I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', // Name
			'If checked, notes go Down instead of Up, simple enough.', // Description
			'downScroll', // Save data variable name
			'bool'); // Variable type
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool');
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys which are not on screen.",
			'ghostTapping',
			'bool');
		addOption(option);

		var option:Option = new Option('Auto Pause',
			"If checked, the game automatically pauses if the screen isn't on focus.",
			'autoPause',
			'bool');
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			'bool');
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Funny notes does "Tick!" when you hit them.',
			'hitsoundVolume',
			'percent');
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for hitting a note earlier or late.',
			'safeFrames',
			'float');
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume() {
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);
	}

	function onChangeAutoPause() {
		FlxG.autoPause = ClientPrefs.data.autoPause;
	}
}
