package;

import haxe.Json;
import hxp.Haxelib;
import hxp.HXML;
import hxp.Log;
import hxp.NDLL;
import hxp.Path;
import hxp.System;
import lime.tools.AssetHelper;
import lime.tools.AssetType;
import lime.tools.CPPHelper;
import lime.tools.DeploymentHelper;
import lime.tools.HTML5Helper;
import lime.tools.HXProject;
import lime.tools.Icon;
import lime.tools.IconHelper;
import lime.tools.Orientation;
import lime.tools.PlatformTarget;
import lime.tools.ProjectHelper;
import sys.io.File;
import sys.FileSystem;

class WebAssemblyPlatform extends PlatformTarget
{
	private var dependencyPath:String;
	private var outputFile:String;

	public function new(command:String, _project:HXProject, targetFlags:Map<String, String>)
	{
		super(command, _project, targetFlags);

		var defaults = new HXProject();

		defaults.meta =
			{
				title: "MyApplication",
				description: "",
				packageName: "com.example.myapp",
				version: "1.0.0",
				company: "",
				companyUrl: "",
				buildNumber: null,
				companyId: ""
			};

		defaults.app =
			{
				main: "Main",
				file: "MyApplication",
				path: "bin",
				preloader: "",
				swfVersion: 17,
				url: "",
				init: null
			};

		defaults.window =
			{
				width: 800,
				height: 600,
				parameters: "{}",
				background: 0xFFFFFF,
				fps: 30,
				hardware: true,
				display: 0,
				resizable: true,
				borderless: false,
				orientation: Orientation.AUTO,
				vsync: false,
				fullscreen: false,
				allowHighDPI: true,
				alwaysOnTop: false,
				antialiasing: 0,
				allowShaders: true,
				requireShaders: false,
				depthBuffer: true,
				stencilBuffer: true,
				colorDepth: 32,
				maximized: false,
				minimized: false,
				hidden: false,
				title: ""
			};

		defaults.window.fps = 60;
		defaults.window.allowHighDPI = false;

		for (i in 1...project.windows.length)
		{
			defaults.windows.push(defaults.window);
		}

		defaults.merge(project);
		project = defaults;

		targetDirectory = Path.combine(project.app.path, project.config.getString("webassembly.output-directory", "webassembly"));
		dependencyPath = project.config.getString("webassembly.dependency-path", "lib");
		outputFile = targetDirectory + "/bin/" + project.app.file + ".js";
	}

