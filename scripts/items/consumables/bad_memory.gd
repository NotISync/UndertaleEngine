extends Consumable
class_name BadMemory

func _init():
	names = ["Bad Memory", "BadMemory", "BadMemory"]
	sound_heal = "battle/hurt"

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		settings.player_save.player.current_hp -= 1
		if(settings.player_save.player.current_hp <= 2):
			settings.player_save.player.current_hp = settings.player_save.player.max_hp;
			sound_heal = "menu/heal"
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		settings.player_save.player.current_hp -= 1
		if(settings.player_save.player.current_hp <= 2):
			settings.player_save.player.current_hp = settings.player_save.player.max_hp;
			sound_heal = "menu/heal"
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()

func get_use_text() -> String:
	if(settings.player_save.player.current_hp-1 <= 2):
		return "(enable:z)(enable:x)(sound:mono2)* You consume the Bad Memory.(delay:0.5)\n* Your HP was maxed out.(pc)"
	else:
		return "(enable:z)(enable:x)(sound:mono2)* You consume the Bad Memory.(delay:0.5)\n* You lost 1HP.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Bad Memory\" Hurts 1 HP\n* ?????(pc)"
