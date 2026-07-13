extends Weapon
class_name BurntPan

func _init():
	names = ["Burnt Pan", "BurntPan", "Pan"]
	attack = 10
	extra_heal = 4
	reticles = 4
	attack_eye = load("res://objects/battle/attack_eye/attack_eye.tscn")
	attack_animation = load("res://objects/items/pan.tscn")

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the Burnt Pan.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the Burnt Pan.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Burnt Pan\" - Weapon AT 10\n* Damage is rather consistent.\n* Consumable items heal 4 more HP.(pc)"
