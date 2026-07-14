extends Armor
class_name HeartLocket

func _init():
	names = ["Heart Locket","<--Locket","H. Locket"]
	defense = 15

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the locket.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the locket.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Heart Locket\" - Armor DF 15\n* It says \"Best Friends Forever.\"(pc)"
