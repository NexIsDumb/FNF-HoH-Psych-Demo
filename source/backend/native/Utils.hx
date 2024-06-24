package backend.native;

class Utils {
	public static function removeLibraryPath(name:String):String {
		var index = name.indexOf(':');
		if (index != -1) {
			return name.substr(index + 1);
		}
		return name;
	}
}
