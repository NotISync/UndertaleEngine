extends Armor
class_name Bandage

var heals = [10, 10, 10]

func _init():
	names = ["Bandage","Bandage","Bandage"]

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		vars.main_writer.writer_text = get_use_text()
		audio.play("menu/heal")
		settings.player_save.inventory[inventory_slot] = ""
		var amount_gained = heals[1] if !vars.hud_manager.serious_mode else heals[2]
		set_hp(amount_gained)
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		vars.main_writer.writer_text = get_use_text()
		audio.play("menu/heal")
		settings.player_save.inventory[inventory_slot] = ""
		var amount_gained = heals[0]
		set_hp(amount_gained)
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()

func set_hp(amount_gained : int):
	settings.player_save.player.current_kr = min(settings.player_save.player.current_kr - amount_gained, settings.player_save.player.max_hp - settings.player_save.player.current_hp)
	settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + amount_gained, settings.player_save.player.max_hp)
	
func get_use_text() -> String:
	if(is_instance_valid(vars.hud_manager)):
		if(!vars.hud_manager.serious_mode):
			return "(enable:z)(enable:x)(sound:mono2)* You re-applied the bandage.\n* Still kind of gooey.(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* You re-applied the bandage.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Bandage\" - Heals 10 HP\n* It has already been used\n  several times.(pc)"
