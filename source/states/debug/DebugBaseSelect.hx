package states.debug;

import flixel.addons.transition.FlxTransitionableState;
import haxe.io.Path;
import lime.ui.KeyModifier;
import lime.ui.KeyCode;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import flixel.FlxG;
import flixel.text.FlxText;
import sys.FileSystem;

using StringTools;

class ButtonText extends FlxText {
	public var PX:Int;
	public var PY:Int;
	public var SID:Int;

	public var visualName:String = "";
	public var buttonText:String = "";

	public var node:MapNode;
}

class MapNode {
	public var left:MapNode;
	public var right:MapNode;
	public var up:MapNode;
	public var down:MapNode;

	public var text:ButtonText;
	public var SID:Int;

	public function new(text:ButtonText) {
		this.text = text;
		SID = text.SID;
	}
}

class DebugBaseSelect extends MusicBeatState {
	var itemsTxt:Array<ButtonText> = [];
	var searchTxt:FlxText;

	function generateItems(arr:Array<String>):Array<ButtonText> {
		for (txt in this.itemsTxt) {
			remove(txt, true);
			txt.destroy();
		}

		var itemsTxt:Array<ButtonText> = [];
		for (i => item in arr) {
			var visualName = getVisualName(item);
			var text = new ButtonText(0, 0, 0, visualName);
			text.setFormat(Constants.GENERIC_FONT, 16, -1, "left");
			add(text);
			text.ID = i;
			text.SID = i;
			itemsTxt.push(text);

			text.visualName = visualName;
			text.buttonText = item;

			text.node = new MapNode(text);
		}
		return itemsTxt;
	}

	function getVisualName(name:String):String {
		return name;
	}

	override function create() {
		generateBaseItems();

		searchTxt = new FlxText(0, 10, FlxG.width, "");
		searchTxt.setFormat(Constants.GENERIC_FONT, 16, -1, "center");
		searchTxt.screenCenterX();
		add(searchTxt);

		super.create();

		FlxG.stage.window.onKeyDown.add(onKeyDown);
		// FlxG.stage.window.onKeyUp.add(onKeyUp);
		FlxG.stage.window.onTextInput.add(onTextInput);
		FlxG.stage.window.onTextEdit.add(onTextEdit);

		updatePosAndNodes();
	}

	function generateBaseItems() {
		itemsTxt = generateItems(["Please Extend this menu"]);
	}

	override function destroy() {
		FlxG.stage.window.onKeyDown.remove(onKeyDown);
		// FlxG.stage.window.onKeyUp.remove(onKeyUp);
		FlxG.stage.window.onTextInput.remove(onTextInput);
		FlxG.stage.window.onTextEdit.remove(onTextEdit);

		super.destroy();
	}

	var searchText:String = "";

	public function onKeyDown(e:KeyCode, modifier:KeyModifier):Void {
		if (e == BACKSPACE) {
			if (searchText.length > 0) {
				var holdingCtrl = #if mac modifier.metaKey #else modifier.ctrlKey #end;

				if (holdingCtrl) {
					searchText = "";
				} else {
					searchText = searchText.substr(0, searchText.length - 1);
				}
				updateSearch();
			}
		}
	}

	public function onTextInput(text:String):Void {
		searchText += text;
		updateSearch();
	}

	// untested, but this should be a fix for if the text wont type
	public function onTextEdit(text:String, start:Int, end:Int):Void {
		searchText += text;
		updateSearch();
	}

