extends Consumable
class_name Unisicle

func _init():
	names = ["Unisicle", "Unisicle", "Popsicle"]
	heals = [11,11,11]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Unisicle.\n" + str(hp_message(11)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Unisicle\" - Heals 11 HP\n* It's a SINGLE-pronged popsicle.(delay:0.5)\n* Wait,(delay:0.5) that's just normal...(pc)"
