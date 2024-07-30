package options;

enum OptionType {
	BOOL;
	INT;
	FLOAT;
	PERCENT;
	STRING;
}

class Option {
	private var child:FlxText;
	private var checkbox:FlxText;
	private var staticText:FlxText;

	public var text(get, set):String;
	public var onChange:Void->Void = null; // Pressed enter (on Bool type options) or pressed/held left/right (on other types)
	public var onSelect:Void->Void = null; // Pressed enter (on Bool type options) or pressed/held left/right (on other types)
	public var onUnselect:Void->Void = null; // Pressed enter (on Bool type options) or pressed/held left/right (on other types)

	public var onSet:(key:String, value:Dynamic) -> Void = null;
	public var onGet:(key:String) -> Dynamic = null;

	public var checkboxVisible:Bool = true;
	public var playSound:Bool = true;

	public var disabled(default, set):Bool = false;

	public var alphaMul:Float = 1;

	public function set_disabled(val:Bool):Bool {
		alphaMul = val ? 0.3 : 1;
		return disabled = val;
	}

	public var id:String = "";

	public var fontColor(default, set):FlxColor = 0xFFFFFF;

	public var type:OptionType = BOOL; // bool, int (or integer), float (or fl), percent, string (or str)

	// Bool will use checkboxes
	// Everything else will use a text
	public var scrollSpeed:Float = 50; // Only works on int/float, defines how fast it scrolls per second while holding left/right

	private var variable:String = null; // Variable from ClientPrefs.hx

	public var defaultValue:Dynamic = null;

	public var curOption:Int = 0; // Don't change this
	public var options:Array<String> = null; // Only used in string type
	public var changeValue:Dynamic = 1; // Only used in int/float/percent type, how much is changed when you PRESS
	public var minValue:Dynamic = null; // Only used in int/float/percent type
	public var maxValue:Dynamic = null; // Only used in int/float/percent type
	public var decimals:Int = 1; // Only used in float/percent type

	public var displayFormat:String = '%v'; // How String/Float/Percent/Int values are shown, %v = Current value, %d = Default value
	public var description:String = '';
	public var name:String = 'Unknown';

	public function new(name:String, description:String = '', variable:String, type:OptionType = BOOL, ?options:Array<String> = null) {
		this.name = name;
		this.description = description;
		this.variable = variable;
		this.type = type;
		this.defaultValue = Reflect.getProperty(ClientPrefs.defaultData, variable);
		this.options = options;

		if (defaultValue == 'null variable value') {
			switch (type) {
				case BOOL: defaultValue = false;
				case INT | FLOAT: defaultValue = 0;
				case PERCENT: defaultValue = 1;
				case STRING:
					defaultValue = '';
					if (options.length > 0) {
						defaultValue = options[0];
					}
			}
		}

		if (getValue() == null) {
			setValue(defaultValue);
		}

		switch (type) {
			case STRING:
				var num:Int = options.indexOf(getValue());
				if (num > -1) {
					curOption = num;
				}

			case PERCENT:
				displayFormat = '%v%';
				changeValue = 0.01;
				minValue = 0;
				maxValue = 1;
				scrollSpeed = 0.5;
				decimals = 2;
			default:
		}
	}

	public function change():Void {
		// nothing lol
		if (onChange != null) {
			onChange();
		}
	}

	public function select():Void {
		// nothing lol
		if (onSelect != null) {
			onSelect();
		}
	}

	public function unselect():Void {
		// nothing lol
		if (onUnselect != null) {
			onUnselect();
		}
	}

	public dynamic function handleVisual(self:Option, value:Dynamic):Void {}

	public function getValue():Dynamic {
		var value:Dynamic = null;
		if (onGet != null) {
			value = onGet(variable);
		} else {
			value = Reflect.getProperty(ClientPrefs.data, variable);
		}
		handleVisual(this, value);
		return value;
	}

	public function setValue(value:Dynamic):Void {
		if (onSet != null) {
			onSet(variable, value);
		} else {
			#if RELEASE_DEBUG
			try {
			#end
				Reflect.setProperty(ClientPrefs.data, variable, value);
			#if RELEASE_DEBUG
			} catch (err) {
				trace('ClientPrefs.data has no field ${variable}, cannot assign ${value}');
				trace(err);
			}
			#end
		}
		handleVisual(this, value);
	}

	public function setChild(child:FlxText):Void {
		this.child = child;
	}

	public function setCheckbox(text:FlxText):Void {
		this.checkbox = text;
		if (checkbox != null) {
			checkbox.visible = checkboxVisible;
			checkbox.color = fontColor;
		}
	}

	public function setStatic(staticText:FlxText):Void {
		this.staticText = staticText;
	}

	private function get_text() {
		if (child != null) {
			return child.text;
		}
		return null;
	}

	private function set_text(newValue:String = '') {
		if (child != null) {
			child.text = newValue;
		}
		return null;
	}

	function set_fontColor(newColor:FlxColor):FlxColor {
		if (staticText != null) {
			staticText.color = newColor;
		}
		if (child != null) {
			child.color = newColor;
		}
		if (checkbox != null) {
			checkbox.color = newColor;
		}
		return fontColor = newColor;
	}
}
