extends Consumable
class_name Starfait

func _init():
	names = ["Starfait", "Starfait", "Starfait"]
	heals = [14,14,14]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You drink the Starfait.\n" + str(hp_message(14)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Starfait\" Heals 14 HP\n* A sweet treat made of\n  sparkling stars.(pc)"
