extends Weapon
class_name EmptyGun

func _init():
	names = ["Empty Gun", "Empty Gun", "Empty Gun"]
	attack = 12
	reticles = 4
	attack_eye = load("res://objects/battle/attack_eye/attack_eye.tscn")
	attack_animation = load("res://objects/items/gun.tscn")

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the Empty Gun.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the Empty Gun.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Empty Gun\" - Weapon AT 12\n* An antique revolver.(delay:0.5)\n* It has no ammo.(pc)* Must be used precisely, or\n  damage will be low.(pc)"
