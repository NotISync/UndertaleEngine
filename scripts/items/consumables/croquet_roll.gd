extends Consumable
class_name CroquetRoll

func _init():
	names = ["Croquet Roll", "CroqtRoll", "CroqtRoll"]
	heals = [15,15,15]

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You hit the Croquet Roll into\n  your mouth.\n" + str(hp_message(15)) + "(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Croquet Roll.\n" + str(hp_message(15)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Croquet Roll\" - Heals 15 HP\n* Fried dough traditionally\n  served with a mallet.(pc)"
