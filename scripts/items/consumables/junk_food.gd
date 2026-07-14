extends Consumable
class_name JunkFood

func _init():
	names = ["Junk Food", "Junk Food", "Junk Food"]
	heals = [17,17,17]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Junk Food.\n" + str(hp_message(17)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Junk Food\" Heals 17 HP\n* Food that was probably\n  once thrown away.(pc)"
