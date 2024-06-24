package states;

import states.MainMenuState;
import backend.StageData;
import flixel.addons.transition.FlxTransitionableState;
import hxcodec.flixel.*;
import states.savefile.*;
import overworld.*;

class SaveState extends MenuBeatState {
	var saveFile1:SaveFile;
	var saveFile2:SaveFile;
	var saveFile3:SaveFile;
	var saveFile4:SaveFile;

	var pointer1:FlxSprite;
	var pointer2:FlxSprite;

	var savefiles:Array<SaveFile> = [];

	var curSelectedy = 0;
	var curSelectedx = 0;

	var selector:FlxSprite;

	var debounce:Bool = false;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Save File Selection", null);
		#end

		persistentUpdate = persistentDraw = true;

		var basey = 150;
		var seperation = 15;

		saveFile1 = new SaveFile(150, basey, 1);
		add(saveFile1);

		new FlxTimer().start(0.25, function(tmr:FlxTimer) {
			saveFile2 = new SaveFile(150, basey + (167 * 0.6 + seperation), 2);
			add(saveFile2);
			savefiles = [saveFile1, saveFile2];
		});

		new FlxTimer().start(.5, function(tmr:FlxTimer) {
			saveFile3 = new SaveFile(150, basey + (167 * 0.6 + seperation) * 2, 3);
			add(saveFile3);
			savefiles = [saveFile1, saveFile2, saveFile3];
		});

		new FlxTimer().start(.75, function(tmr:FlxTimer) {
			saveFile4 = new SaveFile(150, basey + (167 * 0.6 + seperation) * 3, 4);
			add(saveFile4);
			savefiles = [saveFile1, saveFile2, saveFile3, saveFile4];
		});

		savefiles = [saveFile1,];

		pointer1 = new FlxSprite(0, 0);
		pointer1.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer1.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer1.animation.play('idle', true);
		add(pointer1);
		pointer1.antialiasing = ClientPrefs.data.antialiasing;
		pointer1.setGraphicSize(Std.int(pointer1.width * 0.4));
		pointer1.updateHitbox();

		pointer2 = new FlxSprite(0, 0);
		pointer2.frames = Paths.getSparrowAtlas('Menus/Main/pointer', 'hymns');
		pointer2.animation.addByPrefix('idle', "pointer instantie 1", 24, false);
		pointer2.animation.play('idle', true);
		add(pointer2);
		pointer2.antialiasing = ClientPrefs.data.antialiasing;
		pointer2.flipX = true;
		pointer2.setGraphicSize(Std.int(pointer2.width * 0.4));
		pointer2.updateHitbox();

		var spr = savefiles[0].dirtmouth;
		selector = new FlxSprite(0, 0).loadGraphic(Paths.image('Menus/Profile/Profile_Selector', 'hymns'));
		selector.setGraphicSize(spr.width, spr.height);
		selector.updateHitbox();
		selector.x = spr.x;
		selector.y = spr.y;
		selector.antialiasing = ClientPrefs.data.antialiasing;
		selector.alpha = 0;
		FlxTween.tween(selector, {alpha: .125}, 1, {ease: FlxEase.quadInOut});
		add(selector);

		changeSelection(0);

