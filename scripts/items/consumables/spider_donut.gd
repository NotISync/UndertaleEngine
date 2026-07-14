extends Consumable
class_name SpiderDonut

func _init():
	names = ["Spider Donut", "SpidrDont", "SpdrDonut"]
	heals = [12,12,12]

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			var randomtext = ceil(randf_range(0, 10))
			if(randomtext > 9):
				return "(enable:z)(enable:x)(sound:mono2)* Don't worry(delay:0.5), Spider didn't.\n" + str(hp_message(12)) + "(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Spider Donut.\n" + str(hp_message(12)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Spider Donut\" - Heals 12 HP\n* A donut made with Spider\n  Cider in the batter.(pc)"
