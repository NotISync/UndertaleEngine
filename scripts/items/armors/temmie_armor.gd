extends Armor
class_name TemmieArmor

func _init():
	names = ["temy armor","Temmie AR","Tem.Armor"]
	defense = 20
	attack = 10
	inv = 6

func turn_effect():
	if(vars.attack_manager.turn_num % 2 == 1):
		audio.play("menu/heal")
		settings.player_save.player.current_kr = max(settings.player_save.player.current_kr - 1, 0)
		settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + 1, settings.player_save.player.max_hp)

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You donned the Temmie Armor.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You donned the Temmie Armor.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"temy armor\" - Armor DF 20\n* The things you can do with\n  a college education!(pc)* Raises ATTACK when worn.(delay:0.5)\n* Recovers HP every other turn.(delay:0.5)\n* INV up slightly.(pc)"
