package states;

import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import objects.AttachedSprite;
import hxcodec.flixel.*;

//flixelighting classes 
//import flixelighting.FlxLight;
//import flixelighting.FlxNormalMap;
//import flixelighting.FlxLighting;


class CreditsState extends MenuBeatState {
	var curSelected:Int = 0;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var descText:FlxText;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	var pointer1:FlxSprite;
	var pointer2:FlxSprite;
	var fleur:FlxSprite;

	var icon:FlxSprite;
	var name:FlxText;
	var role:FlxText;
	var desc:FlxText;

	var namerow:Array<FlxText> = [];

	override function create() {
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled)
			pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [
			// Name -- Icon Name -- Role -- Bio -- Link
			[
				'Cheez',
				'director/cheez',
				'Director/Assistant Animator',
				"y'all lucky i didn't kill myself in the 2 years making this",
				'https://twitter.com/cheezsomething'
			],
			[
				'nld',
				'director/nld',
				'Old Director/Old Coder',
				'i schlipped',
				'https://twitter.com/LocalizedDeku'
			],
			[
				'Avenge',
				'director/avenge',
				'Director/Musician/Charter',
				'this mod sucks',
				'https://twitter.com/howtoavenge101'
			],
			[
				"Nex_isDumb",
				"coder/fushi",
				"New Coder/Italian Translator",
				"*sanity has left the gc*",
				"https://linktr.ee/just_nex"
			],
			[
				"Ne_Eo",
				"coder/neeo",
				"New Coder",
				"*What a tasty gpu you have :3*",
				"https://niirou.se/socials/ne_eo"
			],
			[
				"WinnWhatify",
				"coder/winnwhatify",
				"New Coder",
				"L a m p",
				"https://www.youtube.com/@whatify9636"
			],
			[
				"NateTDOM",
				"artist/nate",
				"Artist/Animator",
				"hi i did some sprites they are all pretty old now",
				"https://twitter.com/nathanwvg"
			],
			[
				"Matiaz",
				"artist/matiaz",
				"Artist/Animator/Portoguese Translator",
				"i made bf sprites follow me on twitter",
				"https://twitter.com/MatiazAnimates"
			],
			[
				"Merritz",
				"artist/merritz",
				"Artist/Animator",
				"No, Cheez, I will not work on Hollows Eve",
				"https://twitter.com/Not_Merritz"
			],
			[
				"ThatN003",
				"artist/N003",
				"Artist/Animator",
				"What are we some kind of Hymns of Hallownest?",
				"https://twitter.com/ThatN003"
			],
			[
				"Zial",
				"artist/zial",
				"Artist/Animator",
				"No im not obsessed with robots",
				"https://twitter.com/hollow_ant"
			],
			[
				"Bisha",
				"artist/abi",
				"Artist/Animator/Indonesian Translator",
				"Listen to Luhvee on spotify,,,",
				"https://x.com/Bishaboosha"
			],
			[
				"Favhri",
				"artist/favhri",
				"Artist/Indonesian Translator",
				"If they talk behind yo back, then fart",
				"https://x.com/Favhri_idk"
			],
			[
				"R_RedJK7",
				"artist/red",
				"Artist",
				"tell your mother i said hi",
				"https://twitter.com/rredjk7"
			],
			["FDW", "artist/FDW", "Icon Art", "fdw", "https://twitter.com/FireyFlamingKid"],
			[
				"DemoAsh",
				"artist/demo",
				"Concept Artist",
				"WHY IS MY PIZZA BLA-",
				"https://twitter.com/DemoAsh_"
			],
			[
				"Bluenebula",
				"musician/bluenebula",
				"Composer",
				"what the fuck is this bullshit",
				"https://tbluenebula.carrd.co"
			],
			[
				"Zomboi",
				"musician/zomboi",
				"Music Production",
				"FL is bloatware",
				"https://twitter.com/_Zombeats"
			],
			[
				"UnderCastle",
				"charter/undertale",
				"Charter/French Translator",
				"go play Skullgirls 2nd Encore",
				"https://twitter.com/Under_castle777"
			],
			["Dest", "charter/dest", "Charter", "only in ohio", "https://x.com/DoingleDoing"],
			[
				"Frostics",
				"charter/fro",
				"Charter",
				"fiminin fickle 5",
				"https://youtu.be/W70Q1R-inLc"
			],
			[
				"HeroBrenn",
				"writer/herobrenn",
				"Concept Artist/Writer",
				"Cheez said he'd kill me if I didn't change my quote to something else",
				"https://twitter.com/HeroBrenn"
			],
			[
				"Keith",
				"translator/keith",
				"Italian Translator",
				"am I silly enough to start eating rocks",
				"https://x.com/SillyCatKeith?t=H-AAkd4cz80jSK486rwvDA&s=09"
			],
			[
				"Lars",
				"translator/lars",
				"Turkish Translator",
				"I killed a man for milkshake, I'd do it again. =)",
				"https://www.youtube.com/channel/UChX4tgFrN_sxCbk1PdW-LxQ"
			],
			[
				"FlipDesert",
				"translator/flipdesert",
				"German Translator",
				"Blows up mod with mind...",
				"https://flips-homepage.carrd.co/"
			],
			[
				"Nosk.Xml",
				"translator/nosk",
				"German Translator",
				"Somehow I made it here with grammar skills of a insect",
				"https://x.com/nosk_artist"
			],
			[
				"Jeom",
				"translator/jeom",
				"Finnish Translator",
				"Sup I'm dumb af",
				"https://jeom.carrd.co/"
			],
			[
				"Bipty",
				"translator/bitpy",
				"Polish Translator",
				"idfk",
				"https://0xbitpy.github.io/"
			],
			[
				"Grassyblocky",
				"translator/are u fucking serious",
				"Chinese Translator",
				"Mom I'm on TV but i can't finish my homework",
				"https://space.bilibili.com/332069165"
			],
			[
				"Buddy_a",
				"translator/buddy_a",
				"Ukrainian Translator",
				"I have no socials so uuuuh play Project: Afternight",
				"https://www.roblox.com/games/13042495892/Project-Afternight"
			],
			[
				"Snakeguy",
				"translator/snakeguy",
				"Russian Translator",
				"I just love Hollow Knight",
				"https://www.youtube.com/channel/UCRxRBVC9ztuAIm2pvFOTWHA"
			],
			[
				"Sakuroll",
				"translator/saku",
				"Russian Translator",
				"Hey, Emelya on the stove here, this mod is 42 out of 42 guys",
				"https://x.com/Sakuroll_"
			],
			[
				"Penkaru",
				"special thanks/penkaru",
				"Special Thanks",
				"hello penkaru.",
				"https://www.youtube.com/@thedudepenkaru"
			],
			[
				"Simply",
				"special thanks/simplysaphoore",
				"Special Thanks",
				"father of vbf. we love you vbf dad",
				"https://x.com/SimplySaph00re"
			],
			["Dom", "special thanks/dom", "Special Thanks", "dom we miss you", null]
		];

