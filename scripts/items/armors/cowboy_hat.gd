extends Armor
class_name CowboyHat

func _init():
	names = ["Cowboy Hat","CowboyHat","CowboyHat"]
	defense = 12
	attack = 5

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the Cowboy Hat.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the Cowboy Hat.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Cowboy Hat\" - Armor DF 12\n* This battle-worn hat makes you\n  want to grow a beard.(pc)* It also raises ATTACK by 5.(pc)"