	function updateSearch() {
		var aa = [];
		var allItems = itemsTxt.copy();

		var lowerSearchText = searchText.toLowerCase();

		for (i => item in itemsTxt) {
			if (item.visualName.toLowerCase().startsWith(lowerSearchText)) {
				aa.push(item);
			}
		}
		for (a in aa)
			allItems.remove(a);
		for (i => item in allItems) {
			if (item.visualName.toLowerCase().indexOf(lowerSearchText) != -1) {
				aa.push(item);
			}
		}
		for (a in aa)
			allItems.remove(a);

		var idx = 0;
		for (a in aa)
			a.ID = idx++;
		for (a in allItems)
			a.ID = idx++;

		var searchLength = searchText.length;
		var force = aa.length == 0;
		var first = null;
		var items = aa.concat(allItems);

		searchTxt.text = searchText;

		for (item in items) {
			var name = item.visualName;
			var idx = name.toLowerCase().indexOf(lowerSearchText);
			if (idx != -1 && searchText.length > 0) {
				name = name.substr(0, idx) + "$" + name.substr(idx, searchLength) + "$" + name.substr(idx + searchLength);
			}
			item.visible = force || idx != -1;
			item.applyMarkup(name, [new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00FF00), "$")]);
			if (item.visible && first == null)
				first = item;
		}

		if (!itemsTxt[curSelected].visible) {
			curSelected = first.SID;
		}

		updatePosAndNodes();
	}

	var curSelected:Int = 0;

	function updatePosAndNodes() {
		final MARGIN_LEFT = 50;
		final MARGIN_TOP = 50;

		var maxWidth:Float = 0;
		var curX:Float = MARGIN_LEFT;
		var curY:Float = MARGIN_TOP;
		var idX = 0;
		var idY = 0;
		var grid:Array<Array<MapNode>> = [];
		for (item in itemsTxt) {
			// reset
			item.node.left = item.node;
			item.node.right = item.node;
			item.node.up = item.node;
			item.node.down = item.node;

			if (!item.visible)
				continue;

			maxWidth = Math.max(maxWidth, item.width);
			if (curY + item.height > FlxG.height - MARGIN_TOP) {
				curY = MARGIN_TOP;
				curX += maxWidth + 20;
				maxWidth = 0;
				idY = 0;
				idX++;
			}

			item.x = curX;
			item.y = curY;

			curY += item.height + 5;

			item.PX = idX;
			item.PY = idY;

			idY++;

			if (grid[item.PY] == null) {
				grid[item.PY] = [];
			}

			grid[item.PY][item.PX] = item.node;
		}

		function getPos(x:Int, y:Int):MapNode {
			if (grid.length == 0)
				return null;
			y = CoolUtil.mod(y, grid.length);
			if (grid[y] == null)
				return null;
			x = CoolUtil.mod(x, grid[y].length);
			return grid[y][x];
		}

		for (i => item in itemsTxt) {
			if (!item.visible)
				continue;
			#if (haxe >= "4.3.0")
			item.node.left = getPos(item.PX - 1, item.PY) ?? getPos(-1, item.PY) ?? item.node;
			item.node.right = getPos(item.PX + 1, item.PY) ?? getPos(0, item.PY) ?? item.node;
			item.node.up = getPos(item.PX, item.PY - 1) ?? getPos(item.PX, -1) ?? item.node;
			item.node.down = getPos(item.PX, item.PY + 1) ?? getPos(item.PX, 0) ?? item.node;
			#else
			item.node.left = getPos(item.PX - 1, item.PY);
			if (item.node.left == null) {
				item.node.left = getPos(-1, item.PY);
				if (item.node.left == null) {
					item.node.left = item.node;
				}
			}

			item.node.right = getPos(item.PX + 1, item.PY);
			if (item.node.right == null) {
				item.node.right = getPos(0, item.PY);
				if (item.node.right == null) {
					item.node.right = item.node;
				}
			}

			item.node.up = getPos(item.PX, item.PY - 1);
			if (item.node.up == null) {
				item.node.up = getPos(item.PX, -1);
				if (item.node.up == null) {
					item.node.up = item.node;
				}
			}

			item.node.down = getPos(item.PX, item.PY + 1);
			if (item.node.down == null) {
				item.node.down = getPos(item.PX, 0);
				if (item.node.down == null) {
					item.node.down = item.node;
				}
			}
			#end
		}

		updateTexts();
	}

	var exiting = false;

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (exiting)
			return;

		var enter = FlxG.keys.justPressed.ENTER;

		if (FlxG.mouse.justMoved || FlxG.mouse.pressed) {
			var x = FlxG.mouse.screenX;
			var y = FlxG.mouse.screenY;
			for (item in itemsTxt) {
				if (item.visible && item.x <= x && item.x + item.width >= x && item.y <= y && item.y + item.height >= y) {
					curSelected = item.SID;
					updateTexts();
					if (FlxG.mouse.pressed)
						enter = true;
					break;
				}
			}
		}

		if (FlxG.keys.justPressed.UP)
			changeSelectionY(-1);
		if (FlxG.keys.justPressed.DOWN)
			changeSelectionY(1);
		if (FlxG.keys.justPressed.LEFT)
			changeSelectionX(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeSelectionX(1);

		if (enter)
			acceptSelection();
		if (controls.BACK)
			back();
	}

	function acceptSelection() {}

	function back() {}

	function generateGrid() {
		var grid:Array<Array<FlxText>> = [];
		for (item in itemsTxt) {
			if (grid[item.PY] == null) {
				grid[item.PY] = [];
			}
			grid[item.PY][item.PX] = item;
		}
		return grid;
	}

	function changeSelectionY(change:Int = 0) {
		if (change == -1)
			curSelected = itemsTxt[curSelected].node.up.SID;
		if (change == 1)
			curSelected = itemsTxt[curSelected].node.down.SID;

		updateTexts();
	}

	function changeSelectionX(change:Int = 0) {
		if (change == -1)
			curSelected = itemsTxt[curSelected].node.left.SID;
		if (change == 1)
			curSelected = itemsTxt[curSelected].node.right.SID;

		updateTexts();
	}

	function updateTexts() {
		for (i => item in itemsTxt) {
			item.color = (i == curSelected) ? 0xFFFFFF00 : 0xFFFFFFFF;
		}
	}
}
