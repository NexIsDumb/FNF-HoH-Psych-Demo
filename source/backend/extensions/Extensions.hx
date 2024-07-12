package backend.extensions;

import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import flixel.FlxObject;
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

	public static inline function screenCenterXToSprite(spr:FlxObject, Center:FlxObject):FlxObject {
		spr.x = Center.x + (Center.width - spr.width) / 2;

		return spr;
	}

	public static inline function screenCenterYToSprite(spr:FlxObject, Center:FlxObject):FlxObject {
		spr.y = Center.y + (Center.height - spr.height) / 2;

		return spr;
	}

	public static inline function screenCenterXYToSprite(spr:FlxObject, Center:FlxObject):FlxObject {
		spr.x = Center.x + (Center.width - spr.width) / 2;
		spr.y = Center.y + (Center.height - spr.height) / 2;

		return spr;
	}

	public static inline function screenCenterX(spr:FlxObject):FlxObject {
		spr.x = (FlxG.width - spr.width) / 2;

		return spr;
	}

	public static inline function screenCenterY(spr:FlxObject):FlxObject {
		spr.y = (FlxG.height - spr.height) / 2;

		return spr;
	}

	public static inline function screenCenterXY(spr:FlxObject):FlxObject {
		spr.x = (FlxG.width - spr.width) / 2;
		spr.y = (FlxG.height - spr.height) / 2;

		return spr;
	}

	public static function addShader(camera:FlxCamera, shader:FlxShader) {
		if (shader == null || camera == null)
			return null;

		var filter:ShaderFilter = null;
		if (camera.filters == null)
			camera.filters = [];
		camera.filters.push(filter = new ShaderFilter(shader));
		return filter;
	}

	public static function removeShader(camera:FlxCamera, shader:FlxShader):Bool {
		if (camera.filters == null)
			camera.filters = [];
		for (f in camera.filters) {
			if (f is ShaderFilter) {
				var sf = cast(f, ShaderFilter);
				if (sf.shader == shader) {
					camera.filters.remove(f);
					return true;
				}
			}
		}
		return false;
	}
}
