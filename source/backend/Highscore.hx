package backend;

class Highscore {
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();

	public static function resetSong(song:String, diff:Int = 0):Void {
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setRating(daSong, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void {
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1):Void {
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score) {
				setScore(daSong, score);
				if (rating >= 0)
					setRating(daSong, rating);
			}
		} else {
			setScore(daSong, score);
			if (rating >= 0)
				setRating(daSong, rating);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void {
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek)) {
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		} else
			setWeekScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void {
		songScores.set(song, score);
		DataSaver.songScores = songScores;
		DataSaver.saveSettings(DataSaver.saveFile);
	}

	static function setWeekScore(week:String, score:Int):Void {
		weekScores.set(week, score);
		DataSaver.weekScores = weekScores;
		DataSaver.saveSettings(DataSaver.saveFile);
	}

	static function setRating(song:String, rating:Float):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		DataSaver.songRating = songRating;
		DataSaver.saveSettings(DataSaver.saveFile);
	}

	public static function formatSong(song:String, diff:Int):String {
		return Paths.formatPath(song) + Difficulty.getFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int {
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float {
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int {
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	public static function load():Void {
		DataSaver.loadData(DataSaver.saveFile);
		if (DataSaver.weekScores != null) {
			weekScores = DataSaver.weekScores;
		}
		if (DataSaver.songScores != null) {
			songScores = DataSaver.songScores;
		}
		if (DataSaver.songRating != null) {
			songRating = DataSaver.songRating;
		}
	}
}
