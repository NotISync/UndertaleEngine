extends Weapon
class_name WornDagger

func _init():
	names = ["Worn Dagger", "WornDG", "W. Dagger"]
	attack = 15
	attack_eye = load("res://objects/battle/attack_eye/attack_eye.tscn")
	attack_animation = load("res://objects/items/slice.tscn")

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the dagger.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the dagger.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Worn Dagger\" - Weapon AT 15\n* Perfect for cutting plants\n  and vines.(pc)"
