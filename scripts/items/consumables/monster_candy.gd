extends Consumable
class_name MonsterCandy

func _init():
	names = ["Monster Candy", "MnstrCndy", "MnstrCndy"]
	heals = [10,10,10]

func get_use_text() -> String:
	if(!vars.hud_manager.serious_mode):
		var randomtext = round(randf_range(0, 15))
		if(randomtext <= 2):
			return "(enable:z)(enable:x)(sound:mono2)* You ate the Monster Candy.\n* Very un-licorice-like.\n" + str(hp_message(10)) + "(pc)"
		if(randomtext == 15):
			return "(enable:z)(enable:x)(sound:mono2)* You ate the Monster Candy.\n* ... tastes like licorice.\n" + str(hp_message(10)) + "(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Monster Candy.\n" + str(hp_message(10)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Monster Candy\" - Heals 10 HP\n* Has a distinct,(delay:0.5)\n  non-licorice flavor.(pc)"
