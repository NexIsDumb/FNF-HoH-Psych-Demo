/*
 * Copyright (C)2005-2019 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package backend;

#if cpp
import cpp.NativeString;

using cpp.NativeArray;

/*
 * FastStringBuf is a string buffer but that doesnt automatically flush
 */
class FastStringBuf {
	private var b:Array<String>;

	/**
		The length of `this` StringBuf in characters.
	**/
	public var length(get, never):Int;

	var charBuf:Array<cpp.Char>;

	public function new():Void {
		b = [];
		charBuf = new Array<cpp.Char>();
	}

	private function charBufAsString():String {
		var len = charBuf.length;
		charBuf.push(0);
		return NativeString.fromGcPointer(charBuf.address(0), len);
	}

	public function flush():Void {
		if (charBuf.length > 0)
			b.push(charBufAsString());
		charBuf = new Array<cpp.Char>();
	}

	public inline function flushAndClear():Void {
		if (charBuf.length > 0)
			b.push(charBufAsString());
		charBuf = null;
	}

	@:pure function get_length():Int {
		var len = (charBuf == null) ? 0 : charBuf.length;
		for (s in b)
			len += s == null ? 4 : s.length;
		return len;
	}

	public inline function addStr(x:String):Void {
		b.push(x);
	}

	public inline function add<T>(x:T):Void {
		b.push(Std.string(x));
	}

	public #if !cppia inline #end function addSub(s:String, pos:Int, ?len:Int):Void {
		b.push(s.substr(pos, len));
	}

	public #if !cppia inline #end function addChar(c:Int):Void {
		charBuf.push(c);
	}

	public function toString():String {
		flushAndClear();
		if (b.length == 0)
			return "";
		if (b.length == 1)
			return b[0];
		return b.join("");
	}
}
#else
class FastStringBuf {
	var b:String;

	public var length(get, never):Int;

	public inline function new() {
		b = "";
	}

	@:pure inline function get_length():Int {
		return b.length;
	}

	@:pure public inline function flush():Void {}

	public inline function addStr(x:String):Void {
		b += x;
	}

	public inline function add<T>(x:T):Void {
		b += x;
	}

	public inline function addChar(c:Int):Void {
		b += String.fromCharCode(c);
	}

	public inline function addSub(s:String, pos:Int, ?len:Int):Void {
		b += (len == null ? s.substr(pos) : s.substr(pos, len));
	}

	@:pure public inline function toString():String {
		return b;
	}
}
#end
