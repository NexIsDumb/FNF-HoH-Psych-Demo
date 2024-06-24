package backend.native;

#if sys
import sys.io.File as SysFile;
import sys.FileSystem as SysFileSystem;
import sys.FileStat;
import sys.io.FileOutput;
import sys.io.FileInput;

class File {
	/**
		Retrieves the content of the file specified by `path` as a String.

		If the file does not exist or can not be read, an exception is thrown.

		`sys.FileSystem.exists` can be used to check for existence.

		If `path` is null, the result is unspecified.
	**/
	public static function getContent(path:String):String {
		path = Utils.removeLibraryPath(path);
		return SysFile.getContent(path);
	}

	/**
		Stores `content` in the file specified by `path`.

		If the file cannot be written to, an exception is thrown.

		If `path` or `content` are null, the result is unspecified.
	**/
	public static function saveContent(path:String, content:String):Void {
		path = Utils.removeLibraryPath(path);
		SysFile.saveContent(path, content);
	}

	/**
		Retrieves the binary content of the file specified by `path`.

		If the file does not exist or can not be read, an exception is thrown.

		`sys.FileSystem.exists` can be used to check for existence.

		If `path` is null, the result is unspecified.
	**/
	public static function getBytes(path:String):haxe.io.Bytes {
		path = Utils.removeLibraryPath(path);
		return SysFile.getBytes(path);
	}

	/**
		Stores `bytes` in the file specified by `path` in binary mode.

		If the file cannot be written to, an exception is thrown.

		If `path` or `bytes` are null, the result is unspecified.
	**/
	public static function saveBytes(path:String, bytes:haxe.io.Bytes):Void {
		path = Utils.removeLibraryPath(path);
		SysFile.saveBytes(path, bytes);
	}

	/**
		Returns an `FileInput` handle to the file specified by `path`.

		If `binary` is true, the file is opened in binary mode. Otherwise it is
		opened in non-binary mode.

		If the file does not exist or can not be read, an exception is thrown.

		Operations on the returned `FileInput` handle read on the opened file.

		File handles should be closed via `FileInput.close` once the operation
		is complete.

		If `path` is null, the result is unspecified.
	**/
	public static function read(path:String, binary:Bool = true):FileInput {
		path = Utils.removeLibraryPath(path);
		return SysFile.read(path, binary);
	}

	/**
		Returns an `FileOutput` handle to the file specified by `path`.

		If `binary` is true, the file is opened in binary mode. Otherwise it is
		opened in non-binary mode.

		If the file cannot be written to, an exception is thrown.

		Operations on the returned `FileOutput` handle write to the opened file.
		If the file existed, its previous content is overwritten.

		File handles should be closed via `FileOutput.close` once the operation
		is complete.

		If `path` is null, the result is unspecified.
	**/
	public static function write(path:String, binary:Bool = true):FileOutput {
		path = Utils.removeLibraryPath(path);
		return SysFile.write(path, binary);
	}

	/**
		Similar to `sys.io.File.write`, but appends to the file if it exists
		instead of overwriting its contents.
	**/
	public static function append(path:String, binary:Bool = true):FileOutput {
		path = Utils.removeLibraryPath(path);
		return SysFile.append(path, binary);
	}

	/**
		Similar to `sys.io.File.append`. While `append` can only seek or write
		starting from the end of the file's previous contents, `update` can
		seek to any position, so the file's previous contents can be
		selectively overwritten.
	**/
	public static function update(path:String, binary:Bool = true):FileOutput {
		path = Utils.removeLibraryPath(path);
		return SysFile.update(path, binary);
	}

	/**
		Copies the contents of the file specified by `srcPath` to the file
		specified by `dstPath`.

		If the `srcPath` does not exist or cannot be read, or if the `dstPath`
		file cannot be written to, an exception is thrown.

		If the file at `dstPath` exists, its contents are overwritten.

		If `srcPath` or `dstPath` are null, the result is unspecified.
	**/
	public static function copy(srcPath:String, dstPath:String):Void {
		srcPath = Utils.removeLibraryPath(srcPath);
		dstPath = Utils.removeLibraryPath(dstPath);
		SysFile.copy(srcPath, dstPath);
	}
}
#end
