package backend;

class Highscore {
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

		if (DataSaver.songScores.exists(daSong)) {
			if (DataSaver.songScores.get(daSong) < score) {
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

		if (DataSaver.weekScores.exists(daWeek)) {
			if (DataSaver.weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		} else
			setWeekScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void {
		DataSaver.songScores.set(song, score);
		DataSaver.saveSettings(DataSaver.saveFile);
	}

	static function setWeekScore(week:String, score:Int):Void {
		DataSaver.weekScores.set(week, score);
		DataSaver.saveSettings(DataSaver.saveFile);
	}

	static function setRating(song:String, rating:Float):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		DataSaver.songRating.set(song, rating);
		DataSaver.saveSettings(DataSaver.saveFile);
	}

	public static function formatSong(song:String, diff:Int):String {
		return Paths.formatPath(song) + Difficulty.getFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int {
		var daSong:String = formatSong(song, diff);
		trace("Getting score for " + daSong + " with " + DataSaver.songScores.get(daSong));
		if (!DataSaver.songScores.exists(daSong))
			return 0;

		return DataSaver.songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float {
		var daSong:String = formatSong(song, diff);
		// trace("Getting rating for " + daSong + " with " + DataSaver.songRating.get(daSong));
		if (!DataSaver.songRating.exists(daSong))
			return 0;

		return DataSaver.songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int {
		var daWeek:String = formatSong(week, diff);
		trace("Getting week score for " + daWeek + " with " + DataSaver.weekScores.get(daWeek));
		if (!DataSaver.weekScores.exists(daWeek))
			return 0;

		return DataSaver.weekScores.get(daWeek);
	}
}
