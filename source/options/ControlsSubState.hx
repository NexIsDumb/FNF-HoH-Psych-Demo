package options;

import backend.InputFormatter;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import objects.AttachedSprite;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepadManager;

class ControlsSubState extends MusicBeatSubstate {
	var curSelected:Int = 0;
	var curAlt:Bool = false;

	// Show on gamepad - Display name - Save file key - Rebind display name
	var options:Array<Dynamic> = [
		[true, 'Left', 'note_left', 'Note Left'],
		[true, 'Down', 'note_down', 'Note Down'],
		[true, 'Up', 'note_up', 'Note Up'],
		[true, 'Right', 'note_right', 'Note Right'],
		[true, 'Accept', 'accept', 'Accept'],
		[true, 'Back', 'back', 'Back'],
		[true, 'Pause', 'pause', 'Pause'],
		[true, 'UI Left', 'ui_left', 'UI Left'],
		[true, 'UI Down', 'ui_down', 'UI Down'],
		[true, 'UI Up', 'ui_up', 'UI Up'],
		[true, 'UI Right', 'ui_right', 'UI Right'],
		[false, 'Mute', 'volume_mute', 'Volume Mute'],
		[false, 'Volume Up', 'volume_up', 'Volume Up'],
		[false, 'Volume Down', 'volume_down', 'Volume Down'],
	];
	var curOptions:Array<Int>;
	var curOptionsValid:Array<Int>;

	static var defaultKey:String = 'Reset to Default Keys';

	var grpDisplay:FlxTypedGroup<FlxText>;
	var grpBlacks:FlxTypedGroup<AttachedSprite>;
	var grpOptions:FlxTypedGroup<FlxText>;
	var grpButtons:FlxTypedGroup<FlxSprite>;
	var selectSpr:AttachedSprite;

	var pointer1:FlxSprite;
	var pointer2:FlxSprite;

	var gamepadColor:FlxColor = 0xfffd7194;
	var keyboardColor:FlxColor = 0xff7192fd;
	var onKeyboardMode:Bool = true;

	var controllerSpr:FlxSprite;
	var lor:Int = 1;
	var test:FlxText;

	public function new() {
		super();

		grpDisplay = new FlxTypedGroup<FlxText>();
		add(grpDisplay);
		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);
		grpBlacks = new FlxTypedGroup<AttachedSprite>();
		add(grpBlacks);
		selectSpr = new AttachedSprite();
		selectSpr.makeGraphic(250, 78, FlxColor.WHITE);
		selectSpr.copyAlpha = false;
		selectSpr.alpha = 0.75;
		// add(selectSpr);
		grpButtons = new FlxTypedGroup<FlxSprite>();
		add(grpButtons);

		pointer1 = new FlxSprite(0, 0);
		pointer1.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer1.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer1.animation.play('idle', true);
		add(pointer1);
		pointer1.antialiasing = ClientPrefs.data.antialiasing;
		pointer1.setGraphicSize(Std.int(pointer1.width * 0.25));
		pointer1.updateHitbox();

		pointer2 = new FlxSprite(0, 0);
		pointer2.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer2.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer2.animation.play('idle', true);
		add(pointer2);
		pointer2.antialiasing = ClientPrefs.data.antialiasing;
		pointer2.flipX = true;
		pointer2.setGraphicSize(Std.int(pointer2.width * 0.25));
		pointer2.updateHitbox();

		controllerSpr = new FlxSprite(50, 40).loadGraphic(Paths.image('controllertype'), true, 82, 60);
		controllerSpr.antialiasing = ClientPrefs.data.antialiasing;
		controllerSpr.animation.add('keyboard', [0], 1, false);
		controllerSpr.animation.add('gamepad', [1], 1, false);
		// add(controllerSpr);

