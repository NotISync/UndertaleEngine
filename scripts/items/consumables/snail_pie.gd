extends Consumable
class_name SnailPie

func _init():
	names = ["Snail Pie", "Snail Pie", "Snail Pie"]

func use(inventory_slot : int):
	var amount_gained = ((settings.player_save.player.max_hp - settings.player_save.player.current_hp) - 1) if(settings.player_save.player.current_hp < settings.player_save.player.max_hp - 1) else (settings.player_save.player.max_hp - settings.player_save.player.current_hp)
	if(vars.scene is BattleRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		set_hp(amount_gained+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		set_hp(amount_gained+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Snail Pie.(delay:0.5)\n* Your HP was maxed.(delay:0.5) Almost.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Snail Pie\" - Heals Some HP\n* An acquired taste.(pc)"