		for (i in defaultList) {
			creditsStuff.push(i);
		}

		name = new FlxText(0, 0, 1180, creditsStuff[0][0], 32);
		name.setFormat(Constants.HK_FONT, 64, FlxColor.WHITE, CENTER);
		name.scrollFactor.set();
		name.screenCenterXY();
		name.y += 130;
		name.antialiasing = ClientPrefs.data.antialiasing;
		add(name);

		role = new FlxText(0, 0, 1180, creditsStuff[0][2], 32);
		role.setFormat(Constants.HK_FONT, 32, FlxColor.WHITE, CENTER);
		role.scrollFactor.set();
		role.screenCenterXY();
		role.y += 175;
		role.antialiasing = ClientPrefs.data.antialiasing;
		add(role);

		desc = new FlxText(0, 0, 1180, '"' + creditsStuff[0][3] + '"', 32);
		desc.setFormat(Constants.HK_FONT, 28, FlxColor.WHITE, CENTER);
		desc.scrollFactor.set();
		desc.screenCenterXY();
		desc.y += 220;
		desc.antialiasing = ClientPrefs.data.antialiasing;
		add(desc);

		icon = new FlxSprite(0, 0).loadGraphic(Paths.image('Credits/' + creditsStuff[0][1], 'hymns'));
		icon.scale.set(0.2, 0.2);
		icon.updateHitbox();
		icon.screenCenterXY();
		icon.y -= 150;
		add(icon);
		icon.antialiasing = ClientPrefs.data.antialiasing;