		debounce = false;
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			debounce = true;
		});

		super.create();
	}

	var selected:Bool = false;
	var clearingsave:Bool = false;
	var choosingstate:Bool = false;

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.state == this && debounce == true) {
			if (controls.UI_UP_P && !clearingsave && !choosingstate) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P && !clearingsave && !choosingstate) {
				changeSelection(1);
			}

			if (controls.UI_LEFT_P && (savefiles[curSelectedy].clearsave.alpha == 1 || clearingsave || choosingstate)) {
				changeSelection(-1, true);
			}
			if (controls.UI_RIGHT_P && (savefiles[curSelectedy].clearsave.alpha == 1 || clearingsave || choosingstate)) {
				changeSelection(1, true);
			}

			if (!selected) {
				if (controls.ACCEPT) {
					if (!choosingstate) {
						if (curSelectedx == 0) {
							if (!clearingsave) {
								FlxTween.tween(selector, {alpha: 0}, 1, {ease: FlxEase.quadInOut});

								DataSaver.loadData(curSelectedy + 1);
								DataSaver.played = true;
								DataSaver.saveSettings(curSelectedy + 1);
								choosingstate = true;
								curSelectedx = 0;

								FlxTween.tween(savefiles[curSelectedy].yes2, {alpha: 1}, .35, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].no2, {alpha: 1}, .35, {ease: FlxEase.quadInOut});
								var rawData:Bool = DataSaver.unlockedCharms.get("Swindler");
								if (!rawData) {
									savefiles[curSelectedy].no2.color = FlxColor.fromRGB(150, 150, 150);
								} else {
									savefiles[curSelectedy].no2.color = FlxColor.fromRGB(255, 255, 255);
								}
								FlxTween.tween(savefiles[curSelectedy].newgame, {alpha: 0}, .15, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].clearsave, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								if (savefiles[curSelectedy].dirtmouthtween != null) {
									savefiles[curSelectedy].dirtmouthtween.cancel();
								}
								savefiles[curSelectedy].dirtmouthtween = FlxTween.tween(savefiles[curSelectedy].dirtmouth, {alpha: 0}, .5, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].clearsave, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								changeSelection(0);
							} else {
								DataSaver.wipeData(curSelectedy + 1);
								DataSaver.loadData(curSelectedy + 1);
								DataSaver.saveSettings(curSelectedy + 1);

								FlxTween.tween(savefiles[curSelectedy].newgame, {alpha: 1}, .15, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].yes, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].no, {alpha: 0}, .35, {ease: FlxEase.quadInOut});

								new FlxTimer().start(0.15, function(tmr:FlxTimer) {
									savefiles[curSelectedy].newgame.text = "New Game";
									FlxTween.tween(savefiles[curSelectedy].newgame, {alpha: 1}, .35, {ease: FlxEase.quadInOut});
								});

								curSelectedx = 0;
								selector.alpha = 0;
								clearingsave = false;
								changeSelection(0);
							}
						} else {
							if (!clearingsave) {
								clearingsave = true;

								selector.alpha = 0;
								curSelectedx = 0;

								FlxTween.tween(savefiles[curSelectedy].yes, {alpha: 1}, .35, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].no, {alpha: 1}, .35, {ease: FlxEase.quadInOut});
								if (savefiles[curSelectedy].dirtmouthtween != null) {
									savefiles[curSelectedy].dirtmouthtween.cancel();
								}
								savefiles[curSelectedy].dirtmouthtween = FlxTween.tween(savefiles[curSelectedy].dirtmouth, {alpha: 0}, .5, {ease: FlxEase.quadInOut});

								savefiles[curSelectedy].newgame.text = "Clear Save?";
								FlxTween.tween(savefiles[curSelectedy].newgame, {alpha: 1}, .5, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].clearsave, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								changeSelection(0);
							} else {
								clearingsave = false;

								selector.alpha = 0;
								curSelectedx = 1;

								FlxTween.tween(savefiles[curSelectedy].yes, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].no, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								if (savefiles[curSelectedy].dirtmouthtween != null) {
									savefiles[curSelectedy].dirtmouthtween.cancel();
								}
								savefiles[curSelectedy].dirtmouthtween = FlxTween.tween(savefiles[curSelectedy].dirtmouth, {alpha: .5}, .5, {ease: FlxEase.quadInOut});

								new FlxTimer().start(0.15, function(tmr:FlxTimer) {
									savefiles[curSelectedy].newgame.text = "New Game";
								});
								FlxTween.tween(savefiles[curSelectedy].newgame, {alpha: 0}, .15, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].clearsave, {alpha: 1}, .35, {ease: FlxEase.quadInOut});
								changeSelection(0);
							}
						}
					} else {
						var rawData:Bool = DataSaver.unlockedCharms.get("Swindler");
						if (rawData) {
							if (curSelectedx == 0) {
								for (i in 0...savefiles.length) {
									var savefile = savefiles[i];
									new FlxTimer().start(0.125 * i, function(tmr:FlxTimer) {
										savefile.BEGONETHOT();
									});
								}

								FlxG.sound.music.fadeOut(1, 0);
								new FlxTimer().start(0.35 * 3, function(tmr:FlxTimer) {
									MusicBeatState.switchState(new OverworldManager());
								});
							} else {
								for (i in 0...savefiles.length) {
									var savefile = savefiles[i];
									new FlxTimer().start(0.125 * i, function(tmr:FlxTimer) {
										savefile.BEGONETHOT();
									});
								}

								FlxTransitionableState.skipNextTransIn = false;
								new FlxTimer().start(0.35 * 3, function(tmr:FlxTimer) {
									MusicBeatState.switchState(new FreeplayState());
								});

								FlxTween.tween(pointer1, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								FlxTween.tween(pointer2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
							}
							FlxTween.tween(savefiles[curSelectedy].yes2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
							FlxTween.tween(savefiles[curSelectedy].no2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
							FlxTween.tween(pointer1, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
							FlxTween.tween(pointer2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
							selected = true;
						} else {
							if (curSelectedx == 0) {
								for (i in 0...savefiles.length) {
									var savefile = savefiles[i];
									new FlxTimer().start(0.125 * i, function(tmr:FlxTimer) {
										savefile.BEGONETHOT();
									});
								}

								FlxG.sound.music.fadeOut(1, 0);
								new FlxTimer().start(0.35 * 3, function(tmr:FlxTimer) {
									MusicBeatState.switchState(new OverworldManager());
								});
								FlxTween.tween(savefiles[curSelectedy].yes2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								FlxTween.tween(savefiles[curSelectedy].no2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								FlxTween.tween(pointer1, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								FlxTween.tween(pointer2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
								selected = true;
							}
						}
					}
				}

				if (controls.BACK) {
					if (choosingstate) {
						choosingstate = false;
						FlxTween.tween(savefiles[curSelectedy].yes2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
						FlxTween.tween(savefiles[curSelectedy].no2, {alpha: 0}, .35, {ease: FlxEase.quadInOut});
						FlxTween.tween(savefiles[curSelectedy].clearsave, {alpha: 1}, .35, {ease: FlxEase.quadInOut});
						if (savefiles[curSelectedy].dirtmouthtween != null) {
							savefiles[curSelectedy].dirtmouthtween.cancel();
						}
						savefiles[curSelectedy].dirtmouthtween = FlxTween.tween(savefiles[curSelectedy].dirtmouth, {alpha: .5}, .5, {ease: FlxEase.quadInOut});
						changeSelection(0);
					} else if (!clearingsave) {
						selected = true;
						for (i in 0...savefiles.length) {
							var savefile = savefiles[i];
							new FlxTimer().start(0.125 * i, function(tmr:FlxTimer) {
								savefile.BEGONETHOT();
							});
						}

						new FlxTimer().start(0.35 * 3, function(tmr:FlxTimer) {
							MusicBeatState.switchState(new MainMenuState());
						});
					}
				}
			}
		}
	}

	function changeSelection(change:Int = 0, sillybilly:Bool = false) {
		if (!sillybilly) {
			if (!clearingsave) {
				curSelectedy += change;
				if (curSelectedy < 0)
					curSelectedy = savefiles.length - 1;
				if (curSelectedy >= savefiles.length)
					curSelectedy = 0;
			}
		} else {
			curSelectedx += change;
			if (curSelectedx < 0)
				curSelectedx = 1;
			if (curSelectedx >= 2)
				curSelectedx = 0;

			if (savefiles[curSelectedy].clearsave.alpha == 0 && !clearingsave && !choosingstate)
				curSelectedx = 0;
		}

		selector.x = savefiles[curSelectedy].dirtmouth.x - 50;
		selector.y = savefiles[curSelectedy].dirtmouth.y - 2.5;

		var spr = selector;
		var clearsave = savefiles[curSelectedy].clearsave;

		selector.alpha = 0;
		if (!clearingsave && !choosingstate) {
			if (curSelectedx == 1)
				spr = clearsave;
			else
				FlxTween.tween(selector, {alpha: .125}, .35, {ease: FlxEase.quadInOut});
		} else {
			if (clearingsave)
				if (curSelectedx == 0) {
					spr = savefiles[curSelectedy].yes;
				} else {
					spr = savefiles[curSelectedy].no;
				}
		}

		if (choosingstate)
			if (curSelectedx == 0) {
				spr = savefiles[curSelectedy].yes2;
			} else {
				spr = savefiles[curSelectedy].no2;
			}

		pointer1.screenCenterX();
		if (clearingsave || choosingstate)
			pointer1.x = spr.getGraphicMidpoint().x + 10;
		if (choosingstate)
			pointer1.x += 10;

		if (curSelectedx == 1 && !clearingsave)
			pointer1.x = spr.getGraphicMidpoint().x + 25;

		pointer1.y = spr.getGraphicMidpoint().y - (spr.height / 1.55);
		if (spr == selector)
			pointer1.y += 15;
		pointer1.x -= (spr.width / 1.35) + pointer1.width / 1.5 + 25;
		pointer1.animation.play('idle', true);

		pointer2.screenCenterX();
		if (clearingsave || choosingstate)
			pointer2.x = spr.getGraphicMidpoint().x - 25;

		if (curSelectedx == 1 && !clearingsave || (curSelectedx == 1))
			pointer2.x = spr.getGraphicMidpoint().x - 5;

		if (curSelectedx == 1 && choosingstate)
			pointer2.x = spr.getGraphicMidpoint().x - 17.5;

		pointer2.y = spr.getGraphicMidpoint().y - (spr.height / 1.55);
		if (spr == selector)
			pointer2.y += 15;
		pointer2.x += (spr.width / 4) + pointer1.width / 1.5 + 25;
		pointer2.animation.play('idle', true);

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy() {
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}
