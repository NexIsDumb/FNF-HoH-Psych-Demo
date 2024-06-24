package overworld;

enum abstract CharmId(Int) {
	var MELODIC_SHELL;
	var BALDURS_BLESSING;
	var LIFEBLOOD_SEED;
	var CRITICAL_FOCUS;
}

@:structInit
class Charm {
	public var id:CharmId;
	public var str_id:String;
	public var name:String;
	public var description:String;
	public var cost:Int;

	public function isEquipped():Bool {
		return DataSaver.equippedCharms.contains(str_id);
	}

	public function isUnlocked():Bool {
		return DataSaver.unlockedCharms.exists(str_id) && DataSaver.unlockedCharms.exists(str_id) == true;
	}

	public function equip() {
		if (!DataSaver.equippedCharms.contains(str_id))
			DataSaver.equippedCharms.push(str_id);
	}

	public function unequip() {
		if (DataSaver.equippedCharms.contains(str_id))
			DataSaver.equippedCharms.remove(str_id);
	}

	public function setEquipped(v:Bool):Bool {
		if (v) {
			equip();
		} else {
			unequip();
		}
		return v;
	}

	public function toString() {
		return "Charm(" + id + ", " + (isEquipped() ? "Equipped" : "Not Equipped") + ")";
	}
}

class Charms {
	public static final charms:Array<Charm> = [
		{
			id: CharmId.MELODIC_SHELL,
			str_id: "melodic_shell",
			name: "Melodic Shell",
			description: "Tuneful charm created for those who wish to chant, Grants its bearer the ability to sing in return rewarding them soul.",
			cost: 0
		},
		{
			id: CharmId.BALDURS_BLESSING,
			str_id: "baldurs_blessing",
			name: "Baldur's Blessing",
			description: "Protects its bearer with a hard shell when met with certain death. The shell is not indestructible and will shatter after one use.",
			cost: 3
		},
		{
			id: CharmId.LIFEBLOOD_SEED,
			str_id: "lifeblood_seed",
			name: "Lifeblood Seed",
			description: "Contains a living core that drips precious lifeblood. When resting, the bearer will gain a coating of lifeblood that protects from a modest amount of damage.",
			cost: 2
		},
		{
			id: CharmId.CRITICAL_FOCUS,
			str_id: "critical_focus",
			name: "Critical Focus",
			description: "A Shaman artifact that was long forgotten. As a result crystals began to form on it, amplifying its abilities. While the bearer is below half of their current health, they are granted additional soul when striking enemies.",
			cost: 2
		},
	];

	public static var charmMap(get, null):Map<String, Charm> = null;

	private static function get_charmMap():Map<String, Charm> {
		if (charmMap == null) {
			charmMap = new Map<String, Charm>();
			for (charm in charms) {
				charmMap.set(charm.str_id, charm);
			}
		}
		return charmMap;
	}

	public static function getCharm(charm:CharmId) {
		for (c in charms) {
			if (c.id == charm) {
				return c;
			}
		}
		return null;
	}

	public static function isCharmEquipped(charm:CharmId) {
		for (c in charms) {
			if (c.id == charm) {
				return c.isEquipped();
			}
		}
		return false;
	}

	public static function isCharmUnlocked(charm:CharmId) {
		for (c in charms) {
			if (c.id == charm) {
				return c.isUnlocked();
			}
		}
		return false;
	}
}
