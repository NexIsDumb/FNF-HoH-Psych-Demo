package flash.media;

@:native("flash.media.CameraPosition")
#if (haxe_ver >= 4.0) extern enum #else @:extern @:enum #end abstract CameraPosition(String)
{
	var BACK = "back";
	var FRONT = "front";
	var UNKNOWN = "unknown";
}
