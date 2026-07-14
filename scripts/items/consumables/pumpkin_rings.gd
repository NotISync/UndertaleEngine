extends Consumable
class_name PumpkinRings

func _init():
	names = ["Pumpkin Rings", "PunkRings", "PmknRings"]
	heals = [8,8,8]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Pumpkin Rings.\n" + str(hp_message(8)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Pumpkin Rings\" - Heals 8 HP\n* A small pumpkin cooked\n  like onion rings.(pc)"
