package objects;

// import animateatlas.AtlasFrameMaker;
import flixel.util.FlxSort;
#if MODS_ALLOWED
#end
import openfl.utils.AssetType;
import openfl.utils.Assets;
import backend.Song;
import backend.Section;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
	var idlereturn:Bool;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

class Character extends FlxSprite {
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = Constants.DEFAULT_CHARACTER;

	public var colorTween:FlxTween;
	public var holdTimer:Float = 0;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;
	public var animationNotes:Array<Dynamic> = [];
	public var stunned:Bool = false;
	public var singDuration:Float = 4; // Multiplier of how long a character holds the sing pose
	public var idleSuffix:String = '';
	public var danceIdle:Bool = false; // Character use "danceLeft" and "danceRight" instead of "idle"
	public var skipDance:Bool = false;

	public var healthIcon:String = 'face';
	public var animationsArray:Array<AnimArray> = [];

	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];

	public var hasMissAnimations:Bool = false;

	// Used on Character Editor
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];
	public var idleReturn:Bool = false;

	public function new(x:Float, y:Float, ?character:String = Constants.DEFAULT_CHARACTER, ?isPlayer:Bool = false) {
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		var library:String = null;
		switch (curCharacter) {
			// case 'your character name in case you want to hardcode them instead':

			default:
				var characterPath:String = 'characters/' + curCharacter + '.json';

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getPreloadPath(characterPath);
				}

				if (!FileSystem.exists(path))
				#else
				var path:String = Paths.getPreloadPath(characterPath);
				if (!Assets.exists(path))
				#end
				{
					path = Paths.getPreloadPath('characters/' + Constants.DEFAULT_CHARACTER + '.json'); // If a character couldn't be found, change him to BF just to prevent a crash
				}

				#if MODS_ALLOWED
				var rawJson = File.getContent(path);
				#else
				var rawJson = Assets.getText(path);
				#end

				var json:CharacterFile = cast Json.parse(rawJson);
				/*var useAtlas:Bool = false;

					#if MODS_ALLOWED
					var modAnimToFind:String = Paths.modFolders('images/' + json.image + '/Animation.json');
					var animToFind:String = Paths.getPath('images/' + json.image + '/Animation.json', TEXT);
					if (FileSystem.exists(modAnimToFind) || FileSystem.exists(animToFind) || Assets.exists(animToFind))
					#else
					if (Assets.exists(Paths.getPath('images/' + json.image + '/Animation.json', TEXT)))
					#end
					useAtlas = true; */

				// if (!useAtlas)
				frames = Paths.getAtlas(json.image);
				// else
				//	frames = AtlasFrameMaker.construct(json.image);

				imageFile = json.image;
				if (json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				// positioning
				positionArray = json.position;
				cameraPosition = json.camera_position;

				// data
				healthIcon = json.healthicon;
				singDuration = json.sing_duration;
				flipX = (json.flip_x == true);
				idleReturn = json.idlereturn;
				if (idleReturn != true) {
					idleReturn = false;
				}

				if (json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				// antialiasing
				noAntialiasing = (json.no_antialiasing == true);
				antialiasing = ClientPrefs.data.antialiasing ? !noAntialiasing : false;

				// animations
				animationsArray = json.animations;
				if (animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; // Bruh
						var animIndices:Array<Int> = anim.indices;
						if (animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if (anim.offsets != null && anim.offsets.length > 1) {
							addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
						}
					}
				} else {
					quickAnimAdd('idle', 'BF idle dance');
				}
				// trace('Loaded file to character ' + curCharacter);
		}
		originalFlipX = flipX;

		if (animOffsets.exists('singLEFTmiss') || animOffsets.exists('singDOWNmiss') || animOffsets.exists('singUPmiss') || animOffsets.exists('singRIGHTmiss'))
			hasMissAnimations = true;
		recalculateDanceIdle();
		dance();

		if (isPlayer) {
			flipX = !flipX;
		}

		if (PlayState.instance != null && PlayState.instance.curStage == "shop") {
			flipX = !flipX;
			if (animation.exists('singLEFT') && animation.exists('singRIGHT')) {
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;
			}
			if (animation.exists('singLEFTmiss') && animation.exists('singRIGHTmiss')) {
				var oldMiss = animation.getByName('singRIGHTmiss').frames;
				animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
				animation.getByName('singLEFTmiss').frames = oldMiss;
			}
		}
	}

	override function update(elapsed:Float) {
		if (!debugMode && animation.curAnim != null) {
			if (heyTimer > 0) {
				heyTimer -= elapsed * PlayState.instance.playbackRate;
				if (heyTimer <= 0) {
					if (specialAnim && (animation.curAnim.name == 'hey' || animation.curAnim.name == 'cheer')) {
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			} else if (specialAnim && animation.curAnim.finished) {
				specialAnim = false;
				dance();
			} else if (animation.curAnim.finished && animation.curAnim.name.endsWith('miss')) {
				dance();
				animation.finish();
			}

			if (animation.curAnim.name.startsWith('sing'))
				holdTimer += elapsed;
			else if (isPlayer)
				holdTimer = 0;

			var idleReturnTime = Conductor.stepCrochet * (0.0011 / (FlxG.sound.music != null ? FlxG.sound.music.pitch : 1));
			if (!idleReturn)
				idleReturnTime *= singDuration;

			if (!isPlayer && holdTimer >= idleReturnTime) {
				dance();
				holdTimer = 0;
			}

			if (animation.curAnim.finished && animation.exists(animation.curAnim.name + '-loop'))
				playAnim(animation.curAnim.name + '-loop');
		}
		super.update(elapsed);
	}

	public var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance() {
		if (debugMode || skipDance || specialAnim)
			return;

		if (danceIdle) {
			danced = !danced;

			if (danced)
				playAnim('danceRight');
			else
				playAnim('danceLeft');
		} else if (animation.exists('idle' + idleSuffix)) {
			if (animation.curAnim != null) {
				var animName:String = animation.curAnim.name;
				if (animName != "focusSTART" && animName != "focusLOOP" && animName != "focusIMPACT" && animName != "focusEND") {
					playAnim('idle');
				}
			} else {
				playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
		var animName = AnimName + idleSuffix;

		specialAnim = false;
		animation.play(animName, Force, Reversed, Frame);

		if (animOffsets.exists(animName)) {
			var daOffset = animOffsets.get(animName);
			// if (scale.x <= 0.5) {
			//	switch (animName) {
			//		case "singLEFT": offset.set(-18, -6);
			//		case "singRIGHT": offset.set(14, -2);
			//		case "singUP": offset.set(-9, 21);
			//		case "singDOWN": offset.set(-4, -31);
			//		default: offset.set(daOffset[0], daOffset[1]);
			//	}
			// } else {
			offset.set(daOffset[0], daOffset[1]);
			// }
		} else
			offset.set(0, 0);

		if (curCharacter.startsWith('gf')) {
			switch (animName) {
				case 'singLEFT': danced = true;
				case 'singRIGHT': danced = false;
				case 'singUP' | 'singDOWN': danced = !danced;
			}
		}
	}

	public var danceEveryNumBeats:Int = 2;

	private var settingCharacterUp:Bool = true;

	public function recalculateDanceIdle() {
		danceIdle = (animation.exists('danceLeft' + idleSuffix) && animation.exists('danceRight' + idleSuffix));
		danceEveryNumBeats = (danceIdle ? 1 : 2);
	}

	public inline function addOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets[name] = [x, y];
	}

	public inline function quickAnimAdd(name:String, anim:String) {
		animation.addByPrefix(name, anim, 24, false);
	}
}
