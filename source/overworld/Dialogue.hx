package overworld;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using StringTools;

class Dialogue extends FlxSpriteGroup {
	var box:FlxSprite;
	var arrow:FlxSprite;
	var speakerText:FlxText;
	var alphaset = 0;

	var text:FlxText;
	var scriptpub = [];

	var lineindex = 0;
	var arrowTween:FlxTween;

	var publiccall = [];
	var debounce = false;
	var controls(get, never):Controls;

	private function get_controls() {
		return Controls.instance;
	}

	public function new() {
		super();

		box = new FlxSprite(0, 0);
		box.frames = Paths.getSparrowAtlas('Dialogue/box', 'hymns');
		box.animation.addByPrefix("appear", "box", 24, false);
		box.animation.addByPrefix("disappear", "box", 24, false, true);
		box.antialiasing = ClientPrefs.data.antialiasing;
		box.scale.set(0.8, 0.8);
		box.animation.play("appear");
		box.updateHitbox();
		box.alpha = 0;

		box.centerOffsets();
		box.centerOrigin();

		add(box);

		arrow = new FlxSprite(382.5, 240);
		arrow.frames = Paths.getSparrowAtlas('Dialogue/arrow', 'hymns');
		arrow.animation.addByPrefix("appear", "dialoguearrow0", 24, false);
		arrow.animation.addByPrefix("sappear", "dialoguearrowstop0", 24, false);
		arrow.antialiasing = ClientPrefs.data.antialiasing;
		arrow.animation.play("appear");
		arrow.alpha = 0;
		arrow.scale.set(.85, .85);
		arrow.updateHitbox();
		add(arrow);

		text = new FlxText(70, 50, FlxG.width - 600, 'Hahaha i am elderbug.exe', 28);
		text.setFormat(Constants.HK_FONT, 28, FlxColor.WHITE, LEFT);
		text.antialiasing = ClientPrefs.data.antialiasing;
		text.alpha = 0;
		add(text);
	}

	var curSpeaker:String;

	public function openBox(speaker:String, script, call) {
		if (debounce == false) {
			debounce = true;
			scriptpub = script;
			box.animation.play("appear");
			alphaset = 1;

			publiccall.push(call);

			curSpeaker = speaker;
			speaker = TM.checkTransl(speaker, Paths.formatPath(speaker + "-name"));
			if (speakerText == null) {
				speakerText = new FlxText(-200, FlxG.height - 120, FlxG.width * 2, speaker, 64);
				speakerText.setFormat(Constants.UI_FONT, 58, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				speakerText.borderSize = 2.5;
				speakerText.antialiasing = ClientPrefs.data.antialiasing;
				add(speakerText);
			} else {
				speakerText.text = speaker.toUpperCase();
			}

			speakerText.alpha = 0;
			FlxTween.tween(speakerText, {alpha: 1}, .5, {ease: FlxEase.quintOut});

			/*for (i in 0...script.length - 1) {
				script[i][0] = text.dialog(script[i][0]);
			}*/

			showline(scriptpub[0][0]);
		}
	}

	var arrowsuffix:String = "";
	var publine:String = "";

	function showline(line:String) {
		FlxG.sound.play(Paths.soundRandom(curSpeaker + "_0", 1, 4, 'hymns'));
		arrow.animation.play(arrowsuffix + "appear", true, true);
		if (arrowTween != null) {
			arrowTween.cancel();
			arrowTween = null;
		}
		FlxTween.tween(arrow, {y: 240}, .5, {ease: FlxEase.quintOut});

		if (lineindex == scriptpub.length - 1) {
			arrowsuffix = "s";
		}

		var theoneliner = line;
		publine = theoneliner;

		text.text = "";
		text.alpha = 1;

		trace(theoneliner);

		new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			var linesplit:Array<String> = theoneliner.split('');
			var textywesty:String = linesplit[0];
			new FlxTimer().start(0.025, function(tmr:FlxTimer) {
				textywesty += linesplit[linesplit.length - tmr.loopsLeft - 1];
				text.text = textywesty /*+ text.suffixPub("")*/;
			}, linesplit.length - 1);
		});

		new FlxTimer().start(.35, function(tmr:FlxTimer) {
			arrow.animation.play(arrowsuffix + "appear", true);
			arrow.screenCenterX();
			arrow.alpha = 1;

			if (arrow.animation.curAnim.name == "sappear") {}
		});
	}

	public function closeBox() {
		box.animation.play("appear", true, true);
		arrow.animation.play(arrowsuffix + "appear", true, true);
		alphaset = 0;
		FlxTween.tween(speakerText, {alpha: 0}, .5, {ease: FlxEase.quintOut});
		FlxTween.tween(text, {alpha: 0}, .5, {ease: FlxEase.quintOut});

		new FlxTimer().start(10 * (1 / 24), function(tmr:FlxTimer) {
			arrow.alpha = 0;
		});
		new FlxTimer().start(.6, function(tmr:FlxTimer) {
			debounce = false;
		});

		lineindex = 0;
		publiccall = [];
	}

	override public function update(elapsed:Float) {
		box.update(elapsed);
		arrow.update(elapsed);

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);

		var alphaLerp = FlxMath.lerp(box.alpha, alphaset, lerpVal);

		box.alpha = alphaLerp;

		if (arrow.animation.curAnim.finished && arrow.animation.curAnim.name == arrowsuffix + "appear" && arrow.animation.curAnim.reversed == false) {
			if (arrowTween == null) {
				arrowTween = FlxTween.tween(arrow, {y: arrow.y + 5}, 1, {ease: FlxEase.quadInOut, type: PINGPONG});
			}

			if (controls.ACCEPT && box.alpha >= 0.5) {
				if (text.text == publine) {
					lineindex++;

					publine = "ABSDGJKASGJKhksJAG!!";
					if (lineindex != scriptpub.length) {
						showline(scriptpub[lineindex][0]);
					} else {
						publiccall[0]();
						closeBox();
					}
				} else {
					FlxTimer.globalManager.completeAll();
					text.text = publine;
				}
			}
		}
		if (box.animation.curAnim.reversed == true && box.animation.curAnim.finished) {
			box.alpha = 0;
		}

		if (arrow.animation.curAnim.reversed == true && arrow.animation.curAnim.finished) {
			arrow.alpha = 0;
		}
	}
}
