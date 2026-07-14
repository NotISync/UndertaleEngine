extends Consumable
class_name LegendaryHero

func _init():
	names = ["Legendary Hero", "Leg,Hero", "L. Hero"]
	heals = [40,40,40]
	sound_heal = "menu/snd_hero"

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		vars.player_heart.attack_buff += 4
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
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Legendary Hero.\n" + str(hp_message(40)) + "\n* ATTACK increased by 4!(pc)"
	
func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Legendary Hero\" Heals 40 HP\n* Sandwich shaped like a sword.\n* Increases ATTACK when eaten.(pc)"
