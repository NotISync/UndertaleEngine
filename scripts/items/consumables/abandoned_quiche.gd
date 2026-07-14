extends Consumable
class_name AbandonedQuiche

func _init():
	names = ["Abandoned Quiche", "Ab Quiche", "Quiche"]
	heals = [34,34,34]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the quiche.\n" + str(hp_message(34)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Abandoned Quiche\" Heals 34 HP\n* A psychologically damaged\n  spinach egg pie.(pc)"
