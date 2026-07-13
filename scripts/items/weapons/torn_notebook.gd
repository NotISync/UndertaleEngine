extends Weapon
class_name TornNotebook

func _init():
	names = ["Torn Notebook", "TornNotbo", "Notebook"]
	attack = 2
	inv = 6
	reticles = 2
	attack_eye = load("res://objects/battle/attack_eye/attack_eye.tscn")
	attack_animation = load("res://objects/items/notebook.tscn")

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the Torn Notebook.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the Torn Notebook.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Torn Notebook\" - Weapon AT 2\n* Contains illegible scrawls.\n* Increases INV by 6.(pc)* (lp)After you get hurt by an\n  attack,(delay:0.5) you stay invulnerable\n  for longer.(rp)(pc)"
