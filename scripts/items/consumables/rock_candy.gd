extends Consumable
class_name RockCandy

func _init():
	names = ["Rock Candy", "RockCandy", "RockCandy"]
	heals = [1,1,1]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Rock Candy.\n" + str(hp_message(1)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Rock Candy\" - Heals 1 HP\n* Here is a recipe to make\n  this at home:(pc)* 1. Find a rock(pc)"
