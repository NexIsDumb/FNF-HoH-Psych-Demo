package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end
#if openfl
import openfl.system.System;
#end
#if cpp
import cpp.vm.Gc;
#end

interface IDebugInfo {
	#if debug
	public function getDebugInfo():String;
	#end
}

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField {
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000) {
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "hps: ?";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e) {
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	public static inline function currentMemUsage():Float {
		#if cpp
		return Gc.memInfo64(Gc.MEM_INFO_USAGE);
		#else
		return System.totalMemory;
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void {
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000) {
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.data.framerate)
			currentFPS = ClientPrefs.data.framerate;

		// if (currentCount != cacheCount /*&& visible*/) {
		var buf = new backend.FastStringBuf();
		buf.addStr("hps: ");
		buf.add(currentFPS);
		var memoryMegas:Float = 0.0;

		#if debug
		memoryMegas = currentMemUsage();
		buf.addStr(" | mem: " + CoolUtil.getSizeString(memoryMegas));
		#end

		textColor = 0xFFFFFFFF;
		if (memoryMegas / 1024.0 > 3000 * 1024 || currentFPS <= ClientPrefs.data.framerate / 2) {
			textColor = 0xFFFF0000;
		}

		#if (gl_stats && !disable_cffi && (!html5 || !canvas))
		buf.addStr(" | totalDC: ");
		buf.add(Context3DStats.totalDrawCalls());
		buf.addStr(" | stageDC: ");
		buf.add(Context3DStats.contextDrawCalls(DrawCallContext.STAGE));
		buf.addStr(" | stage3DDC: ");
		buf.add(Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D));
		#end

		#if debug
		var debugState:IDebugInfo = null;
		var state = FlxG.state;
		if (state is IDebugInfo) {
			debugState = cast(state, IDebugInfo);
		}

		if (debugState != null) {
			var infos = debugState.getDebugInfo();
			if (infos != null && infos.length > 0) {
				buf.addStr(" | " + infos);
			}
		}
		#end

		buf.addStr("\n");
		var newText = buf.toString();
		if (text != newText) {
			text = newText;
		}
		// }

		cacheCount = currentCount;
	}
}
