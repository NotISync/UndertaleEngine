extends Armor
class_name StainedApron

func _init():
	names = ["Stained Apron","StainApro","Apron"]
	defense = 11

func turn_effect():
	if(vars.attack_manager.turn_num % 2 == 1):
		audio.play("menu/heal")
		settings.player_save.player.current_kr = max(settings.player_save.player.current_kr - 1, 0)
		settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + 1, settings.player_save.player.max_hp)

func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You equipped the apron.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You equipped the apron.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Stained Apron\" - Armor DF 11\n* Heals 1 HP every other&  turn.(pc)"
