extends Item
class_name Miscellaneous

func use(inventory_slot : int):
	pass

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
