extends Consumable
class_name Glamburger

func _init():
	names = ["Glamburger", "GlamBurg", "G. Burger"]
	heals = [27,27,27]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Glamburger.\n" + str(hp_message(27)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Glamburger\" Heals 27 HP\n* A hamburger made of edible\n  glitter and sequins.(pc)"
