extends Consumable
class_name TemmieFlakes

func _init():
	names = ["Temmie Flakes", "TemFlakes", "TemFlakes"]
	heals = [2,2,2]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Temmie Flakes.\n" + str(hp_message(2)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Temmie Flakes\" - Heals 2 HP\n* It's just torn up pieces\n  of colored construction paper.(pc)"
