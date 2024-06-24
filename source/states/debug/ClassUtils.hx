package states.debug;

#if macro
import haxe.macro.Context;
import haxe.macro.TypeTools;
#end

class ClassUtils {
	macro static function build() {
		#if macro
		final thisName:String = 'states.debug.ClassUtils';
		final ignoredClasses = ["flixel.FlxSubState"];
		final dontInclude = [
			"flixel.addons.transition.FlxTransitionableState",
			"flixel.addons.ui.FlxUIState",
			"flixel.system.FlxSplash",
			"flixel.FlxSubState",
			"backend.MusicBeatState",
			"backend.MenuBeatState",
			"states.LoadingState",
			"states.debug.DebugBaseSelect"
		];

		Context.onGenerate(function(types) {
			var names = [];
			var self = TypeTools.getClass(Context.getType(thisName));

			for (t in types)
				switch (t) {
					case TInst(_.get() => c, _):
						var shouldInclude = false;
						var cc = c;
						while (cc.superClass != null) {
							cc = cc.superClass.t.get();
							// trace(cc.module);
							if (ignoredClasses.contains(cc.module))
								break;
							if (cc.module == 'flixel.FlxState' || cc.module == 'states.menus.SubMenu' || cc.module == "states.MusicBeatState")
								shouldInclude = true;
						}
						if (shouldInclude) {
							var name:Array<String> = c.pack.copy();
							name.push(c.name);
							var combinedName = name.join(".");
							if (!dontInclude.contains(combinedName)) {
								// trace(combinedName);
								names.push(Context.makeExpr(combinedName, c.pos));
							}
						}
					default:
				}

			self.meta.remove('classes');
			self.meta.add('classes', names, self.pos);
		});
		return macro cast haxe.rtti.Meta.getType($p{thisName.split('.')});
		#end
	}

	#if !macro
	public static final names:Array<String> = {
		function buildArray() {
			return build().classes;
		}
		buildArray();
	}
	#end
}
