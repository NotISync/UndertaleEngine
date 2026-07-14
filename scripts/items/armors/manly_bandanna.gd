extends Armor
class_name ManlyBandanna

func _init():
	names = ["Manly Bandanna","Mandanna","Bandanna"]
	defense = 7

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped Manly Bandanna.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped Manly Bandanna.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Manly Bandanna\" - Armor DF 7\n* It has seen some wear.\n* It has abs drawn on it.(pc)"
