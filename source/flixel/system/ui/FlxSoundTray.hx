package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flixel.FlxG;
import flixel.system.FlxAssets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * The flixel sound tray, the little volume meter that pops down sometimes.
 * Accessed via `FlxG.game.soundTray` or `FlxG.sound.soundTray`.
 */
class FlxSoundTray extends Sprite
{
	/**
	 * Because reading any data from DisplayObject is insanely expensive in hxcpp, keep track of whether we need to update it or not.
	 */
	public var active:Bool;

	/**
	 * Helps us auto-hide the sound tray after a volume change.
	 */
	var _timer:Float;

	/**
	 * Helps display the volume bars on the sound tray.
	 */
	var _bars:Array<Bitmap>;

	var _bgs:Array<Bitmap>;

	var _curFrame(default, set):Int;

	/**The sound that'll play when you try to increase volume and it's already on the max.**/
	public var volumeMaxSound:String = "assets/hymns/sounds/click_volume_max";

	/**The sound used when increasing the volume.**/
	public var volumeUpSound:String = "assets/hymns/sounds/click_volume_up";

	/**The sound used when decreasing the volume.**/
	public var volumeDownSound:String = "assets/hymns/sounds/click_volume_down";

	/**Whether or not changing the volume should make noise.**/
	public var silent:Bool = false;

	/**
	 * Sets up the "sound tray", the little volume meter that pops down sometimes.
	 */
	@:keep
	public function new()
	{
		super();

		_bgs = new Array();
		var shut = Paths.getSparrowAtlas('Menus/SoundTray/volumebackboard', 'hymns');
		for (frame in shut.frames)
		{
			var newTmp = new Bitmap(frame.paint());
			newTmp.y -= newTmp.height / 4;
			_bgs.push(newTmp);
			addChild(newTmp);
			newTmp.alpha = 0.00001;
		}
		shut.destroy();
		_curFrame = 0;

		_bars = new Array();
		shut = Paths.getSparrowAtlas('Menus/SoundTray/volumebar', 'hymns');
		for (frame in shut.frames)
		{
			var newTmp = new Bitmap(frame.paint());
			newTmp.x = newTmp.width / 1.7;
			if(_bgs[0] != null) newTmp.y = _bgs[0].y + _bgs[0].height / 1.8;
			_bars.push(newTmp);
			addChild(newTmp);
			newTmp.alpha = 0.00001;
		}
		shut.destroy();
		_bars.reverse();

		y = 0;
		visible = false;
		screenCenter();
	}

	/**
	 * This function updates the soundtray object.
	 */
	public function update(MS:Float):Void
	{
		// Animate sound tray thing
		if((_timer -= (MS / 1000)) < 0)
		{
			if (animateBg(MS, -1) <= 0)
			{
				visible = false;
				active = false;

				#if FLX_SAVE
				// Save sound preferences
				if (FlxG.save.isBound)
				{
					FlxG.save.data.mute = FlxG.sound.muted;
					FlxG.save.data.volume = FlxG.sound.volume;
					FlxG.save.flush();
				}
				#end
			}
		}
		else animateBg(MS);
	}

	var _timerAnim:Float = 0;
	var _timerDelay:Float = (1/24)*1000;

	inline function animateBg(elapsed:Float, frameDiff:Int = 1):Int
	{
		// 24 fps
		_timerAnim += elapsed;
		while(_timerAnim >= _timerDelay) {
			_timerAnim -= _timerDelay;
			_curFrame += frameDiff;
		}
		return _curFrame;
	}

	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	up Whether the volume is increasing.
	 */
	public function show(up:Bool = false):Void
	{
		_timer = 1;
		if(!active) _curFrame = 0;
		visible = true;
		active = true;
		var globalVolume:Int = FlxG.sound.muted ? 0 : Math.round(FlxG.sound.volume * 10);

		if (!silent)
		{
			var sound = FlxAssets.getSound(up ? (globalVolume >= _bars.length - 1 && volumeMaxSound != null ? volumeMaxSound : volumeUpSound) : volumeDownSound);
			if (sound != null)
				FlxG.sound.load(sound).play();
		}

		for (i=>frame in _bars)
		{
			frame.alpha = (i == globalVolume) ? 1 : 0.00001;
		}
	}

	public inline function screenCenter():Void
	{
		x = (0.5 * (Lib.current.stage.stageWidth - (_bgs[0] != null ? _bgs[0].width : 0)) - FlxG.game.x);
	}

	function set__curFrame(val:Int)
	{
		_curFrame = Std.int(FlxMath.bound(val, 0, _bgs.length - 1));

		for (i=>frame in _bgs)
		{
			frame.alpha = (i == _curFrame) ? 1 : 0.00001;
		}

		return _curFrame;
	}
}
#end
