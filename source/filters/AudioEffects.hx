package filters;

import lime.media.openal.ALFilter;
import flixel.tweens.FlxTween;
import lime.media.openal.ALSource;
import flixel.FlxBasic;
import flixel.system.FlxSound;
import lime.media.openal.AL;

using filters.extensions.ALExtension;

class AudioEffects extends FlxBasic {
	public var audioFilter:ALFilter;

	// var aux = AL.createAux();
	// var effect = AL.createEffect();
	var handle:ALSource;
	var sound:FlxSound;

	// var revDecay:Float = 0;
	// var revGain:Float = 0;
	var filterType = AL.FILTER_NULL;

	public var lowpassGain:Float = 0;
	public var lowpassGainHF:Float = 0;

	public var _tween:FlxTween;

	public var name:String;

	public function new(?_handle:FlxSound, name:String = "") {
		super();
		if (_handle != null) {
			setHandle(_handle);
		}
		this.name = name;
	}

	override function destroy() {
		super.destroy();
		if (audioFilter != null) {
			AL.deleteFilter(audioFilter);
			audioFilter = null;
		}
	}

	override function update(elapsed:Float) {
		// super.update(elapsed);
		if (sound != null) {
			@:privateAccess if (sound._channel != null) {
				handle = sound._channel.__audioSource.__backend.handle;
				// trace("Found a handle");
			}
		}
		if (handle == null)
			return;

		if (filterType == AL.FILTER_LOWPASS) {
			if (audioFilter != null) {
				AL.deleteFilter(audioFilter);
				audioFilter = null;
			}
			if (audioFilter == null) {
				audioFilter = AL.createFilter();
			}
			AL.filteri(audioFilter, AL.FILTER_TYPE, AL.FILTER_LOWPASS);
			AL.filterf(audioFilter, AL.LOWPASS_GAIN, lowpassGain);
			AL.filterf(audioFilter, AL.LOWPASS_GAINHF, lowpassGainHF);
			AL.sourcei(handle, AL.DIRECT_FILTER, audioFilter);
		}
	}

	public function setHandle(music:FlxSound) {
		sound = music;
		@:privateAccess if (music._channel != null) {
			handle = music._channel.__audioSource.__backend.handle;
			update(0);
		}
	}

	public function setLowpassFull(music:FlxSound, gain:Float = 0, gainHF:Float = 0) {
		setHandle(music);

		filterType = AL.FILTER_LOWPASS;
		lowpassGain = gain;
		lowpassGainHF = gainHF;

		update(0);
	}

	public function setLowpassGain(gain:Float = 0) {
		filterType = AL.FILTER_LOWPASS;
		lowpassGain = gain;

		update(0);
	}

	public function setLowpassGainHF(gainHF:Float = 0) {
		filterType = AL.FILTER_LOWPASS;
		lowpassGainHF = gainHF;

		update(0);
	}

	public function tween(gain:Float = 0, gainHF:Float = 0, duration:Float = 0, startDelay:Float = 0) {
		filterType = AL.FILTER_LOWPASS;
		if (_tween != null) {
			_tween.cancel();
		}
		_tween = FlxTween.tween(this, {lowpassGainHF: gainHF, lowpassGain: gain}, duration, {
			startDelay: startDelay,
			onComplete: function(_) {
				_tween = null;
			}
		});
	}
}
