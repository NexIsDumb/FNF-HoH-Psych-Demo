package options;

import objects.Character;

class GraphicsSettingsSubState extends BaseOptionsMenu {
	var antialiasingOption:Int;

	public function new() {
		title = 'Graphics';
		rpcTitle = 'Graphics Settings Menu'; // for Discord Rich Presence

		// I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Low Quality', // Name
			'If checked, disables some background details.', // Description
			'lowQuality', // Save data variable name
			'bool'); // Variable type
		addOption(option);

		var option:Option = new Option('Anti-Aliasing',
			'If unchecked, disables anti-aliasing, increasing performance.',
			'antialiasing',
			'bool');
		option.onChange = onChangeAntiAliasing; // Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);
		antialiasingOption = optionsArray.length - 1;

		var option:Option = new Option('Shaders', // Name
			"If unchecked, disables shaders.", // Description
			'shaders',
			'bool');
		addOption(option);

		var option:Option = new Option('GPU Caching', // Name
			"If checked, decreases RAM usage if you have a good GPU.", // Description
			'cacheOnGPU',
			'bool');
		addOption(option);

		super();
	}

	function onChangeAntiAliasing() {
		for (sprite in members) {
			var sprite:FlxSprite = cast sprite;
			if (sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeFramerate() {
		if (ClientPrefs.data.framerate > FlxG.drawFramerate) {
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		} else {
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}
}