	public override function build():Void
	{
		var sdkPath = null;

		if (project.defines.exists("EMSCRIPTEN_SDK"))
		{
			sdkPath = project.defines.get("EMSCRIPTEN_SDK");
		}
		else if (project.environment.exists("EMSCRIPTEN_SDK"))
		{
			sdkPath = project.environment.get("EMSCRIPTEN_SDK");
		}

		if (sdkPath == null)
		{
			Log.error("You must define EMSCRIPTEN_SDK with the path to your Emscripten SDK.");
		}

		var hxml = targetDirectory + "/haxe/" + buildType + ".hxml";
		var args = [hxml, "-D", "webassembly", "-D", "wasm", "-D", "emscripten", "-D", "webgl", "-D", "static_link"];

		if (Log.verbose)
		{
			args.push("-D");
			args.push("verbose");
		}

		System.runCommand("", "haxe", args);

		if (noOutput) return;

		CPPHelper.compile(project, targetDirectory + "/obj", ["-Dwebassembly", "-Dwasm", "-Demscripten", "-Dwebgl", "-Dstatic_link"]);
		// CPPHelper.compile(project, targetDirectory + "/obj", ["-Demscripten", "-Dwebgl", "-Dstatic_link"], "BuildMain.xml");

		project.path(sdkPath);

		System.runCommand("", "emcc", ["-c", targetDirectory + "/obj/Main.cpp", "-o", targetDirectory + "/obj/Main.o"], true, false, true);

		args = ["Main.o"];

		for (ndll in project.ndlls)
		{
			var path = NDLL.getLibraryPath(ndll, "Emscripten", "lib", ".a", project.debug);
			args.push(path);
		}

		var json = Json.parse(File.getContent(Haxelib.getPath(new Haxelib("hxcpp"), true) + "/haxelib.json"));
		var prefix = "";

		var version = Std.string(json.version);
		var versionSplit = version.split(".");

		while (versionSplit.length > 2)
			versionSplit.pop();

		if (Std.parseFloat(versionSplit.join(".")) > 3.1)
		{
			prefix = "lib";
		}

		args = args.concat([
			prefix + "ApplicationMain" + (project.debug ? "-debug" : "") + ".a",
			"-o",
			"ApplicationMain.o"
		]);

		if (!project.targetFlags.exists("asmjs"))
		{
			args.push("-s");
			args.push("WASM=1");
		}
		else
		{
			args.push("-s");
			args.push("ASM_JS=1");
		}

		args.push("-s");
		args.push("NO_EXIT_RUNTIME=1");

		args.push("-s");
		args.push("USE_SDL=2");

		for (dependency in project.dependencies)
		{
			if (dependency.name != "")
			{
				args.push("-l" + dependency.name);
			}
		}

		if (project.targetFlags.exists("final") || project.defines.exists("disable-exception-catching") || project.targetFlags.exists("disable-exception-catching"))
		{
			args.push("-s");
			args.push("DISABLE_EXCEPTION_CATCHING=1");
		}
		else
		{
			args.push("-gsource-map");
			args.push("-s");
			args.push("DISABLE_EXCEPTION_CATCHING=0");
			args.push("-s");
			args.push("NO_DISABLE_EXCEPTION_CATCHING=1");
			args.push("-s");
			args.push("ASSERTIONS=1");
			// args.push("-s");
			// args.push("ASSERTIONS=2");
			// args.push("-s");
			// args.push("STACK_OVERFLOW_CHECK=2");
			// args.push("-s");
			// args.push("DEMANGLE_SUPPORT=1");
		}

		// set initial size
		// args.push("-s");
		// args.push("INITIAL_MEMORY=32MB");

		args.push("-s");
		args.push("STACK_SIZE=1MB");

		// args.push("-s");
		// args.push("SAFE_HEAP=1");

		// if (project.targetFlags.exists("final"))
		// {
		// 	args.push("-O3");
		// }
		// else if (!project.debug)
		// {
		// 	// args.push ("-s");
		// 	// args.push ("OUTLINING_LIMIT=70000");
		// 	args.push("-O2");
		// }
		// else
		// {
		// 	args.push("-O1");
		// }

		// https://github.com/HaxeFoundation/hxcpp/issues/987
		args.push("-O0");

		args.push("-s");
		args.push("ALLOW_MEMORY_GROWTH=1");

		if (project.targetFlags.exists("minify"))
		{
			// 02 enables minification

			// args.push ("--minify");
			// args.push ("1");
			// args.push ("--closure");
			// args.push ("1");
		}

		// args.push ("--memory-init-file");
		// args.push ("1");
		// args.push ("--jcache");
		// args.push ("-g");

		if (FileSystem.exists(targetDirectory + "/obj/assets"))
		{
			args.push("--preload-file");
			args.push("assets");
		}

		if (Log.verbose)
		{
			args.push("-v");
		}

		// if (project.targetFlags.exists ("compress")) {
		//
		// args.push ("--compression");
		// args.push (System.findTemplate (project.templatePaths, "bin/utils/lzma/compress.exe") + "," + System.findTemplate (project.templatePaths, "resources/lzma-decoder.js") + ",LZMA.decompress");
		// args.push ("haxelib run openfl compress," + System.findTemplate (project.templatePaths, "resources/lzma-decoder.js") + ",LZMA.decompress");
		// args.push ("-o");
		// args.push ("../bin/index.html");
		//
		// } else {

		args.push("-o");
		args.push("../bin/" + project.app.file + ".js");

		// }

		// args.push ("../bin/index.html");

		System.runCommand(targetDirectory + "/obj", "emcc", args, true, false, true);

		if (FileSystem.exists(outputFile))
		{
			var context = project.templateContext;
			context.SOURCE_FILE = File.getContent(outputFile);
			context.embeddedLibraries = [];

			for (dependency in project.dependencies)
			{
				if (dependency.embed && StringTools.endsWith(dependency.path, ".js") && FileSystem.exists(dependency.path))
				{
					var script = File.getContent(dependency.path);
					context.embeddedLibraries.push(script);
				}
			}

			System.copyFileTemplate(project.templatePaths, "webassembly/output.js", outputFile, context);
		}

		if (project.targetFlags.exists("minify"))
		{
			HTML5Helper.minify(project, targetDirectory + "/bin/" + project.app.file + ".js");
		}

		if (project.targetFlags.exists("compress"))
		{
			if (FileSystem.exists(targetDirectory + "/bin/" + project.app.file + ".data"))
			{
				// var byteArray = ByteArray.readFile (targetDirectory + "/bin/" + project.app.file + ".data");
				// byteArray.compress (CompressionAlgorithm.GZIP);
				// File.saveBytes (targetDirectory + "/bin/" + project.app.file + ".data.compress", byteArray);
			}

			// var byteArray = ByteArray.readFile (targetDirectory + "/bin/" + project.app.file + ".js");
			// byteArray.compress (CompressionAlgorithm.GZIP);
			// File.saveBytes (targetDirectory + "/bin/" + project.app.file + ".js.compress", byteArray);
		}
		else
		{
			File.saveContent(targetDirectory + "/bin/.htaccess", "SetOutputFilter DEFLATE");
		}
	}

	public override function clean():Void
	{
		if (FileSystem.exists(targetDirectory))
		{
			System.removeDirectory(targetDirectory);
		}
	}

	public override function deploy():Void
	{
		DeploymentHelper.deploy(project, targetFlags, targetDirectory, "WebAssembly");
	}

