extends Consumable
class_name ButterscotchPie

func _init():
	names = ["Butterscotch Pie", "ButtsPie", "Pie"]

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		var amount_gained = settings.player_save.player.max_hp if !vars.hud_manager.serious_mode else settings.player_save.player.max_hp
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
		var amount_gained = settings.player_save.player.max_hp
		set_hp(amount_gained+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()
		
func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You ate the Butterscotch Pie.(delay:0.5)\n* Your HP was maxed out.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Butterscotch Pie.(delay:0.5)\n* Your HP was maxed out.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Butterscotch Pie\" - All HP\n* Butterscotch-cinnamon\n  pie,(delay:0.5) one slice.(pc)"
