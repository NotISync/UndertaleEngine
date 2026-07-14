extends Consumable
class_name StoicOnion

func _init():
	names = ["Stoic Onion", "StocOnoin", "Onion"]
	heals = [5,5,5]

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			var randomtext = round(randf_range(0, 9))
			if(randomtext > 8):
				return "(enable:z)(enable:x)(sound:mono2)* You ate the Stoic Onion.\n* You didn't cry...\n" + str(hp_message(5)) + "(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Stoic Onion.\n" + str(hp_message(5)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Stoic Onion\" - Heals 5 HP\n* Even eating it raw,(delay:0.5) the\n  tears just won't come.(pc)"
