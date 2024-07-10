class Constants {
	public static inline final SOUND_EXT = #if web "mp3" #else "ogg" #end;
	public static inline final VIDEO_EXT = "mp4";

	public static inline final DEFAULT_CHARACTER = 'bf'; // In case a character is missing, it will use BF on its place

	public static inline final GAY = "you";

	public static var GENERIC_FONT(get, null):String = null;

	private inline static function get_GENERIC_FONT():String {
		if (GENERIC_FONT == null) {
			GENERIC_FONT = Paths.font("vcr.ttf");
		}
		return GENERIC_FONT;
	}

	public static var HK_FONT(get, null):String = null;

	private inline static function get_HK_FONT():String {
		var val = Paths.font(TM.get_curFont());
		if (HK_FONT != val)
			HK_FONT = val;
		return HK_FONT;
	}

	public static var UI_FONT(get, null):String = null;
	public static inline final UI_FONT_DEFAULT:String = "TrajanPro3-Regular.ttf";
	public static inline final DIALOGUE_FONT_DEFAULT:String = 'perpetua.ttf';

	private inline static function get_UI_FONT():String {
		var val = Paths.font(TM.get_curUIFont());
		if (UI_FONT != val)
			UI_FONT = val;
		return UI_FONT;
	}

	public static inline final TO_RAD = 0.017453292519943295; // Math.PI / 180;
}