	public override function display():Void
	{
		if (project.targetFlags.exists("output-file"))
		{
			Sys.println(outputFile);
		}
		else
		{
			Sys.println(getDisplayHXML().toString());
		}
	}

	private function getDisplayHXML():HXML
	{
		var path = targetDirectory + "/haxe/" + buildType + ".hxml";

		if (FileSystem.exists(path))
		{
			return File.getContent(path);
		}
		else
		{
			var context = project.templateContext;
			var hxml = HXML.fromString(context.HAXE_FLAGS);
			hxml.addClassName(context.APP_MAIN);
			hxml.cpp = "_";
			hxml.define("webgl");
			hxml.noOutput = true;
			return hxml;
		}
	}

	public override function rebuild():Void
	{
		CPPHelper.rebuild(project, [["-Dwebassembly", "-Dwasm", "-Demscripten", "-Dstatic_link"]]);
	}

	public override function run():Void
	{
		HTML5Helper.launch(project, targetDirectory + "/bin");
	}

	public override function update():Void
	{
		AssetHelper.processLibraries(project, targetDirectory);

		// project = project.clone ();

		for (asset in project.assets)
		{
			if (asset.embed && asset.sourcePath == "")
			{
				var path = Path.combine(targetDirectory + "/obj/tmp", asset.targetPath);
				System.mkdir(Path.directory(path));
				AssetHelper.copyAsset(asset, path);
				asset.sourcePath = path;
			}
		}

		// for (asset in project.assets)
		// {
		// 	asset.resourceName = "assets/" + asset.resourceName;
		// }

		var destination = targetDirectory + "/bin/";
		System.mkdir(destination);

		// for (asset in project.assets) {
		//
		// if (asset.type == AssetType.FONT) {
		//
		// project.haxeflags.push (HTML5Helper.generateFontData (project, asset));
		//
		// }
		//
		// }

		if (project.targetFlags.exists("xml"))
		{
			project.haxeflags.push("-xml " + targetDirectory + "/types.xml");
		}

		var context = project.templateContext;

		context.WIN_FLASHBACKGROUND = StringTools.hex(project.window.background, 6);
		context.OUTPUT_DIR = targetDirectory;
		context.OUTPUT_FILE = outputFile;
		context.CPP_DIR = targetDirectory + "/obj";
		context.USE_COMPRESSION = project.targetFlags.exists("compress");

		context.favicons = [];

		var icons = project.icons;

		if (icons.length == 0)
		{
			icons = [new Icon(System.findTemplate(project.templatePaths, "default/icon.svg"))];
		}

		// if (IconHelper.createWindowsIcon (icons, Path.combine (destination, "favicon.ico"))) {
		//
		// context.favicons.push ({ rel: "icon", type: "image/x-icon", href: "./favicon.ico" });
		//
		// }

		if (IconHelper.createIcon(icons, 192, 192, Path.combine(destination, "favicon.png")))
		{
			context.favicons.push({rel: "shortcut icon", type: "image/png", href: "./favicon.png"});
		}

		for (dependency in project.dependencies)
		{
			if (!dependency.embed)
			{
				if (StringTools.endsWith(dependency.name, ".js"))
				{
					context.linkedLibraries.push(dependency.name);
				}
				else if (StringTools.endsWith(dependency.path, ".js") && FileSystem.exists(dependency.path))
				{
					var name = Path.withoutDirectory(dependency.path);

					context.linkedLibraries.push("./" + dependencyPath + "/" + name);
					System.copyIfNewer(dependency.path, Path.combine(destination, Path.combine(dependencyPath, name)));
				}
			}
		}

		for (asset in project.assets)
		{
			var path = Path.combine(targetDirectory + "/obj/assets", asset.targetPath);

			if (asset.type != AssetType.TEMPLATE)
			{
				// if (asset.type != AssetType.FONT) {

				System.mkdir(Path.directory(path));
				AssetHelper.copyAssetIfNewer(asset, path);

				// }
			}
		}

		ProjectHelper.recursiveSmartCopyTemplate(project, "webassembly/template", destination, context);
		ProjectHelper.recursiveSmartCopyTemplate(project, "haxe", targetDirectory + "/haxe", context);
		ProjectHelper.recursiveSmartCopyTemplate(project, "webassembly/hxml", targetDirectory + "/haxe", context);
		// ProjectHelper.recursiveSmartCopyTemplate(project, "webassembly/cpp", targetDirectory + "/obj", context);
		ProjectHelper.recursiveSmartCopyTemplate(project, "cpp/static", targetDirectory + "/obj", context);

		for (asset in project.assets)
		{
			var path = Path.combine(destination, asset.targetPath);

			if (asset.type == AssetType.TEMPLATE)
			{
				System.mkdir(Path.directory(path));
				AssetHelper.copyAsset(asset, path, context);
			}
		}
	}

	@ignore public override function install():Void {}

	@ignore public override function trace():Void {}

	@ignore public override function uninstall():Void {}
}
