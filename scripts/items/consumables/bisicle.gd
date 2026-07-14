extends Consumable
class_name Bisicle

func _init():
	names = ["Bisicle", "Bisicle", "Bisicle"]
	heals = [11,11,11]

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = "unisicle"
		var amount_gained = heals[1] if !vars.hud_manager.serious_mode else heals[2]
		set_hp(amount_gained+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = "unisicle"
		var amount_gained = heals[0]
		set_hp(amount_gained+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()
		
func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat one half of\n  the Bisicle.\n" + str(hp_message(11)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Bisicle\" - Heals 11 HP\n* It's a two-pronged popsicle,(delay:0.5)\n  so you can eat it twice.(pc)"
