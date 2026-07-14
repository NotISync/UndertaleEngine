extends Armor
class_name OldTutu

func _init():
	names = ["Old Tutu","Old Tutu","Tutu"]
	defense = 10

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the Old Tutu.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the Old Tutu.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Old Tutu\" - Armor DF 10\n* Finally,(delay:0.5) a protective piece\n  of armor.(pc)"
