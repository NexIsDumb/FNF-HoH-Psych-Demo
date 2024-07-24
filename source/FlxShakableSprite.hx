import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxAngle;


class FlxShakableSprite extends FlxSprite
{
    public var shakeDistance: Float = 0;
    public var extraAngle(default, set): Float = 0;
    public var shakeDelay: Float = 1 / 60;
    private var shakeTimer: Float = 0;

    private var shakeOffset: FlxPoint = new FlxPoint();

    override function update(elapsed: Float): Void
    {
        super.update(elapsed);
        if (shakeDistance != 0)
        {
            shakeTimer += elapsed;
            while (shakeTimer >= shakeDelay)
            {
                shakeTimer -= shakeDelay;
                shakeOffset.x = FlxG.random.float(-shakeDistance, shakeDistance);
                shakeOffset.y = FlxG.random.float(-shakeDistance, shakeDistance);
            }
        }
    }

    @:noCompletion
    override function drawComplex(camera: FlxCamera): Void
    {
        _frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
        _matrix.translate(-origin.x, -origin.y);
        _matrix.scale(scale.x, scale.y);

        if (bakedRotationAngle <= 0)
        {
            updateTrigExtra();

            if (angle != 0 || extraAngle != 0)
            {
                _matrix.rotateWithTrig(_cosAngle, _sinAngle);
            }
        }

        _point.add(origin.x, origin.y);
        _matrix.translate(_point.x, _point.y);
        if (shakeDistance != 0)
        {
            _matrix.translate(shakeOffset.x, shakeOffset.y);
        }

        if (isPixelPerfectRender(camera))
        {
            _matrix.tx = Math.floor(_matrix.tx);
            _matrix.ty = Math.floor(_matrix.ty);
        }

        camera.drawPixels(_frame, framePixels, _matrix, colorTransform, blend, antialiasing, shader);
    }

    @:noCompletion
    inline function updateTrigExtra(): Void
    {
        if (_angleChanged)
        {
            var radians: Float = (angle + extraAngle) * FlxAngle.TO_RAD;
            _sinAngle = Math.sin(radians);
            _cosAngle = Math.cos(radians);
            _angleChanged = false;
        }
    }

    @:noCompletion
    function set_extraAngle(Value: Float): Float
    {
        var newAngle = (extraAngle != Value);
        var ret = extraAngle = Value;
        if (newAngle)
        {
            _angleChanged = true;
            // animation.update(0);
        }
        return ret;
    }
}