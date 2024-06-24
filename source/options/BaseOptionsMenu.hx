package options;

import objects.CheckboxThingie;
import objects.AttachedText;
import options.Option;
import flixel.text.FlxText.FlxTextAlign;

class BaseOptionsMenu extends MusicBeatSubstate {
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	private var grpOptions:FlxTypedGroup<FlxText>;
	private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	private var grpTexts:FlxTypedGroup<FlxText>;

	private var descBox:FlxSprite;
	private var descText:FlxText;
	var pointer1:FlxSprite;
	var pointer2:FlxSprite;
	var back:FlxText;

	public var title:String;
	public var rpcTitle:String;

	public function new() {
		super();

		if (title == null)
			title = 'Options';
		if (rpcTitle == null)
			rpcTitle = 'Options Menu';

		#if desktop
		DiscordClient.changePresence(rpcTitle, null);
		#end

		// avoids lagspikes while scrolling through menus!
		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<FlxText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;

		descText = new FlxText(0, 0, 0, optionsArray[curSelected].description, 12);
		descText.setFormat(Paths.font("perpetua.ttf"), 16, FlxColor.WHITE, LEFT);
		descText.screenCenterXY();
		descText.x = FlxG.width / 3.25 + 10;
		descText.y -= FlxG.height / 6;
		descText.antialiasing = ClientPrefs.data.antialiasing;
		add(descText);

		for (i in 0...optionsArray.length) {
			var optionText:FlxText = new FlxText(0, 0, 0, "", 12);
			optionText.setFormat(Constants.UI_FONT, 20, FlxColor.WHITE, LEFT);
			optionText.text = optionsArray[i].name + ":";
			optionText.screenCenterXY();
			optionText.x = FlxG.width / 3.25;
			optionText.y -= FlxG.height / 6;
			optionText.y += 50 * i;
			optionText.antialiasing = ClientPrefs.data.antialiasing;
			optionText.ID = i;
			grpTexts.add(optionText);

			if (optionsArray[i].type == 'bool') {
				var optionText:FlxText = new FlxText(0, 0, 250, optionsArray[i].getValue() ? "ON" : "OFF", 12);
				optionText.setFormat(Constants.UI_FONT, 18, FlxColor.WHITE, FlxTextAlign.RIGHT);
				optionText.autoSize = false;
				optionText.screenCenterXY();
				optionText.x = FlxG.width - FlxG.width / 1.95;
				optionText.y -= FlxG.height / 6;
				optionText.y += 50 * i;
				optionText.antialiasing = ClientPrefs.data.antialiasing;
				optionText.ID = i;
				grpOptions.add(optionText);
			} else {
				var optionText:FlxText = new FlxText(0, 0, 250, optionsArray[i].getValue(), 12);
				optionText.setFormat(Constants.UI_FONT, 18, FlxColor.WHITE, FlxTextAlign.RIGHT);
				optionText.autoSize = false;
				optionText.screenCenterXY();
				optionText.x = FlxG.width - FlxG.width / 1.95;
				optionText.y -= FlxG.height / 6;
				optionText.y += 50 * i;
				optionText.antialiasing = ClientPrefs.data.antialiasing;
				optionText.ID = i;
				grpOptions.add(optionText);
			}
			// optionText.snapToPosition(); //Don't ignore me when i ask for not making a fucking pull request to uncomment this line ok
		}

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

		back = new FlxText(0, 0, 0, "Back", 12);
		back.setFormat(Constants.UI_FONT, 18, FlxColor.WHITE, CENTER);
		back.screenCenterXY();
		back.y -= FlxG.height / 6;
		back.y += 50 * 8;
		back.ID = optionsArray.length;
		back.antialiasing = ClientPrefs.data.antialiasing;
		add(back);

		changeSelection();
		reloadCheckboxes();

		for (spr in grpOptions.members) {
			spr.alpha = 0;
			FlxTween.tween(spr, {alpha: 1}, .15, {ease: FlxEase.circOut});
		}
		for (spr in grpTexts.members) {
			spr.alpha = 0;
			FlxTween.tween(spr, {alpha: 1}, .15, {ease: FlxEase.circOut});
		}
		pointer1.alpha = 0;
		pointer2.alpha = 0;
		back.alpha = 0;
		descText.alpha = 0;
		FlxTween.tween(pointer1, {alpha: 1}, .15, {ease: FlxEase.circOut});
		FlxTween.tween(pointer2, {alpha: 1}, .15, {ease: FlxEase.circOut});
		FlxTween.tween(back, {alpha: 1}, .15, {ease: FlxEase.circOut});
		FlxTween.tween(descText, {alpha: 1}, .15, {ease: FlxEase.circOut});
	}

