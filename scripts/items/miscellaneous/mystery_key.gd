extends Miscellaneous
class_name MysteryKey

func _init():
	names = ["Mystery Key", "MystryKey", "Key"]

func use(inventory_slot : int):
	audio.play("menu/item")
	vars.main_writer.writer_text = get_use_text()
	settings.player_save.inventory[inventory_slot] = ""
	ut_items.sort_inventory()
	await vars.main_writer.done
	done.emit()
	
func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You used the Mystery Key.(delay:0.5)\n* But nothing happened.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Mystery Key\" Unique\n* It is too bent to fit on\n  your keychain.(pc)"
