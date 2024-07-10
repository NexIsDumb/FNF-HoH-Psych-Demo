package overworld.scenes;

import FlxG;
import objects.Character;

class BaseCharacter extends FlxSprite {
	public var onAnimationChange:String->Void = null;
	public var onInteract:String->Void = null;
	public var lastAnimation:String = '';
	override function update(elapsed:Float) {
		super.update(elapsed);
		if (onAnimationChange != null && animation.curAnim != null && animation.curAnim.name != lastAnimation) {
			onAnimationChange(animation.curAnim.name);
			lastAnimation = animation.curAnim.name;
		}
	}
}


