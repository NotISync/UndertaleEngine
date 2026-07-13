extends Weapon
class_name ToyKnife

func _init():
	names = ["Toy Knife", "Toy Knife", "Toy Knife"]
	attack = 3
	attack_eye = load("res://objects/battle/attack_eye/attack_eye.tscn")
	attack_animation = load("res://objects/items/slice.tscn")

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped Toy Knife.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped Toy Knife.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)\"Toy Knife\" - Weapon AT 3\n* Made of plastic.\n* A rarity nowadays.(pc)"
