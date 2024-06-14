package flash.security;

@:native("flash.security.ReferencesValidationSetting")
#if (haxe_ver >= 4.0) extern enum #else @:extern @:enum #end abstract ReferencesValidationSetting(String)
{
	var NEVER = "never";
	var VALID_IDENTITY = "validIdentity";
	var VALID_OR_UNKNOWN_IDENTITY = "validOrUnknownIdentity";
}
