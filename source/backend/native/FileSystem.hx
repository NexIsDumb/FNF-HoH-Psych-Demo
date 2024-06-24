package backend.native;

#if sys
import sys.io.File as SysFile;
import sys.FileSystem as SysFileSystem;
import sys.FileStat;
import sys.io.FileOutput;
import sys.io.FileInput;

class FileSystem {
	/**
		Returns `true` if the file or directory specified by `path` exists.
	**/
	public static function exists(path:String):Bool {
		path = Utils.removeLibraryPath(path);
		return SysFileSystem.exists(path);
	}

	/**
		Renames/moves the file or directory specified by `path` to `newPath`.

		If `path` is not a valid file system entry, or if it is not accessible,
		or if `newPath` is not accessible, an exception is thrown.
	**/
	public static function rename(path:String, newPath:String):Void {
		path = Utils.removeLibraryPath(path);
		newPath = Utils.removeLibraryPath(newPath);
		SysFileSystem.rename(path, newPath);
	}

	/**
		Returns `FileStat` information for the file or directory specified by
		`path`.
	**/
	public static function stat(path:String):FileStat {
		path = Utils.removeLibraryPath(path);
		return SysFileSystem.stat(path);
	}

	/**
		Returns the full path of the file or directory specified by `relPath`,
		which is relative to the current working directory. Symlinks will be
		followed and the path will be normalized.
	**/
	public static function fullPath(relPath:String):String {
		relPath = Utils.removeLibraryPath(relPath);
		return SysFileSystem.fullPath(relPath);
	}

	/**
		Returns the full path of the file or directory specified by `relPath`,
		which is relative to the current working directory. The path doesn't
		have to exist.
	**/
	public static function absolutePath(relPath:String):String {
		relPath = Utils.removeLibraryPath(relPath);
		return SysFileSystem.absolutePath(relPath);
	}

	/**
		Returns `true` if the file or directory specified by `path` is a directory.

		If `path` is not a valid file system entry or if its destination is not
		accessible, an exception is thrown.
	**/
	public static function isDirectory(path:String):Bool {
		path = Utils.removeLibraryPath(path);
		return SysFileSystem.isDirectory(path);
	}

	/**
		Creates a directory specified by `path`.

		This method is recursive: The parent directories don't have to exist.

		If the directory cannot be created, an exception is thrown.
	**/
	public static function createDirectory(path:String):Void {
		path = Utils.removeLibraryPath(path);
		SysFileSystem.createDirectory(path);
	}

	/**
		Deletes the file specified by `path`.

		If `path` does not denote a valid file, or if that file cannot be
		deleted, an exception is thrown.
	**/
	public static function deleteFile(path:String):Void {
		path = Utils.removeLibraryPath(path);
		SysFileSystem.deleteFile(path);
	}

	/**
		Deletes the directory specified by `path`. Only empty directories can
		be deleted.

		If `path` does not denote a valid directory, or if that directory cannot
		be deleted, an exception is thrown.
	**/
	public static function deleteDirectory(path:String):Void {
		path = Utils.removeLibraryPath(path);
		SysFileSystem.deleteDirectory(path);
	}

	/**
		Returns the names of all files and directories in the directory specified
		by `path`. `"."` and `".."` are not included in the output.

		If `path` does not denote a valid directory, an exception is thrown.
	**/
	public static function readDirectory(path:String):Array<String> {
		path = Utils.removeLibraryPath(path);
		return SysFileSystem.readDirectory(path);
	}
}
#end
