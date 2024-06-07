package backend;

import haxe.macro.Expr;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxBasic;
import openfl.display.BlendMode;
class ObjectBlendMode {
    public static function blendMode(obj:FlxSprite, blend:String) {
       	obj.blend = getBlendFromString(blend);
    }

    public static function getBlendFromString(blend:String):BlendMode {
		switch(blend.toLowerCase()) {
			case 'add': return ADD;
			case 'alpha': return ALPHA;
			case 'darken': return DARKEN;
			case 'difference': return DIFFERENCE;
			case 'erase': return ERASE;
			case 'hardlight': return HARDLIGHT;
			case 'invert': return INVERT;
			case 'layer': return LAYER;
			case 'lighten': return LIGHTEN;
			case 'multiply': return MULTIPLY;
			case 'overlay': return OVERLAY;
			case 'screen': return SCREEN;
			case 'shader': return SHADER;
			case 'subtract': return SUBTRACT;
		}
		return NORMAL;
    }
}