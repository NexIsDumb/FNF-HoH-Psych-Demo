/*
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣉⣿⣿⣿⣿⣿⠷⠀⠙⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⢀⣴⣿⣿⣿⣿⣿⣆⠀⠀⢹⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠛⠛⠋⠛⠛⠻⣿⡟⠀⠀⣸⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⡇  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⡇
	⣿⣿⣿⣿⣿⣿⣿⣿⠁⣴⣷⡄⠀⢢⣾⣿⡄⠀⠀⣴⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣷⠀⠻⠟⠀⠀⠘⠿⠟⠀⠀⠀⣿⣿⣿⣿⣿⣿⡇
	⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀  ⢠⣿⣿⣿⣿⣿⣿⡇
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀ ⢀⣠⣿⠿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀ ⠈⢁⣀⣤⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⢀⣬⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⢿⣿⣿⣿⣿⣿⣿⡇
	⣿⠏⢠⣶⠃⠀⣠⠞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣿
	⡟⠀⣿⣿⠀⠀⠁⣀⣤⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣄⣮⢿⣿⣿
	⣷⠀⣿⢃⡀⢰⣿⣿⣿⣆⠀⢹⣶⣄⠀⠀⠀⠀⠀⢄⡀⠀⣈⣡⣾⣿
	⣿⡇⣸⣿⣷⢸⣿⣿⣿⣿⣧⡀⢻⣿⣇⢰⣿⣿⣶⢸⣿⣆⡙⢻⣿
	⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣇⣾⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿
 */

package objects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.geom.Point;
import flixel.util.FlxBitmapDataUtil;
import flixel.system.frontEnds.BitmapFrontEnd;
import lime.graphics.Image;

using StringTools;

class Timebar extends FlxTypedGroup<FlxBasic> {
	var base:FlxSprite;

	var barblack:FlxSprite;

	var thebar:FlxBar;
	var percentagestff:Float = 0;

	public function new(x:Float, y:Float, camera:FlxCamera) {
		super();

		barblack = new FlxSprite(x + 55, y + 45);
		barblack.frames = Paths.getSparrowAtlas('Timer/Time-bar-bb', 'hymns');
		barblack.cameras = [camera];
		barblack.scale.set(0.8, 0.8);
		barblack.updateHitbox();
		barblack.animation.addByPrefix("appear", "time bar backboard enter", 15, false);
		barblack.animation.addByPrefix("temp", "time bar backboard enter", 15, false);
		barblack.animation.play("temp");
		barblack.antialiasing = ClientPrefs.data.antialiasing;
		barblack.alpha = 0;
		add(barblack);

		thebar = new FlxBar(x + 172, y + 46, LEFT_TO_RIGHT, Std.int(barblack.width * 1.225), Std.int(barblack.height * 2), "percentagestff", 0, 1);
		thebar.cameras = [camera];
		thebar.scale.set(0.8, 0.8);
		thebar.updateHitbox();
		thebar.createImageEmptyBar(Paths.image('Timer/empty', 'hymns'), FlxColor.BLUE);
		thebar.createImageFilledBar(Paths.image('Timer/filled', 'hymns'), FlxColor.WHITE);
		thebar.numDivisions = 350;
		thebar.alpha = 0;
		add(thebar);

		base = new FlxSprite(x + 25, y);
		base.frames = Paths.getSparrowAtlas('Timer/Time-bar', 'hymns');
		base.cameras = [camera];
		base.scale.set(0.8, 0.8);
		base.updateHitbox();
		base.animation.addByPrefix("appear", "Time Bar entrance", 15, false);
		base.animation.addByIndices("idle", "Time Bar entrance", [0], "", 15, false);
		base.antialiasing = ClientPrefs.data.antialiasing;
		base.animation.play("idle");
		add(base);

		percentagestff = 0;
		thebar.value = percentagestff;
		thebar.updateBar();
	}

	override public function update(elapsed:Float) {
		base.update(elapsed);
		barblack.update(elapsed);

		if (thebar.alpha == 1) {
			percentagestff = PlayState.songPercent;
			thebar.value = percentagestff;
			thebar.updateBar();
		}
		if (barblack.animation.curAnim.finished && barblack.animation.curAnim.name == "appear") {
			thebar.alpha = 1;
		}
	}

