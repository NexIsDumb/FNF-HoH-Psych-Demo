package states.debug;

import states.debug.ClassUtils;
import haxe.io.Path;
import lime.ui.KeyModifier;
import lime.ui.KeyCode;

using StringTools;

class DebugStateSelect extends DebugBaseSelect {
	var allStates:Array<String> = [];

	override function create() {
		allStates = ClassUtils.names;
		super.create();
	}

	override function getVisualName(name:String):String {
		if (name.startsWith("states."))
			return name.substr("states.".length);
		return name;
	}

	override function generateBaseItems() {
		itemsTxt = generateItems(allStates);
	}

	override function acceptSelection() {
		var item = itemsTxt[curSelected];
		var stateName = item.buttonText;
		trace('Selected ' + stateName);
		var cls = Type.resolveClass(stateName);
		if (cls != null) {
			var state = Type.createEmptyInstance(cls);
			if (state is MusicBeatState) {
				LoadingState.loadAndSwitchState(Type.createInstance(cls, []));
				exiting = true;
			} else {
				showMessage('No state found for ' + stateName, 1);
			}
		} else {
			showMessage('No state found for ' + stateName, 1);
		}
	}

	override function back() {}
}
