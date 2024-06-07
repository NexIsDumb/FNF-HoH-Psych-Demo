package tea.backend.crypto;

import haxe.crypto.BaseCode;
import haxe.io.Bytes;

class Base32 extends BaseCode
{
    public static var CHARS(default, null):String = "0123456789ABCDEFGHIJKLMNOPQRSTUV";

    override public function new()
    {
        super(Bytes.ofString(CHARS));
    }
}