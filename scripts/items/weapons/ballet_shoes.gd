extends Weapon
class_name BalletShoes

func _init():
	names = ["Ballet Shoes", "BallShoes", "Shoes"]
	attack = 7
	reticles = 3
	attack_eye = load("res://objects/battle/attack_eye/attack_eye.tscn")
	attack_animation = load("res://objects/items/shoes.tscn")

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped Ballet Shoes.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped Ballet Shoes.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Ballet Shoes\" - Wpn AT 7\n* These used shoes make you\n  feel incredibly dangerous.(pc)"
