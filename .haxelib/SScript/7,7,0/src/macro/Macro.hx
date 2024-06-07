package macro;

import haxe.macro.Compiler;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;
import haxe.macro.Printer;
import haxe.macro.TypeTools;
import haxe.macro.TypedExprTools;

import tea.backend.SScriptVer;
import tea.backend.crypto.Base32;

import haxe.Serializer;
import haxe.Unserializer;

#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

typedef SuperlativeSettings = {
	public var showMacro:Bool;
	public var includeAll:Bool;
	public var loopCost:Int;
}

@:access(hscriptBase.Tools)
class Macro
{
	public static final defaultSettings:SuperlativeSettings = {
		showMacro: true,
		includeAll: false,
		loopCost: 25
	}

	#if !macro
	public static final allClassesAvailable:Map<String, Class<Dynamic>> = hscriptBase.Tools.names.copy();
	#end

	public static var VERSION(default, null):SScriptVer = new SScriptVer(7, 7, 0);

	#if sys
	public static var isWindows(default, null):Bool =  ~/^win/i.match(Sys.systemName());
	public static var definePath(get, never):String;
	public static var settingsPath(get, never):String;
	#end

	static var credits:Array<String> = [
		"Special Thanks:",
		"- CrowPlexus\n",
	];

	public static var macroClasses:Array<Class<Dynamic>> = [
		Compiler,
		Context,
		MacroStringTools,
		Printer,
		ComplexTypeTools,
		TypedExprTools,
		ExprTools,
		TypeTools,
	]; 

	macro
	public static function initiateMacro() 
	{
		var settings:SuperlativeSettings = defaultSettings;
		#if (sys)
		if (!FileSystem.exists(settingsPath))
		{
			#if !debug
			function checkAnswer()
			{
				if (["yes", "y"].contains(Sys.stdin().readLine().toLowerCase().trim()))
					return true;

				return false;
			}
			// Intro //
			log('[SScript ${VERSION}] No setup has been done, compilation now will enter setup mode.');
			log('If you wish to rerun this setup later, delete $settingsPath');
			log();

			// 
			Sys.print('Customize settings? (Y/N to use default settings): ');
			var r = checkAnswer();
			if (r)
			{
				log();
				Sys.print("Setting #1: Show SScript Macro screen (Y/N): ");
				var r = checkAnswer();
				if (r)
					settings.showMacro = true;
				else
					settings.showMacro = false;

				log();
				Sys.print("Setting #2: Loop Unrolling Maximum Cost (Leave it blank for 25, Maximum value is 200): ");
				var cost:Null<Int> = Std.parseInt(Sys.stdin().readLine());
				if (cost != null)
					settings.loopCost = if (cost <= 200) cost else 200;

				log();
				Sys.print("Setting #3: Import all existing classes into scripts [Not recommended] (Y/N): ");
				var r = checkAnswer();
				if (r)
					settings.includeAll = true;
				else 
					settings.includeAll = false;
			}

			var serialized = Serializer.run(settings);
			File.saveContent(settingsPath, serialized);
			log("Setup is complete, you may now compile.");
			Sys.exit(1);
			#end
		}
		else 
		{
			settings = new Unserializer(File.getContent(settingsPath)).unserialize();
		}
		#end
		
		final defines = Context.getDefines();

		if (settings.showMacro)
		{
			var long:String = '-------------------------------------------------------------------';
			log('------------------------SScript ${VERSION} Macro------------------------');

			for (i in credits)
				log(i);

			log('Checking version...');
			
			#if (haxe >= "4.3.2")
			var v = VERSION.checkVer();

			if (v == null)
			{
				log('There was an error getting the latest version info, you may not have internet connection.');
				log('Continuing...');
			}
			else if (v)
				log('Done! You are using the latest SScript version!');
			else if (!v)
			{
				log('You\'re using an outdated version of SScript (${VERSION}). Please update it to ${SScriptVer.newerVer}.');
				#if sys 
				log("Would you like to update SScript? This will abort the current compilation process.");
				Sys.print("(Yes/No): ");
				var r = Sys.stdin().readLine();
				if (["yes", "y"].contains(r.toLowerCase().trim()))
				{
					var p = new Process("haxelib remove SScript && haxelib install SScript");
					while (true) 
					{
						var o = p.stdout.readLine();
						if (o.trim() == "Done")
						{
							p.close();
							break;
						}
					}
					p = null;
						
					log();
					log("Done.");
					log(long);
					Sys.exit(1);
				}
				else if (["no", "n"].contains(r.toLowerCase().trim()))
				{
					log();
					log("Continuing...");
				}
				else 
				{
					log("Invalid answer given, aborting.");
					log(long);
					Sys.exit(1);
				}
				#end
			}
			#else
			log('You are using the ${defines.get("haxe")} version of Haxe, SScript works best with Haxe 4.3.2 or newer. Update your Haxe version.');
			log('Continuing...');
			#end
			
			log(long);
			log();
		}

		#if sys
		var pushedDefines:Array<String> = [];
		var string:String = "";
		for (i => k in defines)
		{
			if (!pushedDefines.contains(i))
			{
				string += '$i|$k';
				string += '\n';
				pushedDefines.push(i);
			}
		}
		var splitString:Array<String> = string.split('\n');
		if (splitString.length > 1 && string.endsWith('\n'))
		{
			splitString.pop();
			string = splitString.join('\n');
		}
		
		var path:String = definePath;
		File.saveContent(path, new Base32().encodeString(string));
		#end

		if (defines.exists('openflPos') && (
		#if openfl
		#if (openfl < "9.2.0")
		true
		#else
		false
		#end 
		#else
		true
		#end))
		#if (openfl < "9.2.0") Context.fatalError('Your openfl is outdated (${defines.get('openfl')}), please update openfl', (macro null).pos) #else Context.fatalError('You cannot use \'openflPos\' without targeting openfl', (macro null).pos) #end;

		Compiler.define('loop_unroll_max_cost', Std.string(settings.loopCost)); // Haxe will try to unroll big loops which may cause memory leaks
		if (settings.includeAll)
			Compiler.define('SUPERLATIVE_INCLUDE_ALL');
		return macro {}
	}

	public static function log(?log:String = "")
	{
		#if sys
		Sys.println(log);
		#else
		trace('\n' + log);
		#end
	}

	#if sys
	static function get_definePath():String 
	{
		var env:String = if (isWindows) Sys.getEnv('USERPROFILE') else Sys.getEnv('HOME');
		if (isWindows && !env.endsWith('\\'))
			env += '\\';
		else if (!isWindows && !env.endsWith('/'))
			env += '/';

		return env + 'defines.cocoa';
	}

	static function get_settingsPath():String 
	{
		var env:String = if (isWindows) Sys.getEnv('USERPROFILE') else Sys.getEnv('HOME');
		if (isWindows && !env.endsWith('\\'))
			env += '\\';
		else if (!isWindows && !env.endsWith('/'))
			env += '/';

		return env + 'settings.cocoa';
	}
	#end
}