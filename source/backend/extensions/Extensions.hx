package backend.extensions;

import flixel.graphics.FlxGraphic;

class Extensions {
	/*
	 * Returns `v` if not null
	 * @param v The value
	 * @return A bool value
	 */
	public static inline function isNotNull<T>(v:Null<T>):Bool {
		return v != null && !isNaN(v);
	}

	/*
	 * Returns `v` if not null, `defaultValue` otherwise.
	 * @param v The value
	 * @param defaultValue The default value
	 * @return The return value
	 */
	public static inline function getDefault<T>(v:Null<T>, defaultValue:T):T {
		return (v == null || isNaN(v)) ? defaultValue : v;
	}

	public static function isNull<T>(value:T):Bool {
		return !isNotNull(value);
	}

	/**
	 * Whenever a value is NaN or not.
	 * @param v Value
	 */
	public static inline function isNaN(v:Dynamic) {
		if (v is Float || v is Int)
			return Math.isNaN(cast(v, Float));
		return false;
	}

	/**
	 * Returns the first element of an Array
	 * @param array Array
	 * @return T Last element
	 */
	public static inline function first<T>(array:Array<T>):T {
		return array[0];
	}

	/**
	 * Returns the last element of an Array
	 * @param array Array
	 * @return T Last element
	 */
	public static inline function last<T>(array:Array<T>):T {
		return array[array.length - 1];
	}

	public static function makeSolid(sprite:FlxSprite, Width:Int, Height:Int, Color:FlxColor = FlxColor.WHITE, Unique:Bool = false, ?Key:String):FlxSprite {
		var graph:FlxGraphic = FlxG.bitmap.create(1, 1, Color, Unique, Key);
		sprite.frames = graph.imageFrame;
		sprite.scale.set(Width, Height);
		sprite.updateHitbox();
		return sprite;
	}

	public static function makeSolid2(sprite:FlxSprite, Width:Int, Height:Int, Color:FlxColor = FlxColor.WHITE, Unique:Bool = false, ?Key:String):FlxSprite {
		var graph:FlxGraphic = FlxG.bitmap.create(2, 2, Color, Unique, Key);
		sprite.frames = graph.imageFrame;
		sprite.scale.set(Width / 2, Height / 2);
		sprite.updateHitbox();
		return sprite;
	}
}
