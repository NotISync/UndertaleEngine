extends Consumable
class_name InstantNoodles

func _init():
	names = ["Instant Noodles", "InstaNood", "I.Noodles"]
	heals = [15,4,90]

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You eat the Instant Noodles.\n" + str(hp_message(4)) + "(pc)"
		else:
			return "(enable:z)(enable:x)(sound:mono2)* They're better dry.\n" + str(hp_message(90)) + "(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Instant Noodles.\n" + str(hp_message(15)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Instant Noodles\" Heals HP\n* Comes with everything you\n  need for a quick meal!(pc)"
