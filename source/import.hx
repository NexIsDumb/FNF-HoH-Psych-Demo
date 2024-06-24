#if !macro
import backend.native.File;
import backend.native.FileSystem;
// Discord API
#if desktop
import backend.Discord;
#end
// Psych
#if LUA_ALLOWED
import llua.*;
import llua.Lua;
#end
import backend.BaseStage;
import backend.ClientPrefs;
import backend.Conductor;
import backend.Controls;
import backend.CoolUtil;
import backend.CustomFadeTransition;
import backend.Difficulty;
import backend.MenuBeatState;
import backend.Mods;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.Paths;
// Flixel
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.Alphabet;
import objects.BGSprite;
import states.LoadingState;
import states.PlayState;
import tjson.TJSON as Json;

using StringTools;
using backend.extensions.Extensions;
#end
