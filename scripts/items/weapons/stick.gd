extends Weapon
class_name Stick

func _init():
	names = ["Stick", "Stick", "Stick"]
	attack = 0
	attack_eye = load("res://objects/battle/attack_eye/attack_eye.tscn")
	attack_animation = load("res://objects/items/slice.tscn")

func use(inventory_slot : int):
	vars.main_writer.writer_text = get_use_text()
	await vars.main_writer.done
	done.emit()

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You threw the stick away.(delay:0.5)\n* Then picked it back up.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You threw the stick away.(delay:0.5)\n* Then picked it back up.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Stick\" - Weapon AT 0\n* Its bark is worse than\n  its bite.(pc)"
