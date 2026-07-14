extends Miscellaneous
class_name AnnoyingDog

func _init():
	names = ["Annoying Dog", "Annoy Dog", "Dog"]

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You deployed the dog.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Annoying Dog\" - Dog\n* A little white dog.(delay:0.5)\n* It\'s fast asleep...(pc)"
