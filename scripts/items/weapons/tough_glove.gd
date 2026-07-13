extends Weapon
class_name ToughGlove

func _init():
	names = ["Tough Glove", "TuffGlove", "Glove"]
	attack = 5
	attack_eye = load("res://objects/battle/attack_eye/attack_eye.tscn")
	attack_animation = load("res://objects/items/glove.tscn")

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped Tough Glove.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped Tough Glove.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Tough Glove\" - Weapon AT 5\n* A worn pink leather glove.(delay:0.5)\n* For five-fingered folk.(pc)"
