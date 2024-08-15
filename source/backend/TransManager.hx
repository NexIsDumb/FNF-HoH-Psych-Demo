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
	public static var transMap(default, null):Map<String, IFormatInfo> = [];

	/**
	 * The default language used inside of the source code.
	 */
	public static inline var DEFAULT_LANGUAGE:String = 'English';

	/**
	 * The default font used.
	 */
	public static inline var DEFAULT_FONT:String = Constants.UI_FONT_DEFAULT;

	/**
	 * The default font used for the ui.
	 */
	public static inline var DEFAULT_UI_FONT:String = Constants.DIALOGUE_FONT_DEFAULT;

	/**
	 * The font found inside the language's file (CAN BE `null`!!).
	 */
	public static var languageFont:String = null;

	public static var languageFontDialogue:String = null;

	/**
	 * Returns the current font.
	 */
	inline public static function get_curFont():String
		return languageFontDialogue == null ? languageFont == null ? DEFAULT_UI_FONT : languageFont : languageFontDialogue;

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
	 * Formats a normal string into an ID for translations.
	 *
	 * Example: `Resume Song` => `resumeSong`
	 */
	public static function raw2Id(str:String):String {
		var result:String = "";
		for (i => s in str.split(" "))
			result += (i == 0 ? s.charAt(0).toLowerCase() : s.charAt(0).toUpperCase()) + s.substr(1);
		return result.length == 0 ? str : result;
	}

	/**
	 * This is for checking a translation, `defString` it's just the string that gets returned just in case it won't find the translation OR the current language selected is ``DEFAULT_LANGUAGE``.
	 *
	 * If `id` is `null` then it's gonna search using `defString`.
	 */
	public static function checkTransl(defString:String, ?id:String, ?params:Array<Dynamic>):String {
		if (id == null)
			id = defString;

		if (transMap.exists(id))
			return transMap.get(id).format(params);
		return FormatUtil.get(defString).format(params);
	}

	public static function hasTranslation(id:String):Bool {
		return transMap.exists(id);
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
		//var names:Array<String> = ["English","Arabic","Chinese","Czech","Danish","Dutch","Finnish","French","German","Greek","Hebrew","Hindi","Hungarian","Indonesian","Italian","Japanese","Korean","Latin","Norwegian","Persian","Polish","Portuguese","Romanian","Russian","Spanish","Swedish","Thai","Turkish","Ukrainian","Vietnamese","Welsh"];
		/*for (i in languageNames.keys())
			names.push(i);*/
		//trace(names);
		//translations.sort((a, b) -> names.indexOf(a) - names.indexOf(b));
		
		translations.sort((a, b) -> (languageNames.get(a).toUpperCase() < languageNames.get(b).toUpperCase()?-1:1) );
		return translations;
	}

	public static function getLanguages():Array<String> {
		return CoolUtil.concatNoDup([DEFAULT_LANGUAGE], translList());
	}

	public static var languageNames:Map<String, String> = [
		"English" => "English", "Italian" => "Italiano", "French" => "Français", "Spanish" => "Español", "Ukrainian" => "Українська", "Japanese" => "日本語[japan]", "Chinese" => "中文[chi]", "German" => "Deutsch", "Polish" => "Polski", "Indonesian" => "Indonesia", "Finnish" => "Finnish", "Russian" => "Русский", "Turkish" => "Türkçe", "Swedish" => "Svenska", "Norwegian" => "Norsk", "Danish" => "Dansk", "Dutch" => "Nederlands", "Romanian" => "Română", "Portuguese" => "Português", "Welsh" => "Cymraeg", "Hungarian" => "Magyar", "Korean" => "한국어", "Latin" => "Latin", "Greek" => "Ελληνικά", "Vietnamese" => "Tiếng Việt", "Czech" => "Čeština", "Arabic" => "العربية", "Hebrew" => "עברית", "Thai" => "ไทย", "Hindi" => "हिंदी", "Persian" => "فارسی",
	];

	/**
	 * Returns a map of translations based on its xml.
	 */
	public static function loadLanguage(name:String):Map<String, IFormatInfo> {
		if (!Paths.fileExists(name + ".xml", TEXT, false, "translations"))
			return _returnAndNullFont([]);

		var xml = null;
		try {
			xml = new Access(Xml.parse(Paths.getTextFromFile(name + ".xml", false, "translations")));
		} catch (e) {
			var err = 'Error while parsing (${name}) the language\'s xml: ${Std.string(e)}';
			FlxG.log.error(err);
			throw new Exception(err);
		}
		if (xml == null)
			return _returnAndNullFont([]);
		if (!xml.hasNode.translations) {
			FlxG.log.warn("A translation xml file requires a translations root element.");
			return _returnAndNullFont([]);
		}

		var leMap:Map<String, IFormatInfo> = [];
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

					leMap.set(node.att.resolve("id"), FormatUtil.get(node.att.resolve("string")));
			}
		}

		languageFont = transNode.has.font ? transNode.att.resolve("font") : null;
		languageFontDialogue = transNode.has.resolve("font-dialogue") ? transNode.att.resolve("font-dialogue") : null;
		return leMap;
	}

	private static inline function _returnAndNullFont<V>(val:Map<String, V>):Map<String, V> {
		if (val == null || Lambda.count(val) == 0)
			languageFont = null;

		return val;
	}
}

