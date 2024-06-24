package states;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import objects.AttachedSprite;
import hxcodec.flixel.*;

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
				"Favhri",
				"artist/favhri",
				"Artist/Translator",
				"If they talk behind yo back, then fart",
				"https://x.com/Favhri_idk"
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
				"Artist/Animator",
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
				"Nex_isDumb",
				"translator/fushi",
				"New Coder/Translator",
				"le goofy (I swear I'll optimize everything in codename engine in the full release:pray:)",
				"https://linktr.ee/just_nex"
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
				"https://www.youtube.com/channel/UCL9ridOdtqFNzQ_kPjb_Vog"
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
				"Charter",
				"Hey guys I finished charting christmas ballad like not even an hour before it got released, this mod team is always on time!!",
				"https://twitter.com/Under_castle777"
			],
			[
				"Dest",
				"charter/dest",
				"Charter",
				"only in ohio",
				"https://twitter.com/DesttBruh"
			],
			[
				"HeroBrenn",
				"writer/herobrenn",
				"Concept Artist/Writer",
				"Cheez said he'd kill me if I didn't change my quote to something else",
				"https://twitter.com/HeroBrenn"
			],
			[
				"Nosk.Xml",
				"translator/nosk",
				"Translator",
				"Somehow I made it here with grammar skills of a insect",
				"https://x.com/nosk_artist"
			],
			[
				"Chloe",
				"translator/chloe",
				"Translator",
				"God, do you see the radiant light? Do you hear the beautiful chant? Do you feel the tender warmth...? Nothing here - Pitch black - Pure white - All the same",
				"https://enderpuff.github.io/"
			],
			[
				"中空[chi]",
				"translator/hollow",
				"Translator",
				"Translating was the easy part,\nwaiting was what was hard.",
				"https://twitter.com/HollowTheProto"
			],
			[
				"Keith",
				"translator/keith",
				"Translator",
				"am I silly enough to start eating rocks",
				"https://x.com/SillyCatKeith?t=H-AAkd4cz80jSK486rwvDA&s=09"
			],
			[
				"FlipDesert",
				"translator/flipdesert",
				"Translator",
				"Blows up mod with mind...",
				"https://flips-homepage.carrd.co/"
			],
			[
				"Snakeguy",
				"translator/snakeguy",
				"Translator",
				"I just love Hollow Knight",
				"https://www.youtube.com/channel/UCRxRBVC9ztuAIm2pvFOTWHA"
			],
		];

		for (i in defaultList) {
			creditsStuff.push(i);
		}

		name = new FlxText(0, 0, 1180, creditsStuff[0][0], 32);
		name.setFormat(Paths.font("perpetua.ttf"), 64, FlxColor.WHITE, CENTER);
		name.scrollFactor.set();
		name.screenCenter();
		name.y += 130;
		name.antialiasing = ClientPrefs.data.antialiasing;
		add(name);

		role = new FlxText(0, 0, 1180, creditsStuff[0][2], 32);
		role.setFormat(Paths.font("perpetua.ttf"), 32, FlxColor.WHITE, CENTER);
		role.scrollFactor.set();
		role.screenCenter();
		role.y += 175;
		role.antialiasing = ClientPrefs.data.antialiasing;
		add(role);

		desc = new FlxText(0, 0, 1180, '"' + creditsStuff[0][3] + '"', 32);
		desc.setFormat(Paths.font("perpetua.ttf"), 28, FlxColor.WHITE, CENTER);
		desc.scrollFactor.set();
		desc.screenCenter();
		desc.y += 220;
		desc.antialiasing = ClientPrefs.data.antialiasing;
		add(desc);

		icon = new FlxSprite(0, 0).loadGraphic(Paths.image('Credits/' + creditsStuff[0][1], 'hymns'));
		icon.scale.set(0.2, 0.2);
		icon.updateHitbox();
		icon.screenCenter();
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
		fleur.screenCenter();
		fleur.y += 75;

		var main:FlxText = new FlxText(0, 0, 1180, 'Cheez', 32);
		main.setFormat(Paths.font("perpetua.ttf"), 42, FlxColor.WHITE, CENTER);
		main.scrollFactor.set();
		main.screenCenter();
		main.y += 300;
		main.antialiasing = ClientPrefs.data.antialiasing;
		add(main);

		var one:FlxText = new FlxText(0, 0, 1180, 'Avenge', 32);
		one.setFormat(Paths.font("perpetua.ttf"), 28, FlxColor.WHITE, CENTER);
		one.scrollFactor.set();
		one.screenCenter();
		one.y += 300;
		one.x -= 150;
		one.alpha = 0.5;
		one.antialiasing = ClientPrefs.data.antialiasing;
		add(one);

		var two:FlxText = new FlxText(0, 0, 1180, 'nld', 32);
		two.setFormat(Paths.font("perpetua.ttf"), 28, FlxColor.WHITE, CENTER);
		two.scrollFactor.set();
		two.screenCenter();
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
		pointer1.screenCenter();
		pointer1.y += 300;
		pointer1.x -= 250;
		pointer1.animation.play("idle");
		// 2
		pointer2.screenCenter();
		pointer2.y += 300;
		pointer2.x += 250;
		pointer2.animation.play("idle");

		changeSelection();

		ClientPrefs.saveSettings();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.7) {
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
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

	function changeSelection(change:Int = 0) {
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while (unselectableCheck(curSelected));

		name.text = creditsStuff[curSelected][0];
		role.text = creditsStuff[curSelected][2];
		desc.text = '"' + creditsStuff[curSelected][3] + '"';

		icon.loadGraphic(Paths.image('Credits/' + creditsStuff[curSelected][1], 'hymns'));
		icon.scale.set(0.2, 0.2);
		icon.updateHitbox();
		icon.screenCenter();
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
						names.setFormat(Paths.font("perpetua.ttf"), 28, FlxColor.WHITE, CENTER);
						if(thecur == curSelected){
							name.setFormat(Paths.font("perpetua.ttf"), 64, FlxColor.WHITE, CENTER);
							names.setFormat(Paths.font("perpetua.ttf"), 42, FlxColor.WHITE, CENTER);
						}
					}else{
						if(name.size != 64 && thecur == curSelected){
							name.setFormat(Paths.font("perpetua.ttf"), 64, FlxColor.WHITE, CENTER);
						}
					}
				}
			 */

			names.screenCenter(X);
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
