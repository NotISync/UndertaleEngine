extends Consumable
class_name HotDog

func _init():
	names = ["Hot Dog...?", "Hot Dog", "Hot Dog"]
	heals = [20,20,20]
	sound_heal = "menu/snd_dogsalad"

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Hot Dog...?\n" + str(hp_message(20)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Hot Dog...?\" Heals 20 HP\n* The \"meat\" is made of something\n  called a \"water sausage.\" (pc)"
