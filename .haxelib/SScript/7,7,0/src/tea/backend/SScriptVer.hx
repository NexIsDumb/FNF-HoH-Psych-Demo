package tea.backend;

import haxe.Http;

using StringTools;

abstract SScriptVer(Null<Int>)
{
    public static var newerVer(default, null):SScriptVer = null;
    public inline function new(num1:Int, num2:Int, num3:Int) 
    {
        this = 0;
        setVer(num1, num2, num3);
    }

    public inline function setVer(num1:Int, num2:Int, num3:Int):Void
    {
        var string:String = "";
        for (i in [num1, num2, num3])
            string += Std.string(i);

        this = Std.parseInt(string);
    }

    public function checkVer():Null<Bool>
    {
        var returnValue:Null<Bool> = null;

        var me:Int = toInt();
        var me2:SScriptVer = fromString(toString());
        var http = new Http('https://raw.githubusercontent.com/TahirKarabekiroglu/SScript/testing/gitVer.txt');
        http.onData = function(data:String)
        {
            me2 = fromString(data);
            if (me < me2.toInt())
            {
                returnValue = false;
                newerVer = me2;
            }
            else 
            {
                returnValue = true;
                newerVer = cast this;
            }
        }
        http.onError = function(msg:String) returnValue = null;

        http.request();
        return returnValue;
    }

    public static function fromString(string:String):SScriptVer
    {
        var nums:Array<Int> = [];

        for (i in string.trim().split('.'))
            nums.push(Std.parseInt(i));

        return new SScriptVer(nums[0], nums[1], nums[2]);
    }

    public inline function toString():String
        return Std.string(this).split('').join('.');

    public inline function toInt():Int
        return this;
}