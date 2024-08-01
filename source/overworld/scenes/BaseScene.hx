package overworld.scenes;

import objects.Character;
import openfl.display.BlendMode;
import backend.ObjectBlendMode;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;
import overworld.*;

typedef StageProperties = {
	var minCam:Float;
	var maxCam:Float;
	var minX:Float;
	var maxX:Float;
	var interactionpoints:Array<Array<Dynamic>>;
}

class BaseScene extends FlxBasic {
	public var stageproperties:StageProperties = {
		minCam: -100,
		maxCam: 100,
		minX: -200,
		maxX: 200,
		interactionpoints: [[100, "elderbuginteract"]]
	};
	public var inshop = false;
	public var slyshop:Bool = false;
	public var exitWalking:Bool = false;

	var game = OverworldManager.instance;
	var controls(get, never):Controls;

	private function get_controls() {
		return Controls.instance;
	}

	public function new() {
		super();
	}

	public function create(?input:String) {}

	public function createPost() {}

	public function variableInitialize() {}

	function add(object:FlxBasic)
		game.add(object);

	function insert(index:Int, object:FlxBasic)
		game.insert(index, object);

	function remove(object:FlxBasic, splice:Bool = false)
		game.remove(object, splice);
}
