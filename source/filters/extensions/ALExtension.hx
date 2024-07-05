package filters.extensions;

import lime.media.openal.AL;
import lime.media.openal.ALFilter;
import lime._internal.backend.native.NativeCFFI;
import lime.media.openal.ALEffect;

@:access(filters.extensions.NativeCFFIExt)
class ALExtension {
	public static function deleteEffect(cl:Class<AL>, buffer:ALEffect):Void {
		#if (lime_cffi && lime_openal && !macro)
		NativeCFFIExt.lime_al_delete_effect(buffer);
		#end
	}

	public static function deleteFilter(cl:Class<AL>, buffer:ALFilter):Void {
		#if (lime_cffi && lime_openal && !macro)
		NativeCFFIExt.lime_al_delete_filter(buffer);
		#end
	}
}
