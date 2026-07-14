extends Consumable
class_name HushPuppy

func _init():
	names = ["Hush Puppy", "HushPupe", "HushPuppy"]
	heals = [65,65,65]

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You eat the Hush Puppy.\n" + str(hp_message(65)) + "(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Hush Puppy.\n* Dog-magic is neutralized.\n" + str(hp_message(65)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Hush Puppy\" Heals 65 HP\n* This wonderful spell will stop\n  a dog from casting magic.(pc)"
