extends Consumable
class_name SeaTea

func _init():
	names = ["Sea Tea", "Sea Tea", "Sea Tea"]
	heals = [10,10,10]
	sound_heal = "menu/snd_speedup"

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		vars.player_heart.speed_buff = min(vars.player_heart.speed_buff + 0.5, 2.0)
		settings.player_save.inventory[inventory_slot] = ""
		var amount_gained = heals[1] if !vars.hud_manager.serious_mode else heals[2]
		set_hp(amount_gained+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		ut_items.sort_inventory()
		await swallowing.finished
		if(!vars.hud_manager.serious_mode):
			audio.play(sound_heal)
		else:
			audio.play("menu/heal")
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		var amount_gained = heals[0]
		set_hp(amount_gained+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()
		
func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You drink the Sea Tea.\n" + str(hp_message(10)) + "\n* Your SPEED boosts!(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You drink the Sea Tea.\n" + str(hp_message(10)) + "\n* Your SPEED boosts!(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Sea Tea\" Heals 10 HP\n* Made from glowing marshwater.\n* Increases SPEED for one battle.(pc)"
