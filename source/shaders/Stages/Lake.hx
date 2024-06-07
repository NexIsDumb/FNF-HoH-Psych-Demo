package shaders.stages;

// STOLEN FROM HAXEFLIXEL DEMO LOL
import flixel.system.FlxAssets.FlxShader;
import flixel.FlxBasic;

class FogEffect
{
	public var shader(default, null):FogShader = new FogShader();

	public function new():Void
	{
		shader.iTime.value = [0];
	}

	public function update(elapsed:Float):Void
	{
		shader.iTime.value[0] += elapsed;
	}
}

class FogShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		float cloudDensity = 1; 	// overall density [0,1]
        float noisiness = 0.25; 	// overall strength of the noise effect [0,1]
        float speed = 0.125;			// controls the animation speed [0, 0.1 ish)
        float cloudHeight = 3.5; 	// (inverse) height of the input gradient [0,...)
        uniform float iTime;

        vec3 mod289(vec3 x) {
        return x - floor(x * (1.0 / 289.0)) * 289.0;
        }

        vec4 mod289(vec4 x) {
        return x - floor(x * (1.0 / 289.0)) * 289.0;
        }

        vec4 permute(vec4 x) {
            return mod289(((x*34.0)+1.0)*x);
        }

        vec4 taylorInvSqrt(vec4 r)
        {
        return 1.79284291400159 - 0.85373472095314 * r;
        }

        float snoise(vec3 v)
        { 
        const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
        const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

        // First corner
        vec3 i  = floor(v + dot(v, C.yyy) );
        vec3 x0 =   v - i + dot(i, C.xxx) ;

        // Other corners
        vec3 g = step(x0.yzx, x0.xyz);
        vec3 l = 1.0 - g;
        vec3 i1 = min( g.xyz, l.zxy );
        vec3 i2 = max( g.xyz, l.zxy );

        //   x0 = x0 - 0.0 + 0.0 * C.xxx;
        //   x1 = x0 - i1  + 1.0 * C.xxx;
        //   x2 = x0 - i2  + 2.0 * C.xxx;
        //   x3 = x0 - 1.0 + 3.0 * C.xxx;
        vec3 x1 = x0 - i1 + C.xxx;
        vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
        vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

        // Permutations
        i = mod289(i); 
        vec4 p = permute( permute( permute( 
                    i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
                + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
                + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

        // Gradients: 7x7 points over a square, mapped onto an octahedron.
        // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
        float n_ = 0.142857142857; // 1.0/7.0
        vec3  ns = n_ * D.wyz - D.xzx;

        vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

        vec4 x_ = floor(j * ns.z);
        vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

        vec4 x = x_ *ns.x + ns.yyyy;
        vec4 y = y_ *ns.x + ns.yyyy;
        vec4 h = 1.0 - abs(x) - abs(y);

        vec4 b0 = vec4( x.xy, y.xy );
        vec4 b1 = vec4( x.zw, y.zw );

        //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
        //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
        vec4 s0 = floor(b0)*2.0 + 1.0;
        vec4 s1 = floor(b1)*2.0 + 1.0;
        vec4 sh = -step(h, vec4(0.0));

        vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
        vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

        vec3 p0 = vec3(a0.xy,h.x);
        vec3 p1 = vec3(a0.zw,h.y);
        vec3 p2 = vec3(a1.xy,h.z);
        vec3 p3 = vec3(a1.zw,h.w);

        //Normalise gradients
        vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
        p0 *= norm.x;
        p1 *= norm.y;
        p2 *= norm.z;
        p3 *= norm.w;

        // Mix final noise value
        vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
        m = m * m;
        return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                        dot(p2,x2), dot(p3,x3) ) );
        }

        /// Cloud stuff:
        const float maximum = 1.0/1.0 + 1.0/2.0 + 1.0/3.0 + 1.0/4.0 + 1.0/5.0 + 1.0/6.0 + 1.0/7.0 + 1.0/8.0;
        // Fractal Brownian motion, or something that passes for it anyway: range [-1, 1]
        float fBm(vec3 uv)
        {
            float sum = 0.0;
            for (int i = 0; i < 8; ++i) {
                float f = float(i+1);
                sum += snoise(uv*f) / f;
            }
            return sum / maximum;
        }

        // Simple vertical gradient:
        vec4 gradient(vec2 uv) {
            float x = 1 + length(uv) * cos( atan(uv.y,-uv.x) + .5*.628 ) ;
               //202/255, 250/255, 233/255, 1
           return mix( vec4(0, 0, 0, 0), vec4(202/255, 250/255, 233/255, 1), smoothstep(0.,1.,x) ); 
        }
        vec4 FilterColor(vec4 color1, vec4 color2)
        {
            return 1.0 - (1.0 - color1) * (1.0 - color2);
        }

        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec3 p = vec3(uv, iTime*speed);
            vec3 someRandomOffset = vec3(0.1, 0.3, 0.2);
            vec2 duv = vec2(fBm(p), fBm(p + someRandomOffset)) * noisiness;
            vec4 q = gradient(-uv+duv+1.125) * cloudDensity;
            vec4 bgcolor = texture2D(bitmap, uv);
            //FilterColor(q, bgcolor)
            gl_FragColor = vec4(q);
        }')
	public function new()
	{
		super();
	}
}

class BloomEffect
{
	public var shader(default, null):BloomShader = new BloomShader();

	public function new():Void
	{
		//
	}

	public function update(elapsed:Float):Void
	{
		//
	}
}

class BloomShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
        #define BLOOM_RADIUS 6.14

		float luma(vec3 color) {
		  return dot(color, vec3(0.299, 0.587, 0.114));
		}

		void main( )
		{
			vec2 uv = openfl_TextureCoordv;
			vec2 scalar = 1.0 / vec2(textureSize(bitmap, 0).xy);

			vec3 col = texture2D(bitmap, uv).rgb;
    
			vec3 left = texture2D(bitmap, uv + vec2(-1.0, 0.0) * scalar * BLOOM_RADIUS).rgb;
			vec3 right = texture2D(bitmap, uv + vec2(1.0, 0.0) * scalar * BLOOM_RADIUS).rgb;
			vec3 up = texture2D(bitmap, uv + vec2(0.0, 1.0) * scalar * BLOOM_RADIUS).rgb;
			vec3 down = texture2D(bitmap, uv + vec2(0.0, -1.0) * scalar * BLOOM_RADIUS).rgb;
    
			vec3 bloomed = max(left, max(right, max(up, max(down, col))));
    
			bloomed = (col + bloomed) / 4.0;
    
			bloomed = (col + (bloomed * luma(bloomed)));
    
			gl_FragColor = vec4(bloomed, 1.0);
		}')
	public function new()
	{
		super();
	}
}

class NoirFilter extends FlxBasic
{
	public var shader(default, null):BnW = new BnW();

	var iTime:Float = 0;

	public var amt(default, set):Float = 0;

	public function new(amount:Float):Void{
		super();

		amt = amount;
		shader.amount.value = [amount];
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);
	}

	function set_amt(v:Float):Float{
		amt = v;
		shader.amount.value = [amt];

		return v;
	}
}

class BnW extends FlxShader
{
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

	public function new()
	{
		super();
	}
}