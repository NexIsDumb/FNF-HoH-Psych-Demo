

![TeaLogo](https://i.hizliresim.com/3o2yt2d.png)

# SScript

SScript is an easy to use Haxe script tool that aims to be simple while supporting all Haxe structures.

## Contribution
If you have an issue with SScript or have a suggestion, you can always open an issue here. However, pull requests are NOT welcome and will be ignored.

## Installation
`haxelib install SScript`

Enter this command in command prompt to get the latest release from Haxe library.


`haxelib git SScript https://github.com/TahirKarabekiroglu/SScript.git`

Enter this command in command prompt to get the latest git release from Github. 
Git releases have the latest features but they are unstable and can cause problems.

After installing SScript, don't forget to add it to your Haxe project.

------------

### OpenFL projects
Add this to `Project.xml` to add SScript to your OpenFL project:
```xml
<haxelib name="SScript"/>
```
### Haxe Projects
Add this to `build.hxml` to add SScript to your Haxe build.
```hxml
-lib SScript
```

## Usage
To use SScript, you will need a file or a script. Using a file is recommended.

### Using without a file
```haxe
var script:tea.SScript = {}; // Create a new SScript class
script.doScript("
	function returnRandom():Float
		return Math.random() * 100;
"); // Implement the script
var call = script.call('returnRandom');
var randomNumber:Float = call.returnValue; // Access the returned value with returnValue
```

### Using with a file
```haxe
var script:tea.SScript = new tea.SScript("script.hx"); // Has the same contents with the script above
var randomNumber:Float = script.call('returnRandom').returnValue;
```

## Using Haxe 4.3.0 Syntaxes
SScript supports both `?.` and `??` syntaxes including `??=`.

```haxe
import tea.SScript;
class Main 
{
	static function main()
	{
		var script:SScript = {};
		script.doScript("
			var string:String = null;
			trace(string.length); // Throws an error
			trace(string?.length); // Doesn't throw an error and returns null
			trace(string ?? 'ss'); // Returns 'ss';
			trace(string ??= 'ss'); // Returns 'ss' and assigns it to `string` variable
		");
	}
}
```

## Extending SScript
You can create a class extending SScript to customize it better.
```haxe
class SScriptEx extends tea.SScript
{  
	override function preset():Void
	{
		super.preset();
		
		// Only use 'set', 'setClass' or 'setClassString' in preset
		// Macro classes are not allowed to be set
		setClass(StringTools);
		set('NaN', Math.NaN);
		setClassString('sys.io.File');
	}
}
```
Extend other functions only if you know what you're doing.

## Calling Methods from Tea's
You can call methods and receive their return value from Tea's using `call` function.
It needs one obligatory argument (function name) and one optional argument (function arguments array).

using `call` will return a structure that contains the return value, if calling has been successful, exceptions if it did not, called function name and script file name of the Tea.

Example:
```haxe
var tea:tea.SScript = {};
tea.doScript('
	function method()
	{
		return 2 + 2;
	}
');
var call = tea.call('method');
trace(call.returnValue); // 4

tea.doScript('
	function method()
	{
		var num:Int = 1.1;
		return num;
	}
')

var call = tea.call('method');
trace(call.returnValue, call.exceptions[0]); // null, Float should be Int
```

## Global Variables
With SScript, you can set variables to all running Tea's.
Example:

```haxe
var tea:tea.SScript = {};
tea.set('variable', 1);
tea.doScript('
	function returnVar()
	{
		return variable + variable2;
	}
');

tea.SScript.globalVariables.set('variable2', 2);
trace(tea.call('returnVar').returnValue); // 3
```

## Special Object
Special object is an object that'll get checked if a variable is not found in a Tea.
A special object cannot be a basic type like Int, Float, String, Array and Bool.

Special objects are useful for OpenFL and Flixel states.

Example:
```haxe
import tea.SScript;

class PlayState extends flixel.FlxState 
{
	var sprite:flixel.FlxSprite;
	override function create()
	{
		sprite = new flixel.FlxSprite();

		var newScript:SScript = new SScript();
		newScript.setSpecialObject(this);
		newScript.doScript("sprite.visible = false;");
	}
}
```