	public function addOption(option:Option) {
		if (optionsArray == null || optionsArray.length < 1)
			optionsArray = [];
		optionsArray.push(option);
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var holdValue:Float = 0;

	override function update(elapsed:Float) {
		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			coolclose();
			FlxG.sound.play(Paths.sound('cancelMenu'));

			curSelected = optionsArray.length;
			changeSelection(0);
		}

		if (nextAccept <= 0 && back.ID != curSelected) {
			var usesCheckbox = true;
			if (curOption.type != 'bool') {
				usesCheckbox = false;
			}

			if (usesCheckbox) {
				if (controls.ACCEPT) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curOption.setValue((curOption.getValue() == true) ? false : true);
					curOption.change();
					reloadCheckboxes();
				}
			} else {
				if (controls.UI_LEFT || controls.UI_RIGHT) {
					var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
					if (holdTime > 0.5 || pressed) {
						if (pressed) {
							var add:Dynamic = null;
							if (curOption.type != 'string') {
								add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
							}

							switch (curOption.type) {
								case 'int' | 'float' | 'percent':
									holdValue = curOption.getValue() + add;
									if (holdValue < curOption.minValue)
										holdValue = curOption.minValue;
									else if (holdValue > curOption.maxValue)
										holdValue = curOption.maxValue;

									switch (curOption.type) {
										case 'int':
											holdValue = Math.round(holdValue);
											curOption.setValue(holdValue);

										case 'float' | 'percent':
											holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
											curOption.setValue(holdValue);
									}

								case 'string':
									var num:Int = curOption.curOption; // lol
									if (controls.UI_LEFT_P)
										--num;
									else
										num++;

									if (num < 0) {
										num = curOption.options.length - 1;
									} else if (num >= curOption.options.length) {
										num = 0;
									}

									curOption.curOption = num;
									curOption.setValue(curOption.options[num]); // lol
									// trace(curOption.options[num]);
							}
							updateTextFrom(curOption);
							curOption.change();
							var optiona = grpOptions.members[curSelected];
							optiona.updateHitbox();
							optiona.screenCenterXY();
							optiona.x = FlxG.width - FlxG.width / 1.95;
							optiona.y -= FlxG.height / 6;
							optiona.y += 50 * curSelected;
							FlxG.sound.play(Paths.sound('scrollMenu'));
						} else if (curOption.type != 'string') {
							holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
							if (holdValue < curOption.minValue)
								holdValue = curOption.minValue;
							else if (holdValue > curOption.maxValue)
								holdValue = curOption.maxValue;

							switch (curOption.type) {
								case 'int': curOption.setValue(Math.round(holdValue));

								case 'float' | 'percent': curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
							}
							updateTextFrom(curOption);
							curOption.change();
							var optiona = grpOptions.members[curSelected];
							optiona.updateHitbox();
							optiona.screenCenterXY();
							optiona.x = FlxG.width - FlxG.width / 1.95;
							optiona.y -= FlxG.height / 6;
							optiona.y += 50 * curSelected;
						}
					}

					if (curOption.type != 'string') {
						holdTime += elapsed;
					}
				} else if (controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					clearHold();
				}

				reloadCheckboxes();
			}

			if (controls.RESET) {
				var leOption:Option = optionsArray[curSelected];
				leOption.setValue(leOption.defaultValue);
				if (leOption.type != 'bool') {
					if (leOption.type == 'string')
						leOption.curOption = leOption.options.indexOf(leOption.getValue());
					updateTextFrom(leOption);
				}
				leOption.change();
				FlxG.sound.play(Paths.sound('cancelMenu'));
				reloadCheckboxes();
			}
		} else {
			if (back.ID == curSelected) {
				if (controls.ACCEPT) {
					coolclose();
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
			}
		}

		if (nextAccept > 0) {
			nextAccept -= 1;
		}

		for (spr in grpOptions.members) {
			if (spr.ID == curSelected) {
				spr.screenCenterXY();
				spr.x = FlxG.width - FlxG.width / 1.95;
				spr.y -= FlxG.height / 6;
				spr.y += 50 * curSelected;
			}
		}

		super.update(elapsed);
	}

