extends Consumable
class_name PopatoChisps

func _init():
	names = ["Popato Chisps", "PT Chisps", "Chips"]
	heals = [13,13,13]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Popato Chisps.\n" + str(hp_message(13)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Popato Chisps\" Heals 13 HP\n* Regular old popato chisps.(pc)"
