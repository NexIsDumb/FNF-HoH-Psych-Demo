package shaders;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.system.FlxAssets.FlxShader;
import openfl.Lib;

// PERRY THE PLATYPUS, I PRESENT THE PIXELATOR 3000

class Pixelation extends FlxBasic {
	public var shader(default, null):Pixelator = new Pixelator();

	var iTime:Float = 0;

	public var amt(default, set):Float = 0;

	public function new(amount:Float):Void {
		super();

		amt = amount;
		shader.PIXEL_SIZE.value = [amount];
		shader.iResolution.value = [Lib.current.stage.stageWidth, Lib.current.stage.stageHeight];
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		shader.iResolution.value = [Lib.current.stage.stageWidth, Lib.current.stage.stageHeight];
	}

	function set_amt(v:Float):Float {
		amt = v;
		shader.PIXEL_SIZE.value = [amt];

		trace(v);

		return v;
	}
}

class Pixelator extends FlxShader {
	@:glFragmentSource('
#pragma header

uniform float PIXEL_SIZE;
uniform vec3 iResolution;

void main( ) {
	vec2 uv = openfl_TextureCoordv;

	float plx = 1280.0 * PIXEL_SIZE / 500.0;
	float ply = 720.0 * PIXEL_SIZE / 275.0;

	float dx = plx * (1.0 / 1280.0);
	float dy = ply * (1.0 / 720.0);

	uv.x = dx * floor(uv.x / dx);
	uv.y = dy * floor(uv.y / dy);

	gl_FragColor = texture2D(bitmap, uv);
}
	')
	public function new() {
		super();
	}
}

// noir

class NoirFilter extends FlxBasic {
	public var shader(default, null):BnW = new BnW();

	var iTime:Float = 0;

	public var amt(default, set):Float = 0;

	public function new(amount:Float):Void {
		super();

		amt = amount;
		shader.amount.value = [amount];
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	function set_amt(v:Float):Float {
		amt = v;
		shader.amount.value = [amt];

		return v;
	}
}

class BnW extends FlxShader {
	@:glFragmentSource('
#pragma header

uniform float amount;

void main( )
{
	vec2 pos = openfl_TextureCoordv;
	vec4 texColor = texture2D(bitmap, pos);

	float avg = (texColor.r + texColor.g + texColor.b) / 3.0;
	float rd = avg - texColor.r;
	float gd = avg - texColor.g;
	float bd = avg - texColor.b;
	float dt = amount;

	texColor.r = texColor.r + dt * rd;
	texColor.g = texColor.g + dt * gd;
	texColor.b = texColor.b + dt * bd;

	gl_FragColor = texColor;
}
	')
	public function new() {
		super();
	}
}

class ChromaticAbberation extends FlxBasic {
	public var shader(default, null):CAShader = new CAShader();

	var iTime:Float = 0;

	public var amt(default, set):Float = 0;

	public function new(amount:Float):Void {
		super();

		amt = amount;
		shader.amount.value = [amount];
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	function set_amt(v:Float):Float {
		amt = v;
		shader.amount.value = [amt];

		return v;
	}
}

class CAShader extends FlxShader {
	@:glFragmentSource('
#pragma header

uniform float amount;

void main()
{
	vec2 uv = openfl_TextureCoordv;
	vec2 distFromCenter = uv - 0.5;

	vec2 aberrated = vec2(amount * pow(distFromCenter.x, 3.0), amount * pow(distFromCenter.y, 3.0));

	gl_FragColor = vec4
	(
		texture2D(bitmap, uv - aberrated).r,
		texture2D(bitmap, uv).g,
		texture2D(bitmap, uv + aberrated).b,
		texture2D(bitmap, uv).a
	);
}

	')
	public function new() {
		super();
	}
}

class Bloom extends FlxBasic {
	public var shader(default, null):BloomShader = new BloomShader();

	var iTime:Float = 0;

	public function new():Void {
		super();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}

class BloomShader extends FlxShader {
	@:glFragmentSource('
#pragma header

#define BLOOM_RADIUS 6.14

float luma(vec3 color) {
	return dot(color, vec3(0.299, 0.587, 0.114));
}

void main( )
{
	vec2 uv = openfl_TextureCoordv;
	vec2 scalar = 1.0 / openfl_TextureSize;

	vec3 col = texture2D(bitmap, uv).rgb;

	vec3 left = texture2D(bitmap, uv + vec2(-1.0, 0.0) * scalar * BLOOM_RADIUS).rgb;
	vec3 right = texture2D(bitmap, uv + vec2(1.0, 0.0) * scalar * BLOOM_RADIUS).rgb;
	vec3 up = texture2D(bitmap, uv + vec2(0.0, 1.0) * scalar * BLOOM_RADIUS).rgb;
	vec3 down = texture2D(bitmap, uv + vec2(0.0, -1.0) * scalar * BLOOM_RADIUS).rgb;

	vec3 bloomed = max(left, max(right, max(up, max(down, col))));

	bloomed = (col + bloomed) / 3.0;

	bloomed = (col + (bloomed * luma(bloomed)));

	gl_FragColor = vec4(bloomed, 1.0);
}

')
	public function new() {
		super();
	}
}