		fleur = new FlxSprite(0, 0);
		fleur.frames = Paths.getSparrowAtlas('Menus/Options/warning-fleur', 'hymns');
		fleur.animation.addByPrefix('idle', "warningfleur", 24, false);
		fleur.animation.play('idle', true);
		add(fleur);
		fleur.antialiasing = ClientPrefs.data.antialiasing;
		fleur.setGraphicSize(Std.int(fleur.width * 0.525));
		fleur.updateHitbox();
		fleur.screenCenterXY();
		fleur.y += 75;

		var main:FlxText = new FlxText(0, 0, 1180, 'Cheez', 32);
		main.setFormat(Constants.HK_FONT, 42, FlxColor.WHITE, CENTER);
		main.scrollFactor.set();
		main.screenCenterXY();
		main.y += 300;
		main.antialiasing = ClientPrefs.data.antialiasing;
		add(main);

		var one:FlxText = new FlxText(0, 0, 1180, 'Avenge', 32);
		one.setFormat(Constants.HK_FONT, 28, FlxColor.WHITE, CENTER);
		one.scrollFactor.set();
		one.screenCenterXY();
		one.y += 300;
		one.x -= 150;
		one.alpha = 0.5;
		one.antialiasing = ClientPrefs.data.antialiasing;
		add(one);

		var two:FlxText = new FlxText(0, 0, 1180, 'nld', 32);
		two.setFormat(Constants.HK_FONT, 28, FlxColor.WHITE, CENTER);
		two.scrollFactor.set();
		two.screenCenterXY();
		two.y += 300;
		two.x += 150;
		two.alpha = 0.5;
		two.antialiasing = ClientPrefs.data.antialiasing;
		add(two);

		namerow.push(two);
		namerow.push(main);
		namerow.push(one);

		pointer1 = new FlxSprite(0, 0);
		pointer1.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer1.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		add(pointer1);
		pointer1.antialiasing = ClientPrefs.data.antialiasing;
		pointer1.setGraphicSize(Std.int(pointer1.width * 0.3));
		pointer1.updateHitbox();

		pointer2 = new FlxSprite(0, 0);
		pointer2.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer2.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		add(pointer2);
		pointer2.antialiasing = ClientPrefs.data.antialiasing;
		pointer2.flipX = true;
		pointer2.setGraphicSize(Std.int(pointer2.width * 0.3));
		pointer2.updateHitbox();

		// 1
		pointer1.screenCenterXY();
		pointer1.y += 300;
		pointer1.x -= 250;
		pointer1.animation.play("idle");
		// 2
		pointer2.screenCenterXY();
		pointer2.y += 300;
		pointer2.x += 250;
		pointer2.animation.play("idle");

		changeSelection();

		ClientPrefs.saveSettings();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	var gayState:Int = 0;
	var gayStateTimer:Float = 0;