	public function initialize() {
		barblack.animation.play("appear");
		new FlxTimer().start((1 / 15) * 12, function(tmr:FlxTimer) {
			barblack.alpha = 1;
		});
		base.animation.play("appear");
	}
}
/*
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⣻⣿⢻⣿⣿⣿⡏⢻⣿⣿⣿⣿⢻⣿⣇⢸⣿⣿⣿⡇⢸⣿⡛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⡿⠛⠁⣤⣶⣿⣿⣿⠸⣿⣿⣿⡇⠀⢿⣿⣿⣿⠀⣿⣿⡀⢻⣿⣿⡇⢸⣿⡇⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⢋⣴⣾⠀⣿⣿⣿⣿⣿⠀⣿⣿⣿⡇⢀⠘⣿⣿⣿⠀⢸⣿⡧⠀⢻⡿⠀⣾⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⠀⢻⣿⣿⣿⣿⠀⢿⣿⣿⣇⢸⡄⠸⣿⣿⡄⢸⣿⣿⣷⣄⠀⣾⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⡆⢸⣿⣿⣿⣿⡄⢸⣿⣿⣿⠸⣿⡄⠙⣿⡇⢸⣿⣿⣿⣿⠀⢻⣿⣿⡗⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⠇⠘⣿⣿⣿⠀⣿⣿⣆⠈⠃⢸⣿⣿⣿⣿⠀⢸⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣧⣬⣿⣿⣿⣿⣦⣶⣿⣿⣿⣴⣿⣿⣿⣷⣶⣿⣿⣿⣿⣿⣦⣼⣿⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⢉⣭⣤⣤⣤⣬⣍⡙⠛⢿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠹⢿⣿⣿⣿⣿⣿⣿⣷⣄⠙⢿⣿⣿⣿⣿⣿
	⣿⣿⣿⠟⠋⣀⣴⣶⣶⡄⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠗⢂⣉⣿⣿⣿⣿⣿⣿⣿⣷⡈⢻⣿⣿⣿⣿
	⣿⣿⠋⢠⣾⣿⣿⣿⣿⣁⣤⡄⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣈⠛⠻⣿⣿⣿⣿⣿⣿⣷⡀⢻⣿⣿⣿
	⣿⠇⣠⣿⣿⣿⣿⣿⣿⣿⠏⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠸⣿⣿⣿⣿⣿⣿⣇⠘⣿⣿⣿
	⡟⠀⣿⣿⣿⣿⣿⣿⡿⠃⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢠⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿
	⡇⠠⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢛⣻⣿⣿⣿⣿⣿⣿⣿⣤⣌⢿⣿⣿⣿⣿⠟⢀⣾⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿
	⣇⠀⣿⣿⣿⣿⣿⣿⡇⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡿⠟⢋⣉⣭⣤⣶⣶⣶⣤⣬⣉⡙⠛⢋⣁⣴⣿⣿⣿⣿⣿⣿⣿⣿⡏⢠⣿⣿⣿
	⣿⡆⠹⣿⣿⣿⣿⣿⣿⣦⣄⠙⠛⠿⢿⣿⣿⣿⡿⠟⣩⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⢠⣾⣿⣿⣿
	⣿⣿⣄⠹⢿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣦⣤⣤⣶⣿⣿⣿⠿⢿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠉⠙⠻⣿⣿⣿⣿⣿⣿⣿⠟⢉⣴⣿⣿⠿⣋⣽
	⣿⣿⣿⣦⡈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠈⠻⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠈⠻⡈⢻⢛⣉⣤⣶⣿⣿⡟⣡⣾⣿⣿
	⣿⣿⣿⣿⣿⣷⣤⣈⠙⠻⢿⣿⣿⣿⣿⢻⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⢳⠀⣿⣿⣿⣿⣿⣿⣟⠻⢿⣿⣿
	⣿⣿⣿⣯⣉⣛⠿⠿⢿⣶⣶⣶⣶⣶⡏⢸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠿⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⢹⣿⣿⣿⣿⣿⣿⣷⣶⣦⣼
	⣿⣿⣿⣿⣿⣿⣿⣶⡶⢤⣿⣿⣿⣿⡇⢸⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠣⢀⡄⠀⠀⠀⠀⠀⠀⠀⢸⡇⠈⡿⠋⠁⠉⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⠿⠿⢛⣋⣡⣴⣿⣿⣿⣿⣿⣷⠈⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣴⣿⣿⣄⠀⠀⠀⠀⠀⣰⣿⡇⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿
	⣿⣿⣷⣶⣿⣿⣿⣿⣿⣿⠟⠛⠻⠿⢿⡆⠸⣿⣷⣄⡀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⡟⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠈⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⢀⣤⣦⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⣀⣀⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⣠⣾⣿⠃⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠻⣿⣷⣦⣄⡉⠙⠻⠿⠿⣿⣿⣿⠿⠿⠟⠉⣁⣴⣾⣿⣿⣥⣤⣄⠈⢻⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠈⠛⢻⣿⣿⣿⣶⡦⢀⣤⣤⣤⣤⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⣼⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⠀⢾⣿⣿⣿⣿⡏⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠋⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣉⠛⠛⢛⣃⡈⠻⢿⣿⣿⣿⣿⣿⣿⣿⡄⢠⣴⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣬⣉⣙⣉⣉⣤⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
 */