/**
 * The class used to format strings based on parameters.
 *
 * For example if the parameter list is just an `Int` which is `9`, `You have been blue balled {0} times` becomes `You have been blue balled 9 times`.
 * Code from codename-engine
 */
class FormatUtil {
	private static var cache:Map<String, IFormatInfo> = new Map();

	public static function get(id:String):IFormatInfo {
		if (cache.exists(id))
			return cache.get(id);

		var fi:IFormatInfo = ParamFormatInfo.returnOnlyIfValid(id);
		if (fi == null)
			fi = new StrFormatInfo(id);
		cache.set(id, fi);
		return fi;
	}

	public inline static function clear() {
		cache.clear();
	}
}

class StrFormatInfo implements IFormatInfo {
	public var string:String;

	public function new(str:String) {
		this.string = str;
	}

	public function format(params:Array<Dynamic>):String {
		return string;
	}

	public function toString():String {
		return "StrFormatInfo(" + string + ")";
	}
} // TODO: add support for @:({0}==1?(Hello):(World))

class ParamFormatInfo implements IFormatInfo {
	public var strings:Array<String> = [];
	public var indexes:Array<Int> = [];

	public function new(str:String) {
		var i = 0;

		while (i < str.length) {
			var fi = str.indexOf("{", i); // search from the start of i

			if (fi == -1) {
				// if there are no more parameters, just add the rest of the string
				this.strings.push(str.substring(i));
				break;
			}

			var fe = str.indexOf("}", fi);

			this.strings.push(str.substring(i, fi));
			this.indexes.push(Std.parseInt(str.substring(fi + 1, fe)));
			i = fe + 1;
		}
	}

	public static function isValid(str:String):Bool {
		var fi = new ParamFormatInfo(str);
		return fi.indexes.length > 0;
	}

	public static function returnOnlyIfValid(str:String):IFormatInfo {
		var fi = new ParamFormatInfo(str);
		return fi.indexes.length > 0 ? fi : null;
	}

	public function format(params:Array<Dynamic>):String {
		if (params == null)
			params = [];

		var str:String = "";
		for (i => s in strings) {
			str += s;
			if (i < indexes.length)
				str += params[indexes[i]];
		}

		return str;
	}

	public function toString():String {
		return 'ParamFormatInfo([${strings.join(", ")}] [${indexes.join(", ")}])';
	}
}

interface IFormatInfo {
	public function format(params:Array<Dynamic>):String;
}
