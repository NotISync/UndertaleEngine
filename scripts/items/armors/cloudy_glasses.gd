extends Armor
class_name CloudyGlasses

func _init():
	names = ["Butty Glasses","ClodGlass","Glasses"]
	defense = 5
	inv = 9

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the glasses.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the glasses.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Cloudy Glasses\" - Armor DF 6\n* Glasses marred with wear.\n* Increases INV by 9.(pc)* (lp)After you get hurt by an\n  attack,(delay:0.5) you stay invulnerable\n  for longer.(rp)(pc)"
