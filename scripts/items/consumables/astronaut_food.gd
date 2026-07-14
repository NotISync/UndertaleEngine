extends Consumable
class_name AstronautFood

func _init():
	names = ["Astronaut Food", "AstroFood", "Astr.Food"]
	heals = [21,21,21]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Astronaut Food.\n" + str(hp_message(21)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Astronaut Food\" Heals 21 HP\n* For feeding a pet\n  astronaut.(pc)"
