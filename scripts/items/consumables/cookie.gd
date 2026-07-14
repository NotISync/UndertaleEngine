extends Consumable
class_name Cookie


func _init():
	names = ["Cookie", "Cookie", "Cookie"]
	heals = [8,8,8]

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You ate the Cookie.\n" + str(hp_message(8)) + "(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Cookie.\n" + str(hp_message(8)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Cookie\" - Heals 8 HP\n* Cookie pookie.(pc)"
