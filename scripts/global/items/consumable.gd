extends Item
class_name Consumable

var heals : Array
var sound_heal := "menu/heal"

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		var amount_gained = heals[1] if !vars.hud_manager.serious_mode else heals[2]
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
		var amount_gained = heals[0]
		set_hp(amount_gained+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()

func info(inventory_slot : int):
	vars.main_writer.writer_text = get_info_text()
	await vars.main_writer.done
	done.emit()

func drop(inventory_slot : int):
	vars.main_writer.writer_text = get_throw_away_text()
	settings.player_save.inventory[inventory_slot] = ""
	await vars.main_writer.done
	ut_items.sort_inventory()
	done.emit()

func set_hp(amount_gained : int):
	settings.player_save.player.current_kr = max(settings.player_save.player.current_kr - amount_gained, 0)
	settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + amount_gained, settings.player_save.player.max_hp)
	#if(settings.player_save.player.current_hp+amount_gained-settings.player_save.player.current_kr > settings.player_save.player.max_hp):
		#settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + amount_gained, settings.player_save.player.max_hp)
		#settings.player_save.player.current_kr = 0
		#return
	#else:
		#if(amount_gained-settings.player_save.player.current_kr > 0):
			#settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + amount_gained, settings.player_save.player.max_hp) - settings.player_save.player.current_kr
		#settings.player_save.player.current_kr = min(0, settings.player_save.player.current_kr - amount_gained)
		#return
	#if(settings.player_save.player.current_hp > settings.player_save.player.max_hp): return
	#if(settings.player_save.player.current_hp + settings.player_save.player.current_kr > settings.player_save.player.max_hp):
		#settings.player_save.player.current_kr = 0
		#return
	#settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + amount_gained, settings.player_save.player.max_hp) - settings.player_save.player.current_kr
