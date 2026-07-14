extends Armor
class_name FadedRibbon

func _init():
	names = ["Faded Ribbon","Ribbon","Ribbon"]
	defense = 3

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the ribbon.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the ribbon.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Faded Ribbon\" - Armor DF 3\n* If you\'re cuter,(delay:0.5) monsters\n  won't hit you as hard.(pc)"