		var text:Alphabet = new Alphabet(60, 90, 'CTRL', false);
		text.alignment = CENTERED;
		text.setScale(0.4);
		// add(text);
		// text.x + 30, text.y
		test = new FlxText(0, 0, 250, "...", 12);
		test.setFormat(Constants.UI_FONT, 14, FlxColor.WHITE, RIGHT);
		test.antialiasing = ClientPrefs.data.antialiasing;
		test.alpha = 0;
		add(test);

		createTexts();
	}

	var lastID:Int = 0;
	var back:FlxText;
	var reset:FlxText;

	function createTexts() {
		curOptions = [];
		curOptionsValid = [];
		grpDisplay.forEachAlive(function(text:FlxText) text.destroy());
		grpBlacks.forEachAlive(function(black:AttachedSprite) black.destroy());
		grpOptions.forEachAlive(function(text:FlxText) text.destroy());
		grpButtons.forEachAlive(function(text:FlxSprite) text.destroy());
		grpDisplay.clear();
		grpBlacks.clear();
		grpOptions.clear();
		grpButtons.clear();

		if (reset != null) {
			reset.destroy();
			back.destroy();
		}

		var myID:Int = 0;
		for (i in 0...options.length) {
			var option:Array<Dynamic> = options[i];
			if (option[0] || onKeyboardMode) {
				if (option.length > 1) {
					var isCentered:Bool = (option.length < 3);
					var isDefaultKey:Bool = (option[1] == defaultKey);
					var isDisplayKey:Bool = (isCentered && !isDefaultKey);

					if (!isDefaultKey) {
						var text:FlxText = new FlxText(0, 0, 0, TM.checkTransl(option[1], Paths.formatPath(cast(option[1], String))), 12);
						text.setFormat(Constants.UI_FONT, 17, FlxColor.WHITE, LEFT);
						text.screenCenterXY();
						text.x = FlxG.width / 3.75;
						if (i > 6) {
							text.x = FlxG.width / 1.75;
						}
						text.x -= 50;
						text.y -= FlxG.height / 5;
						text.y += 50 * (i % 7);
						text.antialiasing = ClientPrefs.data.antialiasing;
						text.ID = i;
						grpDisplay.add(text);
						text.ID = myID;
						lastID = myID;

						var button:FlxSprite = new FlxSprite(text.x + 225, text.y - 40);
						button.frames = Paths.getSparrowAtlas('Menus/Options/buttons', 'hymns');
						button.antialiasing = ClientPrefs.data.antialiasing;
						button.animation.addByPrefix('empty', 'empty', 1, false);
						button.animation.addByPrefix('longempty', 'longempty', 1, false);
						button.animation.play('empty');
						button.scale.set(0.43, 0.43);
						button.ID = i;
						grpButtons.add(button);

						if (ClientPrefs.keyBinds.get(option[2]) != null) {
							var keytext:FlxText = new FlxText(0, 0, 100, InputFormatter.getKeyName(ClientPrefs.keyBinds.get(option[2])[0]), 12);
							keytext.setFormat(Constants.UI_FONT, 16, FlxColor.WHITE, CENTER);
							var pos = button.getGraphicMidpoint();
							keytext.x = pos.x - (button.width / 2) - 3;
							keytext.y = pos.y - (button.height / 10);
							if (InputFormatter.getKeyName(ClientPrefs.keyBinds.get(option[2])[0]).length > 2) {
								button.animation.play('longempty');
								button.x -= button.width / 2.5 - 8;
								keytext.x -= button.width / 12 - 10;
							}
							pos.put();
							keytext.antialiasing = ClientPrefs.data.antialiasing;
							keytext.ID = i;
							grpOptions.add(keytext);
						}

						ClientPrefs.saveSettings();
					}
				}
				myID++;
			}
		}

		reset = new FlxText(0, 0, 0, TM.checkTransl(defaultKey, "reset-to-default-keys"), 12);
		reset.setFormat(Constants.UI_FONT, 18, FlxColor.WHITE, LEFT);
		reset.screenCenterXY();
		reset.y -= FlxG.height / 4;
		reset.y += 60 * 6.75;
		reset.antialiasing = ClientPrefs.data.antialiasing;
		add(reset);

		back = new FlxText(0, 0, 0, TM.checkTransl("Back", "back"), 12);
		back.setFormat(Constants.UI_FONT, 18, FlxColor.WHITE, CENTER);
		back.screenCenterXY();
		back.y -= FlxG.height / 6;
		back.y += 50 * 8;
		back.ID = options.length + 1;
		back.antialiasing = ClientPrefs.data.antialiasing;
		add(back);

		updateText();
	}

	function addCenteredText(text:Alphabet, option:Array<Dynamic>, id:Int) {
		text.screenCenterX();
		text.y -= 55;
		text.startPosition.y -= 55;
	}

	function playstationCheck(alpha:Alphabet) {
		if (onKeyboardMode)
			return;

		var gamepad:FlxGamepad = FlxG.gamepads.firstActive;
		var model:FlxGamepadModel = gamepad != null ? gamepad.detectedModel : UNKNOWN;
		var letter = alpha.letters[0];
		if (model == PS4) {
			switch (alpha.text) {
				case '[', ']': // Square and Triangle respectively
					letter.image = 'alphabet_playstation';
					letter.updateHitbox();

					letter.offset.x += 4;
					letter.offset.y -= 5;
			}
		}
	}

	var binding:Bool = false;
	var holdingEsc:Float = 0;
	var bindingBlack:FlxSprite;
	var bindingText:Alphabet;
	var bindingText2:Alphabet;

	var timeForMoving:Float = 0.1;

	override function update(elapsed:Float) {
		if (timeForMoving > 0) // Fix controller bug
		{
			timeForMoving = Math.max(0, timeForMoving - elapsed);
			super.update(elapsed);
			return;
		}

		if (!binding) {
			if (FlxG.keys.justPressed.ESCAPE || FlxG.gamepads.anyJustPressed(B)) {
				close();
				return;
			}
			// if(FlxG.keys.justPressed.CONTROL || FlxG.gamepads.anyJustPressed(LEFT_SHOULDER) || FlxG.gamepads.anyJustPressed(RIGHT_SHOULDER)) swapMode();

			if (controls.UI_UP_P)
				updateText(-1);
			else if (controls.UI_DOWN_P)
				updateText(1);

			if (controls.UI_LEFT_P) {
				if (curSelected < 7)
					lor--;
				updateText(0);
			} else {
				if (controls.UI_RIGHT_P) {
					if (curSelected < 7)
						lor++;
					updateText(0);
				}
			}

			if (controls.ACCEPT) {
				if (curSelected < 7) {
					var curselected2 = curSelected + ((lor - 1) * 7);
					grpDisplay.forEachAlive(function(item:FlxText) {
						if (item.ID == curselected2) {
							test.x = item.x + 30;
							test.y = item.y;
							test.alpha = 1;
						}
					});
					grpOptions.forEachAlive(function(item:FlxText) {
						if (item.ID == curselected2) {
							item.alpha = 0;
						}
					});
					grpButtons.forEachAlive(function(item:FlxSprite) {
						if (item.ID == curselected2) {
							item.alpha = 0;
						}
					});

					binding = true;
					holdingEsc = 0;
					ClientPrefs.toggleVolumeKeys(false);
				} else {
					if (curSelected - 7 == 0) {
						ClientPrefs.resetKeys(!onKeyboardMode);
						ClientPrefs.reloadVolumeKeys();
						var lastSel:Int = curSelected;
						createTexts();
						curSelected = lastSel;
						updateText();
						FlxG.sound.play(Paths.sound('cancelMenu'));
					} else {
						FlxG.sound.play(Paths.sound('cancelMenu'));
						close();
						return;
					}
				}
			}
		} else {
			var altNum:Int = curAlt ? 1 : 0;
			var curOption:Array<Dynamic> = options[curSelected + ((lor - 1) * 7)];
			if (FlxG.keys.pressed.ESCAPE || FlxG.gamepads.anyPressed(B)) {
				holdingEsc += elapsed;
				if (holdingEsc > 0.5) {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					closeBinding();
				}
			} else if (FlxG.keys.pressed.BACKSPACE || FlxG.gamepads.anyPressed(BACK)) {
				holdingEsc += elapsed;
				if (holdingEsc > 0.5) {
					ClientPrefs.keyBinds.get(curOption[2])[altNum] = NONE;
					ClientPrefs.clearInvalidKeys(curOption[2]);
					FlxG.sound.play(Paths.sound('cancelMenu'));
					closeBinding();
				}
			} else {
				holdingEsc = 0;
				var changed:Bool = false;
				var curKeys:Array<FlxKey> = ClientPrefs.keyBinds.get(curOption[2]);
				var curButtons:Array<FlxGamepadInputID> = ClientPrefs.gamepadBinds.get(curOption[2]);

				if (onKeyboardMode) {
					if (FlxG.keys.justPressed.ANY || FlxG.keys.justReleased.ANY) {
						var keyPressed:Int = FlxG.keys.firstJustPressed();
						var keyReleased:Int = FlxG.keys.firstJustReleased();
						if (keyPressed > -1 && keyPressed != FlxKey.ESCAPE && keyPressed != FlxKey.BACKSPACE) {
							curKeys[altNum] = keyPressed;
							changed = true;
						} else if (keyReleased > -1 && (keyReleased == FlxKey.ESCAPE || keyReleased == FlxKey.BACKSPACE)) {
							curKeys[altNum] = keyReleased;
							changed = true;
						}
					}
				} else if (FlxG.gamepads.anyJustPressed(ANY) || FlxG.gamepads.anyJustPressed(LEFT_TRIGGER) || FlxG.gamepads.anyJustPressed(RIGHT_TRIGGER) || FlxG.gamepads.anyJustReleased(ANY)) {
					var keyPressed:Null<FlxGamepadInputID> = NONE;
					var keyReleased:Null<FlxGamepadInputID> = NONE;
					if (FlxG.gamepads.anyJustPressed(LEFT_TRIGGER))
						keyPressed = LEFT_TRIGGER; // it wasnt working for some reason
					else if (FlxG.gamepads.anyJustPressed(RIGHT_TRIGGER))
						keyPressed = RIGHT_TRIGGER; // it wasnt working for some reason
					else {
						for (i in 0...FlxG.gamepads.numActiveGamepads) {
							var gamepad:FlxGamepad = FlxG.gamepads.getByID(i);
							if (gamepad != null) {
								keyPressed = gamepad.firstJustPressedID();
								keyReleased = gamepad.firstJustReleasedID();

								if (keyPressed == null)
									keyPressed = NONE;
								if (keyReleased == null)
									keyReleased = NONE;
								if (keyPressed != NONE || keyReleased != NONE)
									break;
							}
						}
					}

					if (keyPressed != NONE && keyPressed != FlxGamepadInputID.BACK && keyPressed != FlxGamepadInputID.B) {
						curButtons[altNum] = keyPressed;
						changed = true;
					} else if (keyReleased != NONE && (keyReleased == FlxGamepadInputID.BACK || keyReleased == FlxGamepadInputID.B)) {
						curButtons[altNum] = keyReleased;
						changed = true;
					}
				}

				if (changed) {
					if (onKeyboardMode) {
						if (curKeys[altNum] == curKeys[1 - altNum])
							curKeys[1 - altNum] = FlxKey.NONE;
					} else {
						if (curButtons[altNum] == curButtons[1 - altNum])
							curButtons[1 - altNum] = FlxGamepadInputID.NONE;
					}

					var option:String = options[curSelected + ((lor - 1) * 7)][2];
					ClientPrefs.clearInvalidKeys(option);
					for (n in 0...2) {
						var key:String = null;
						if (onKeyboardMode) {
							var savKey:Array<Null<FlxKey>> = ClientPrefs.keyBinds.get(option);
							key = InputFormatter.getKeyName(savKey[0] != null ? savKey[0] : NONE);

							trace(option, key);

							test.alpha = 0;

							var curselected2 = curSelected + ((lor - 1) * 7);
							grpOptions.forEachAlive(function(item:FlxText) {
								if (item.ID == curselected2) {
									item.text = key;
									item.alpha = 1;
								}
							});
							grpButtons.forEachAlive(function(item:FlxSprite) {
								if (item.ID == curselected2) {
									item.alpha = 1;
								}
							});
							updateText();
						} else {
							var savKey:Array<Null<FlxGamepadInputID>> = ClientPrefs.gamepadBinds.get(option);
							key = InputFormatter.getGamepadName(savKey[n] != null ? savKey[n] : NONE);
						}
					}
					FlxG.sound.play(Paths.sound('confirmMenu'));
					closeBinding();
				}
			}
		}
		super.update(elapsed);
	}

	function closeBinding() {
		binding = false;
		ClientPrefs.reloadVolumeKeys();
		FlxG.sound.play(Paths.sound('cancelMenu'));
	}

	function updateText(?move:Int = 0) {
		if (move != 0) {
			// var dir:Int = Math.round(move / Math.abs(move));
			curSelected += move;
			if (curSelected < 0) {
				curSelected = 8;
			} else {
				if (curSelected >= 9) {
					curSelected = 0;
				}
			}
		}

		if (lor < 1)
			lor = 2;
		if (lor > 2)
			lor = 1;

		var curselected2 = curSelected + ((lor - 1) * 7);

		if (curSelected < 7) {
			grpDisplay.forEachAlive(function(item:FlxText) {
				if (item.ID == curselected2) {
					var spr = item;
					var pos = spr.getGraphicMidpoint();
					pointer1.x = spr.x - 25;
					pointer1.y = pos.y - (spr.height / 2) - 2;
					pointer1.animation.play('idle', true);

					pointer2.x = spr.x;
					pointer2.y = pos.y - (spr.height / 2) - 2;
					pointer2.x += 300;
					pointer2.animation.play('idle', true);
					pos.put();
				}
				if (grpButtons.members[item.ID] != null) {
					grpButtons.members[item.ID].x = item.x + 225;
				}
			});

			grpOptions.forEachAlive(function(item:FlxText) {
				if (item.ID == curselected2) {
					if (item.text.length > 2) {
						pointer2.x += 25;
					}
				}
				if (grpButtons.members[item.ID] != null) {
					var button:FlxSprite = grpButtons.members[item.ID];
					var pos = button.getGraphicMidpoint();
					item.x = pos.x - (button.width / 2) - 3;
					pos.put();
					button.animation.play('empty');
					if (item.text.length > 2) {
						button.animation.play('longempty');
						button.x -= button.width / 2.5 - 8;
						item.x -= button.width / 1.425;
					}
				}
			});
		} else {
			var spr:FlxText = reset;
			if (curSelected - 7 == 1)
				spr = back;

			var pos = spr.getGraphicMidpoint();

			pointer1.screenCenterX();
			pointer1.y = pos.y - (spr.height / 2);
			pointer1.x -= (spr.width / 2) + pointer1.width / 1.5;
			pointer1.animation.play('idle', true);

			pointer2.screenCenterX();
			pointer2.y = pos.y - (spr.height / 2);
			pointer2.x += (spr.width / 2) + pointer1.width / 1.5;
			pointer2.animation.play('idle', true);

			pos.put();
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function swapMode() {
		onKeyboardMode = !onKeyboardMode;

		curSelected = 0;
		curAlt = false;
		controllerSpr.animation.play(onKeyboardMode ? 'keyboard' : 'gamepad');
		createTexts();
	}

	function updateAlt(?doSwap:Bool = false) {
		if (doSwap) {
			curAlt = !curAlt;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		selectSpr.sprTracker = grpBlacks.members[Math.floor(curSelected * 2) + (curAlt ? 1 : 0)];
		selectSpr.visible = (selectSpr.sprTracker != null);
	}
}
