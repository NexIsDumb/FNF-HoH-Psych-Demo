package overworld;

@:structInit
class PlayerStatus {
	public var cripple:Bool;
	public var bench:Bool;
}

class Player extends FlxSprite {
	public var status:PlayerStatus;
	public var prevflip = false;
	public var speed = 0.0;
	public var oldy = 0.0;
	public var benchpos = [0.0, 0.0];

	public function crippleStatus(input:Bool, ?note:Null<String>) {
		this.status.cripple = input;
		#if RELEASE_DEBUG
		if (note != null) {
			trace(note);
		}
		#end
	}

	public function new(x:Float, y:Float) {
		super(x, y);
		oldy = y;

		status = {
			cripple: false,
			bench: false,
		};

		frames = Paths.getSparrowAtlas('Overworld/VBF_OVERWORLD', 'hymns');
		// scale
		scale.set(0.4, 0.4);
		updateHitbox();
		antialiasing = ClientPrefs.data.antialiasing;

		// animations
		animation.addByPrefix('idle', 'VBF idle dance hub', 24, true);
		animation.addByPrefix('walk', 'VBF walk loop', 24, true);
		animation.addByPrefix('walk2', 'VBF walk loop', 24, true);
		animation.addByPrefix('walkstart', 'VBF walk start', 24, false);
		animation.addByPrefix('walkend', 'VBF walk end', 24, false);
		animation.addByPrefix('walkturn', 'VBF walk turn', 24, false);
		animation.addByPrefix('interacts', 'VBF interact start', 24, false);
		animation.addByPrefix('interactl', 'VBF interact loop', 24, true);
		animation.addByPrefix('interacte', 'VBF interact end', 24, false);

		animation.addByPrefix('benchmount', 'VBF bench mount', 24, false);
		animation.addByPrefix('benchdismount', 'VBF bench desmount', 24, false);

		// playing anim
		animation.play('idle', true);
		offset.set(99.6, 145.8);

		if (DataSaver.played == false) {
			DataSaver.played = true; // The moment a player spawns in game, the game save should be marked as "played"
			DataSaver.getSave(DataSaver.saveFile).data.played = true;
		}
	}

	var mounted:Bool = false;
	
	function handleWalkStart(offsetd:Float) {
		animation.play("walkstart");
		var tempoffset = (offsetd * 1.25);
		if (flipX == true) {
			tempoffset = offsetd / 0.75;
		}
		offset.set(99.6 + tempoffset, 145.8 - 13);
	}

	
	function handleWalk(offsetd:Float) {
		offset.set(99.6 + offsetd, 145.8 - 12);
		if (flipX == true && animation.curAnim.name != "walk2") {
			var oldFrame = animation.curAnim.curFrame;
			animation.play("walk2");
			animation.curAnim.curFrame = oldFrame;
		} else {
			if (flipX == false && animation.curAnim.name != "walk") {
				var oldFrame = animation.curAnim.curFrame;
				animation.play("walk");
				animation.curAnim.curFrame = oldFrame;
			}
		}
	}

	function handleWalkEnd(offsetd:Float) {
		var tempoffset = 0;
		if (flipX == false) {
			tempoffset = 36;
		}
		offset.set(99.6 + tempoffset, 145.8 - 4);
		animation.play("walkend");
	}

	function handleIdle(offsetd:Float) {
		if (animation.curAnim.name == "interactl") {
			animation.play("interacte");
			offset.set(99.6 + 7, 145.8);
		}
		if ((animation.curAnim.name == "interacte" && animation.curAnim.finished) || animation.curAnim.name != "interacte") {
			if (animation.curAnim.name.startsWith("walk")) {
				if (animation.curAnim.name != "walkend") {
					handleWalkEnd(offsetd);
				} else {
					if (animation.curAnim.name == "walkend" && animation.curAnim.finished) {
						animation.play("idle", true);
						offset.set(99.6, 145.8);
					}
				}
			} else {
				animation.play("idle", true);
				offset.set(99.6, 145.8);
			}
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.2, 0, 1);
		var fpsscale = 60 / Main.fpsVar.currentFPS;

		if (status.bench == false) {
			if (status.cripple == false) {
				y = FlxMath.lerp(y, oldy, lerpVal);
				if (mounted == false) {
					var walkDirection:Int = 0;
					var offsetd = 31;
					if (OverworldManager.instance.controls.UI_LEFT) {
						walkDirection--;
						if (animation.curAnim.name != "walkturn") {
							flipX = false;
						}
					}
					if (OverworldManager.instance.controls.UI_RIGHT) {
						walkDirection++;
						if (animation.curAnim.name != "walkturn") {
							flipX = true;
						}
						offsetd = 10;
					}

					speed = FlxMath.lerp(speed, walkDirection * 7, lerpVal);
					x += speed * fpsscale;

					if (walkDirection != 0) {
						if (animation.curAnim.name.startsWith("walk")) {
							if (prevflip != flipX) {
								handleWalkStart(offsetd);
							}
							if (animation.curAnim.name == "walkend") {
								handleWalkStart(offsetd);
							}
							if ((animation.curAnim.name != "walkstart" || (animation.curAnim.name == "walkstart" && animation.curAnim.finished)) && (animation.curAnim.name != "walkturn" || (animation.curAnim.name == "walkturn" && animation.curAnim.finished))) {
								handleWalk(offsetd);
							}
						} else {
							handleWalkStart(offsetd);
						}
					} else {
						if (animation.curAnim.name != "idle") {
							handleIdle(offsetd);
						}
					}
				} else {
					if (animation.curAnim.name != "benchdismount") {
						animation.play("benchdismount");
						animation.onFinish.add(function(name) {
							switch (name) {
								case "benchdismount":
									mounted = false;
									OverworldManager.instance.regenSoulMeter();
							}
						});
					}
				}
			} else {
				if (animation.curAnim.name == "interacts" && animation.curAnim.finished) {
					if (animation.curAnim.name == "interacts" && animation.curAnim.finished) {
						animation.play("interactl");
						offset.set(99.6 + 5, 145.8 - 2.5);
					}
				}
				speed = 0;
			}
		} else {
			if (animation.curAnim.name != "benchmount") {
				mounted = true;
				animation.play("benchmount");
				flipX = true;
			}
		}

		if (animation.curAnim.name == "benchmount" || animation.curAnim.name == "benchdismount") {
			x = FlxMath.lerp(x, benchpos[0], lerpVal);
			if (animation.curAnim.name == "benchmount") {
				y = FlxMath.lerp(y, benchpos[1], lerpVal);
			}
		}
		prevflip = flipX;
	}
}