	var glitch:GlitchShader = {
		var glitch = new GlitchShader();
		glitch.amount.value = [0.5];
		glitch.speed.value = [0.6];
		glitch;
	}


	
	var lastCrunch = "";
	//var lampActive = false;
	//var myLighting:FlxLighting;
	//var lampLight:FlxLight;

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.7) {
			FlxG.sound.music.volume += 0.5 * elapsed;
		}

		if (!quitting) {
			if (creditsStuff.length > 1) {
				var shiftMult:Int = 1;
				if (FlxG.keys.pressed.SHIFT)
					shiftMult = 3;

				var upP = controls.UI_LEFT_P;
				var downP = controls.UI_RIGHT_P;

				if (upP) {
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP) {
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if (controls.UI_RIGHT || controls.UI_LEFT) {
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0) {
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if (creditsStuff[curSelected][0] == "Ne_Eo") {
				gayStateTimer += elapsed;
				if (gayStateTimer > ((gayState > 3) ? 5 : 3)) {
					gayStateTimer = 0;
					gayState++;
					function breakBuild() {
						FlxG.sound.play(Paths.sound('crunch'), 0.4);
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
							if (creditsStuff[curSelected][0] == "Ne_Eo") { // incase the user changed the selection
								var crunch = "";
								if (gayState == 1) {
									crunch = "*crunch*";
								} else if (gayState == 2) {
									crunch = "*crunch crunch*";
								} else if (gayState == 3) {
									crunch = "*crunch* yum";
								} else {
									var arr = [
										"*crunch*",
										"*crunch crunch*",
										"*crunch* yum",
										"*crunch crunch crunch*",
										"*crunch* tasty"
									];
									if (arr.contains(lastCrunch)) {
										arr.remove(lastCrunch);
									}
									crunch = FlxG.random.getObject(arr);
								}

								desc.text = crunch;
								lastCrunch = crunch;

								FlxG.camera.shake(0.005, 0.1);
								FlxG.camera.setFilters([new ShaderFilter(glitch)]);
								new FlxTimer().start(0.2, function(tmr:FlxTimer) {
									FlxG.camera.setFilters([]);
								});
							}
						});
					}
					switch (gayState) {
						case 1:
							glitch.uTime.value = [4.1];
							breakBuild();
						case 2:
							glitch.uTime.value = [13.6];
							breakBuild();
						case 3:
							glitch.uTime.value = [69.69];
							breakBuild();
						default:
							glitch.uTime.value = [FlxG.random.float(0, 5000)];
							breakBuild();
					}
					// changeSelection(0, false);
				}
			} 
			
			
			/*
			if (creditsStuff[curSelected][0] == "WinnWhatify") {
				
				if(!lampActive){
					
					lampActive = true;
					
					//Setting up the FlxLighting object (this does all of the lighting calculations)
					myLighting = new FlxLighting();
					//Setting a custom ambient light color and intensity
					myLighting.setAmbient(0x181d3a, 1.0);

					//Creating an FlxLight object to illuminate the scene with
					lampLight = new FlxLight(250, 130, 0.04, 1.0, 0xec9523);

					//Creating a FlxNormalMap that holds a normal map bitmap corresponding to the previously created sprite
					var myNormalMap:FlxNormalMap = new FlxNormalMap(0, 0, Paths.imageDry("Credits/coder/winnNormalMap", 'hymns'));
					
					//Adding the FlxLight object to the FlxLighting object
					myLighting.addLight(lampLight);

					//Adding the FlxNormalMap object to the FlxLighting object
					//Note: only one FlxNormalMap can be added. Calling this method again will override the previous FlxNormalMap
					myLighting.addNormalMap(myNormalMap);
				}
				if(lampLight!=null && myLighting!=null && myLighting.getFilter()!=null){
					//icon.filter = myLighting.getFilter();
					lampLight.x = FlxG.mouse.x;
					lampLight.y = FlxG.mouse.y;
					myLighting.update();
				}
				
				
			}
			else if(lampActive){
				lampActive = false;
				//icon.filter = null;
				myLighting = null;
				lampLight = null;
			}
			*/

			if (controls.ACCEPT && (creditsStuff[curSelected][4] == null || creditsStuff[curSelected][4].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][4]);
			}
			if (controls.BACK) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;

	function changeSelection(change:Int = 0, playSound:Bool = true) {
		if (playSound) {
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		do {
			curSelected = CoolUtil.mod(curSelected + change, creditsStuff.length);
		} while (unselectableCheck(curSelected));

		gayState = 0;
		gayStateTimer = 0;

		name.text = creditsStuff[curSelected][0];
		role.text = creditsStuff[curSelected][2];
		desc.text = '"' + creditsStuff[curSelected][3] + '"';

		icon.loadGraphic(Paths.image('Credits/' + creditsStuff[curSelected][1], 'hymns'));
		icon.scale.set(0.2, 0.2);
		icon.updateHitbox();
		icon.screenCenterXY();
		icon.y -= 150;
		icon.antialiasing = ClientPrefs.data.antialiasing;

		if (change > 0) {
			pointer2.animation.play("idle");
		} else {
			pointer1.animation.play("idle");
		}

		for (i in 0...namerow.length) {
			var names = namerow[i];
			var thecur = curSelected - (i - 1);
			if (thecur < 0)
				thecur = creditsStuff.length - 1;
			if (thecur >= creditsStuff.length)
				thecur = 0;

			names.text = creditsStuff[thecur][0];

			if(names.text=="WinnWhatify"){
				names.text ="Winn";
			}
			/*
				if(creditsStuff[thecur][0].endsWith("[chinese]")){
					names.setFormat(Paths.font("chinese.otf"), 21, FlxColor.WHITE, CENTER);
					names.text = creditsStuff[thecur][0].replace("[chinese]", "");
					if(thecur == curSelected){
						names.setFormat(Paths.font("chinese.otf"), 36, FlxColor.WHITE, CENTER);
						name.setFormat(Paths.font("chinese.otf"), 52, FlxColor.WHITE, CENTER);
						name.text = creditsStuff[thecur][0].replace("[chinese]", "");
					}
				}else{
					if(names.font != "Riven"){
						names.setFormat(Constants.HK_FONT, 28, FlxColor.WHITE, CENTER);
						if(thecur == curSelected){
							name.setFormat(Constants.HK_FONT, 64, FlxColor.WHITE, CENTER);
							names.setFormat(Constants.HK_FONT, 42, FlxColor.WHITE, CENTER);
						}
					}else{
						if(name.size != 64 && thecur == curSelected){
							name.setFormat(Constants.HK_FONT, 64, FlxColor.WHITE, CENTER);
						}
					}
				}
			 */

			names.screenCenterX();
			if (i == 0) {
				names.x += 150;
			} else {
				if (i == 2) {
					names.x -= 150;
				}
			}
		}
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String) {
		var creditsFile:String = null;
		if (folder != null && folder.trim().length > 0)
			creditsFile = Paths.mods(folder + '/data/credits.txt');
		else
			creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile)) {
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for (i in firstarray) {
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if (arr.length >= 5)
					arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}

class GlitchShader extends FlxShader {
	@:glFragmentSource('
#pragma header

uniform float uTime;

uniform float amount; //0 - 1 glitch amount
uniform float speed; //0 - 1 speed

//2D (returns 0 - 1)
float random2d(vec2 n) {
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float randomRange (in vec2 seed, in float min, in float max) {
	return min + random2d(seed) * (max - min);
}

// return 1 if v inside 1d range
float insideRange(float v, float bottom, float top) {
	return step(bottom, v) - step(top, v);
}

void main()
{
	float time = floor(uTime * speed * 60.0);
	vec2 uv = openfl_TextureCoordv;

	//copy orig
	vec4 outCol = texture2D(bitmap, uv);

	//randomly offset slices horizontally
	float maxOffset = amount/2.0;
	for (float i = 0.0; i < 10.0 * amount; i += 1.0) {
		float sliceY = random2d(vec2(time, 2345.0 + float(i)));
		float sliceH = random2d(vec2(time, 9035.0 + float(i))) * 0.25;
		float hOffset = randomRange(vec2(time, 9625.0 + float(i)), -maxOffset, maxOffset);
		vec2 uvOff = uv;
		uvOff.x += hOffset;
		if (insideRange(uv.y, sliceY, fract(sliceY+sliceH)) == 1.0){
			outCol = texture2D(bitmap, uvOff);
		}
	}

	//do slight offset on one entire channel
	float maxColOffset = amount/6.0;
	float rnd = random2d(vec2(time, 9545.0));
	vec2 colOffset = vec2(randomRange(vec2(time, 9545.0), -maxColOffset, maxColOffset), randomRange(vec2(time, 7205.0), -maxColOffset, maxColOffset));
	if (rnd < 0.33){
		outCol.r = texture2D(bitmap, uv + colOffset).r;
	}else if (rnd < 0.66){
		outCol.g = texture2D(bitmap, uv + colOffset).g;
	}else{
		outCol.b = texture2D(bitmap, uv + colOffset).b;
	}
	// outCol.a = texture2D(bitmap, uv + colOffset).a;

	gl_FragColor = outCol;
}
')
	public function new() {
		super();

		resetParams();
	}

	public function resetParams() {
		this.uTime.value = [0.0];
		this.amount.value = [0.0];
		this.speed.value = [0.6];
	}
}