package backend;

import openfl.utils.Assets as OpenFlAssets;
import haxe.io.Path;
import haxe.xml.Access;
import haxe.Exception;

/**
 * The class used for translations based on the XMLs inside the translations folders.
 *
 * Made by @NexIsDumb originally for the Poldhub mod (THIS PORT HAS NO OVERRIDEABLE TRANSLATED ASSETS AND ALSO WAS SLIGHTLY EDITED!!!).
 */
class TransManager {
	/**
	 * The current language selected translation map; If the current language it's english, this map will be empty.
	 *
	 * Using this class function it'll never be `null`.
	 */
	public static var transMap(default, null):Map<String, String> = [];

	/**
	 * The default language used inside of the source code.
	 */
	public static inline var DEFAULT_LANGUAGE:String = 'English';

	/**
	 * The default font used.
	 */
	public static inline var DEFAULT_FONT:String = 'TrajanPro-Regular.ttf';

	/**
	 * The default font used for the ui.
	 */
	public static inline var DEFAULT_UI_FONT:String = 'perpetua.ttf';

	/**
	 * The font found inside the language's file (CAN BE `null`!!).
	 */
	public static var languageFont:String = null;

	/**
	 * Returns the current font.
	 */
	inline public static function get_curFont():String
		return languageFont == null ? DEFAULT_UI_FONT : languageFont;

	/**
	 * Returns the current ui font.
	 */
	inline public static function get_curUIFont():String
		return languageFont == null ? DEFAULT_FONT : languageFont;

	/**
	 * Returns the current language.
	 */
	inline public static function get_curLanguage():String
		return ClientPrefs.data.language;

	/**
	 * Returns if the current language is the default one (`DEFAULT_LANGUAGE`).
	 */
	inline public static function is_defaultLanguage():Bool
		return ClientPrefs.data.language == DEFAULT_LANGUAGE;

	/**
	 * Returns if any translation is loaded.
	 */
	inline public static function is_anyTransLoaded():Bool
		return Lambda.count(transMap) > 0;

	/**
	 * Changes the translations map.
	 *
	 * If `name` is `null`, it's gonna use the current language.
	 */
	public static function setTransl(?name:String) {
		languageFont = null;
		if (name == null)
			name = get_curLanguage();
		transMap = loadLanguage(name);
	}

	/**
	 * This is for checking a translation, `defString` it's just the string that gets returned just in case it won't find the translation OR the current language selected is ``DEFAULT_LANGUAGE``.
	 *
	 * If `id` is `null` then it's gonna search using `defString`.
	 */
	public static function checkTransl(defString:String, ?id:String):String {
		if (id == null)
			id = defString;
		if (transMap.exists(id))
			return transMap.get(id);
		else
			return defString;
	}

	/**
	 * Returns an array that specifies which translations were found (EMBED ONLY cuz better :) ).
	 */
	public static function translList():Array<String> {
		var translations = [];
		#if !sys
		for (l in OpenFlAssets.list()) {
			var d = Path.directory(l);
			if (d.startsWith(Paths.transMainFolder())) {
				d = (d.replace(Paths.transMainFolder(), "").split("/"))[0];
				if (!translations.contains(d))
					translations.push(d);
			}
		}
		#else
		for (file in FileSystem.readDirectory(Paths.transMainFolder())) {
			var path = new haxe.io.Path(file);
			if (!FileSystem.isDirectory(haxe.io.Path.join([Paths.transMainFolder(), file])) && path.ext == "xml" && !translations.contains(file))
				translations.push(path.file);
		}
		#end
		return translations;
	}

	public static function getLanguages():Array<String> {
		return CoolUtil.concatNoDup([DEFAULT_LANGUAGE], translList());
	}

	public static var languageNames:Map<String, String> = [
		"English" => "English",
		"Italian" => "Italiano",
		"French" => "Français",
		"Spanish" => "Español",
		"Ukrainian" => "Українська[ukr]",
		"Japanese" => "日本語[jap]",
		"Chinese" => "中文[chi]",
		"German" => "Deutsch",
		"Polish" => "Polski",
		"Indonesian" => "Indonesia",
		"Finnish" => "Finnish",
		"Russian" => "Русский[rus]",
		"Turkish" => "Türkçe",
		"Swedish" => "Svenska",
		"Norwegian" => "Norsk",
		"Danish" => "Dansk",
		"Dutch" => "Nederlands",
		"Romanian" => "Română",
		"Portuguese" => "Português",
		"Welsh" => "Cymraeg",
		"Hungarian" => "Magyar",
		"Korean" => "한국어",
		"Latin" => "Latin",
		"Greek" => "Ελληνικά",
		"Vietnamese" => "Tiếng Việt",
		"Czech" => "Čeština",
		"Arabic" => "العربية",
		"Hebrew" => "עברית",
		"Thai" => "ไทย",
		"Hindi" => "हिंदी",
		"Persian" => "فارسی",
	];

	/**
	 * Returns a map of translations based on its xml.
	 */
	public static function loadLanguage(name:String):Map<String, String> {
		if (!Paths.fileExists(name + ".xml", TEXT, false, "translations"))
			return _returnAndNullFont([]);

		var xml = null;
		try {
			xml = new Access(Xml.parse(Paths.getTextFromFile(name + ".xml", false, "translations")));
		} catch (e) {
			var err = 'Error while parsing the language\'s xml: ${Std.string(e)}';
			FlxG.log.error(err);
			throw new Exception(err);
		}
		if (xml == null)
			return _returnAndNullFont([]);
		if (!xml.hasNode.translations) {
			FlxG.log.warn("A translation xml file requires a translations root element.");
			return _returnAndNullFont([]);
		}

		var leMap:Map<String, String> = [];
		var transNode = xml.node.translations;
		for (node in transNode.elements) {
			switch (node.name) {
				case "trans":
					if (!node.has.id) {
						FlxG.log.warn("A translation node requires an ID attribute.");
						continue;
					}
					if (!node.has.string) {
						FlxG.log.warn("A translation node requires a string attribute.");
						continue;
					}

					leMap.set(node.att.resolve("id"), node.att.resolve("string"));
			}
		}

		languageFont = transNode.has.font ? transNode.att.resolve("font") : null;
		return leMap;
	}

	private static inline function _returnAndNullFont(val:Map<String, String>):Map<String, String> {
		if (val == null || Lambda.count(val) == 0)
			languageFont = null;

		return val;
	}
}
