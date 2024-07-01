package states.savefile;

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
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import flixel.util.FlxBitmapDataUtil;
import flixel.system.frontEnds.BitmapFrontEnd;
import lime.graphics.Image;

using StringTools;

class SaveFile extends FlxTypedGroup<FlxBasic> {
	var flair:FlxSprite;

	public var dirtmouth:FlxSprite;
	public var clearsave:FlxText;
	public var newgame:FlxText;

	public var yes:FlxText;
	public var no:FlxText;

	public var yes2:FlxText;
	public var no2:FlxText;

	var txt:FlxText;

	public var dirtmouthtween:FlxTween;

	public function new(x:Float, y:Float, data:Int) {
		super();

		dirtmouth = new FlxSprite(x + 50, y + 8.5).loadGraphic(Paths.image('Menus/Profile/dirtmouthprofile', 'hymns'));
		dirtmouth.scale.set(0.5, 0.5);
		dirtmouth.updateHitbox();
		dirtmouth.antialiasing = ClientPrefs.data.antialiasing;
		dirtmouth.alpha = 0;
		add(dirtmouth);

		flair = new FlxSprite(x, y);
		flair.frames = Paths.getSparrowAtlas('Menus/Profile/FleurProfile', 'hymns');
		flair.scale.set(0.8, 0.8);
		flair.updateHitbox();
		flair.animation.addByPrefix("appear", "ProfileFleur", 24, false);
		flair.animation.play("appear");
		flair.antialiasing = ClientPrefs.data.antialiasing;
		add(flair);

		txt = new FlxText(x + 40, y + dirtmouth.height / 2.5 + 5, 0, "", 32);
		txt.setFormat(Constants.UI_FONT, 37, FlxColor.WHITE, RIGHT);
		txt.text = Std.string(data) + ".";
		txt.antialiasing = ClientPrefs.data.antialiasing;
		add(txt);

		clearsave = new FlxText(x + flair.width + 120, y + dirtmouth.height / 2.5, 0, "", 32);
		clearsave.setFormat(Constants.UI_FONT, 22, FlxColor.WHITE, RIGHT);
		clearsave.text = TM.checkTransl("Clear Save", "clear-save");
		clearsave.antialiasing = ClientPrefs.data.antialiasing;
		clearsave.alpha = 0;
		clearsave.y += clearsave.height / 4;
		add(clearsave);

		newgame = new FlxText(x + 130, y + dirtmouth.height / 2.5, 0, "", 32);
		newgame.setFormat(Constants.UI_FONT, 22, FlxColor.WHITE, RIGHT);
		newgame.text = TM.checkTransl("New Game", "new-game");
		newgame.antialiasing = ClientPrefs.data.antialiasing;
		newgame.y += newgame.height / 4;
		add(newgame);

		yes = new FlxText(x + 340, y + dirtmouth.height / 2.5, 0, "", 32);
		yes.setFormat(Constants.UI_FONT, 22, FlxColor.WHITE, RIGHT);
		yes.text = "Yes";
		yes.antialiasing = ClientPrefs.data.antialiasing;
		yes.y += yes.height / 4;
		add(yes);

		no = new FlxText(x + 540, y + dirtmouth.height / 2.5, 0, "", 32);
		no.setFormat(Constants.UI_FONT, 22, FlxColor.WHITE, RIGHT);
		no.text = "No";
		no.antialiasing = ClientPrefs.data.antialiasing;
		no.y += no.height / 4;
		add(no);

		no.alpha = 0;
		yes.alpha = 0;

		yes2 = new FlxText(x + 340, y + dirtmouth.height / 2.5, 0, "", 32);
		yes2.setFormat(Constants.UI_FONT, 22, FlxColor.WHITE, RIGHT);
		yes2.text = TM.checkTransl("Story", "story");
		yes2.antialiasing = ClientPrefs.data.antialiasing;
		yes2.y += yes2.height / 4;
		add(yes2);

		no2 = new FlxText(x + 540, y + dirtmouth.height / 2.5, 0, "", 32);
		no2.setFormat(Constants.UI_FONT, 22, FlxColor.WHITE, RIGHT);
		no2.text = "Freeplay";
		no2.antialiasing = ClientPrefs.data.antialiasing;
		no2.y += no2.height / 4;
		add(no2);

		no2.alpha = 0;
		yes2.alpha = 0;

		DataSaver.loadData(data);
		if (DataSaver.played == true) {
			if (dirtmouthtween != null) {
				dirtmouthtween.cancel();
			}
			dirtmouthtween = FlxTween.tween(dirtmouth, {alpha: .75}, 2, {ease: FlxEase.quadInOut});
			newgame.alpha = 0;
			clearsave.alpha = 1;
		}
	}

	public function BEGONETHOT() {
		if (dirtmouthtween != null) {
			dirtmouthtween.cancel();
		}
		dirtmouthtween = FlxTween.tween(dirtmouth, {alpha: 0}, .5, {ease: FlxEase.quadInOut});
		flair.animation.play("appear", true, true);

		FlxTween.tween(newgame, {alpha: 0}, .25, {ease: FlxEase.quadInOut});
		FlxTween.tween(clearsave, {alpha: 0}, .25, {ease: FlxEase.quadInOut});
		FlxTween.tween(no2, {alpha: 0}, .25, {ease: FlxEase.quadInOut});
		FlxTween.tween(yes2, {alpha: 0}, .25, {ease: FlxEase.quadInOut});
		FlxTween.tween(txt, {alpha: 0}, .25, {ease: FlxEase.quadInOut});
	}

	override public function update(elapsed:Float) {
		flair.update(elapsed);
	}
}