	function updateTextFrom(option:Option) {
		var text:String = option.displayFormat;
		var val:Dynamic = option.getValue();
		if (option.type == 'percent')
			val *= 100;
		var def:Dynamic = option.defaultValue;
		var silly = text.replace('%v', val).replace('%d', def);

		if (option.text != silly) {
			option.text = silly;
			var optiona = grpOptions.members[curSelected];
			optiona.updateHitbox();
			optiona.screenCenterXY();
			optiona.x = FlxG.width - FlxG.width / 1.95;
			optiona.y -= FlxG.height / 6;
			optiona.y += 50 * curSelected;
		}
	}

	function clearHold() {
		if (holdTime > 0.5) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		holdTime = 0;
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsArray.length;
		if (curSelected >= optionsArray.length + 1)
			curSelected = 0;

		for (spr in grpOptions.members) {
			if (spr.ID == curSelected) {
				var they = spr.getGraphicMidpoint().y - (spr.height / 2);
				pointer1.x = spr.x;
				pointer1.y = they;
				pointer1.x -= 265;
				pointer1.animation.play('idle', true);

				pointer2.x = spr.x;
				pointer2.y = they;
				pointer2.x += spr.width + 15;
				pointer2.animation.play('idle', true);

				descText.text = optionsArray[curSelected].description;
				descText.y = spr.getGraphicMidpoint().y + 10;
			}
		}

		if (back.ID == curSelected) {
			pointer1.screenCenterX();
			pointer1.y = back.getGraphicMidpoint().y - (back.height / 2);
			pointer1.x -= (back.width / 2) + pointer1.width / 1.5;
			pointer1.animation.play('idle', true);

			pointer2.screenCenterX();
			pointer2.y = back.getGraphicMidpoint().y - (back.height / 2);
			pointer2.x += (back.width / 2) + pointer1.width / 1.5;
			pointer2.animation.play('idle', true);

			descText.text = "";
		}

		curOption = optionsArray[curSelected]; // shorter lol
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function reloadCheckboxes() {
		for (i in 0...optionsArray.length) {
			if (optionsArray[i].type == 'bool') {
				if (!(grpOptions.members[i].text == (optionsArray[i].getValue() ? "ON" : "OFF"))) {
					grpOptions.members[i].text = optionsArray[i].getValue() ? "ON" : "OFF";
				}
			} else {
				if (!(grpOptions.members[i].text == optionsArray[i].getValue())) {
					grpOptions.members[i].text = optionsArray[i].getValue();
				}
			}
		}
	}

	function coolclose() {
		for (spr in grpOptions.members) {
			FlxTween.tween(spr, {alpha: 0}, .15, {ease: FlxEase.circOut});
		}
		for (spr in grpTexts.members) {
			FlxTween.tween(spr, {alpha: 0}, .15, {ease: FlxEase.circOut});
		}
		FlxTween.tween(pointer1, {alpha: 0}, .15, {ease: FlxEase.circOut});
		FlxTween.tween(pointer2, {alpha: 0}, .15, {ease: FlxEase.circOut});
		FlxTween.tween(back, {alpha: 0}, .15, {ease: FlxEase.circOut});
		FlxTween.tween(descText, {alpha: 0}, .15, {ease: FlxEase.circOut});

		new FlxTimer().start(.25, function(tmr:FlxTimer) {
			close();
		});
	}
}
