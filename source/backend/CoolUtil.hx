package backend;

import flixel.util.FlxGradient;
import flixel.util.FlxSave;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;

class CoolUtil {
	inline public static function quantize(f:Float, snap:Float) {
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String> {
		var daList:String = null;
		#if (sys)
		if (FileSystem.exists(path))
			daList = File.getContent(path);
		#end
		if (daList == null && Assets.exists(path))
			daList = Assets.getText(path);
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function colorFromString(color:String):FlxColor {
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if (color.startsWith('0x'))
			color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if (colorNum == null)
			colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String> {
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float {
		if (decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	inline public static function dominantColor(sprite:flixel.FlxSprite):Int {
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth) {
			for (row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0) {
					if (countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for (key in countByColor.keys()) {
			if (countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int> {
		var dumbArray:Array<Int> = [];
		for (i in min...max)
			dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}

	/** Quick Function to Fix Save Files for Flixel 5
		if you are making a mod, you are gonna wanna change "ShadowMario" to something else
		so Base Psych saves won't conflict with yours
		@BeastlyGabi
	**/
	inline public static function getSavePath(folder:String = 'ShadowMario'):String {
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company') + '/' + FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	/**
	 * Modulo that works for negative numbers
	 */
	public static inline function mod(n:Int, m:Int):Int {
		return ((n % m) + m) % m;
	}

	public static function makeGradient(width:Int, height:Int, colors:Array<FlxColor>, chunkSize:UInt = 1, rotation:Int = 90, interpolate:Bool = true):FlxSprite {
		var gradWidth = width;
		var gradHeight = height;
		var gradXScale = 1;
		var gradYScale = 1;

		var modRotation = mod(rotation, 360);

		if (modRotation == 90 || modRotation == 270) {
			gradXScale = width;
			gradWidth = 1;
		}

		if (modRotation == 0 || modRotation == 180) {
			gradYScale = height;
			gradHeight = 1;
		}

		var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(gradWidth, gradHeight, colors, chunkSize, rotation, interpolate);
		gradient.scale.set(gradXScale, gradYScale);
		gradient.updateHitbox();
		return gradient;
	}

	public inline static function getBrightness(value:Float) {
		return Math.round(value * 255) * 0x010101;
	}

	static final labels = "kmgt";

	/**
	 * Returns a string representation of a size, following this format: `1.02 gb`, `134.00 mb`
	 *
	 * Code from Codename Engine, but modified
	 * @param size Size to convert to string
	 * @return String Result string representation
	 */
	public static function getSizeString(size:Float):String {
		var label:Int = 0;
		while (size > 1024 && label < labels.length - 1) {
			label++;
			size /= 1024;
		}
		var fraction = Std.int((size % 1) * 100);
		return '${Std.int(size)}.${lpadZero(Std.string(fraction), 2)} ${labels.charAt(label - 1)}b';
	}

	public static function lpadZero(s:String, l:Int):String {
		var buf = new FastStringBuf();
		l -= s.length;
		while (buf.length < l)
			buf.addStr('0');
		buf.addStr(s);
		return buf.toString();
	}

	public static inline function trimTextStart(text:String, toRemove:String, unsafe:Bool = false):String {
		if (unsafe || text.startsWith(toRemove)) {
			return text.substr(toRemove.length);
		}
		return text;
	}

	public static inline function pushOnce<T>(array:Array<T>, element:T) {
		#if (haxe >= "4.0.0")
		if (!array.contains(element))
			array.push(element);
		#else
		if (array.indexOf(element) == -1)
			array.push(element);
		#end
	}

	public static inline function concatNoDup<T>(array:Array<T>, array2:Array<T>):Array<T> {
		for (element in array2) {
			pushOnce(array, element);
		}
		return array;
	}
}
