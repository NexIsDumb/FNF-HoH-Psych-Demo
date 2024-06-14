package flash.desktop;

@:native("flash.desktop.NativeDragActions")
#if (haxe_ver >= 4.0) extern enum #else @:extern @:enum #end abstract NativeDragActions(String)
{
	var COPY = "copy";
	var LINK = "link";
	var MOVE = "move";
	var NONE = "none";
}
