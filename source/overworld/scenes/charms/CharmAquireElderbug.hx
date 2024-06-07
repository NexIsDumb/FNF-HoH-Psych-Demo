package overworld.scenes.charms;

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

class CharmAquireElderbug extends FlxSpriteGroup
{
    public var call = function() {
    };
    var hasfinished:Bool = false;
    var controls(get, never):Controls;
	private function get_controls()
	{
		return Controls.instance;
	}

    var dissapear = function() {

    };
    
    public function new()
    {
        super();

        var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
        blackShit.alpha = 0;
        add(blackShit);

        var collected = new FlxText(0, 0, FlxG.width * 2, "Collected a Charm");
        collected.setFormat(Paths.font("perpetua.ttf"), 48, FlxColor.WHITE, CENTER);
        collected.antialiasing = ClientPrefs.data.antialiasing;
        collected.screenCenter();
        collected.y -= FlxG.height/3;
        collected.alpha = 0;
        add(collected);

        var flair:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('Overworld/Warning_Fleur0008', 'hymns'));
		flair.antialiasing = ClientPrefs.data.antialiasing;
        flair.y = collected.y + collected.height;
        flair.scale.set(0.4, 0.4);
        flair.updateHitbox();
        flair.screenCenter(X);
        flair.alpha = 0;
		add(flair);

        var charm:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('Overworld/base', 'hymns'));
		charm.antialiasing = ClientPrefs.data.antialiasing;
        charm.scale.set(0.2, 0.2);
        charm.updateHitbox();
        charm.y = flair.y + flair.height - (charm.height/32);
        charm.screenCenter(X);
        charm.x -= charm.width * 1.75;
        charm.alpha = 0;
		add(charm);

        var charmname = new FlxText(0, 0, FlxG.width * 2, "Melodic Shell");
        charmname.setFormat(Paths.font("perpetua.ttf"), 35, FlxColor.WHITE, CENTER);
        charmname.antialiasing = ClientPrefs.data.antialiasing;
        charmname.screenCenter();
        charmname.y = flair.y + flair.height * 1.25;
        charmname.x += 20;
        charmname.alpha = 0;
        add(charmname);

        var desc1 = new FlxText(0, 0, FlxG.width * 2, "Equip a charm to activate its powerful abilities.");
        desc1.setFormat(Paths.font("perpetua.ttf"), 28, FlxColor.WHITE, CENTER);
        desc1.antialiasing = ClientPrefs.data.antialiasing;
        desc1.screenCenter();
        desc1.y = charmname.y + charmname.height * 1.5;
        desc1.alpha = 0;
        add(desc1);

        var bench:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('Overworld/ex', 'hymns'));
		bench.antialiasing = ClientPrefs.data.antialiasing;
        bench.scale.set(0.225, 0.225);
        bench.updateHitbox();
        bench.screenCenter();
        bench.y += 100;
        bench.alpha = 0;
		add(bench);

        var desc2 = new FlxText(0, 0, FlxG.width * 2, "To equip a charm, open the CHARMS menu while resting at a bench.");
        desc2.setFormat(Paths.font("perpetua.ttf"), 27, FlxColor.WHITE, CENTER);
        desc2.antialiasing = ClientPrefs.data.antialiasing;
        desc2.screenCenter();
        desc2.y += 300;
        desc2.alpha = 0;
        add(desc2);

        FlxTween.tween(blackShit, {alpha: .7}, 1.2, {ease: FlxEase.quintOut});
        FlxTween.tween(collected, {alpha: 1}, 1, {ease: FlxEase.quintOut});
        FlxTween.tween(flair, {alpha: 1}, 1, {ease: FlxEase.quintOut});

        FlxTween.tween(charmname, {alpha: 1}, 1, {ease: FlxEase.quintOut});
        FlxTween.tween(charm, {alpha: 1}, 1, {ease: FlxEase.quintOut});

        FlxG.sound.play(Paths.sound('spell_information_screen', 'hymns'));

        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            FlxTween.tween(desc1, {alpha: 1}, 1, {ease: FlxEase.quintOut});
        });

        new FlxTimer().start(2.25, function(tmr:FlxTimer)
        {
            FlxTween.tween(bench, {alpha: 1}, 1, {ease: FlxEase.quintOut});
            FlxTween.tween(desc2, {alpha: 1}, 1, {ease: FlxEase.quintOut});
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                hasfinished = true;
            });
        });

        dissapear = function() {
            FlxTween.tween(blackShit, {alpha: 0}, 1.2, {ease: FlxEase.quintOut});
            FlxTween.tween(collected, {alpha: 0}, 1, {ease: FlxEase.quintOut});
            FlxTween.tween(flair, {alpha: 0}, 1, {ease: FlxEase.quintOut});
    
            FlxTween.tween(charmname, {alpha: 0}, 1, {ease: FlxEase.quintOut});
            FlxTween.tween(charm, {alpha: 0}, 1, {ease: FlxEase.quintOut});
            FlxTween.tween(bench, {alpha: 0}, 1, {ease: FlxEase.quintOut});
            FlxTween.tween(desc2, {alpha: 0}, 1, {ease: FlxEase.quintOut});
            FlxTween.tween(desc1, {alpha: 0}, 1, {ease: FlxEase.quintOut});

            FlxG.sound.music.fadeIn(2, .4, .8);
        }

        FlxG.sound.music.fadeIn(2, .8, .4);
    }

    var hasconfirmed:Bool = false;
    override function update(elapsed:Float)
    {
        if(hasfinished && !hasconfirmed && controls.ACCEPT){
            hasconfirmed = true;
            dissapear();
            call();
        }
    }
}