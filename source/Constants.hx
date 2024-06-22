class Constants {
	public static inline final SOUND_EXT = #if web "mp3" #else "ogg" #end;
	public static inline final VIDEO_EXT = "mp4";

	public static inline final DEFAULT_CHARACTER = 'bf'; // In case a character is missing, it will use BF on its place

	public static var UI_FONT(get, null):String = null;

	private inline static function get_UI_FONT():String {
		if (UI_FONT == null) {
			UI_FONT = Paths.font("trajan.ttf");
		}
		return UI_FONT;
	}

	public static inline final TO_RAD = 0.017453292519943295; // Math.PI / 180;
}
