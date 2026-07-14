extends Consumable
class_name FaceSteak

func _init():
	names = ["Face Steak", "FaceSteak", "Steak"]
	match(settings.player_save.player.name.to_lower()):
		"drak", "gigi", "gugu": names[1] = "Fsteak"
	heals = [60,60,60]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Face Steak.\n" + str(hp_message(60)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Face Steak\" Heals 60 HP\n* Huge steak in the shape\n  of Mettaton's face.(pc)* (lp)You don't feel like it's\n  made of real meat...(rp)"
