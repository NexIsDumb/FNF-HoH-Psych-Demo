package shaders;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.system.FlxAssets.FlxShader;
import openfl.Lib;

class OverlayFilter extends FlxBasic
{
	public var shader(default, null):Overlay = new Overlay();

	public function new():Void{
		super();
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);
	}
}

class Overlay extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        vec3 overlay(vec3 base, vec3 bl_layer){
            vec3 temp_result;
                if (base.r < 0.5)
                    temp_result.r = 2.0 * base.r * bl_layer.r;
                else
                    temp_result.r = 1.0 - 2.0 * (1.0 - base.r) * (1.0 - bl_layer.r);
                if (base.g < 0.5)
                    temp_result.g = 2.0 * base.g * bl_layer.g;
                else
                    temp_result.g = 1.0 - 2.0 * (1.0 - base.g) * (1.0 - bl_layer.g);
                if (base.b < 0.5)
                    temp_result.b = 2.0 * base.b * bl_layer.b;
                else
                    temp_result.b = 1.0 - 2.0 * (1.0 - base.b) * (1.0 - bl_layer.b);
            return temp_result;
        }
        
        vec4 opacity(float alpha, vec4 texColor, vec4 blendResult){
            return ((1.0 - alpha) * texColor + alpha * blendResult);
        }
        
            
        void main( )
        {
            vec2 uv = openfl_TextureCoordv;
        
            vec4 texColor = texture2D(bitmap, uv);
            vec4 layer = vec4(16./255., 26./255., 90./255., 0.48);
            vec4 blendResult = vec4 (overlay(texColor.rgb, layer.rgb), 1);
            float alpha = 0.6;
        
            gl_FragColor = opacity (alpha, texColor, blendResult);
        }
	')

	public function new()
	{
		super();
	}
}