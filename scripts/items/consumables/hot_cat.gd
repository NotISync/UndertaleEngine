extends Consumable
class_name HotCat

func _init():
	names = ["Hot Cat", "Hot Cat", "Hot Cat"]
	heals = [21,21,21]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Hot Cat.\n" + str(hp_message(21)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Hot Cat\" Heals 21 HP\n* Like a hot dog,(delay:0.5) but with\n  little cat ears on the end.(pc)"
