extends Miscellaneous
class_name DogResidue

var id = 0

func _init(type := 0):
	id = type
	names = ["Dog Residue", "DogResidu", "D.Residue"]

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		var item = audio.play("menu/item")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		ut_items.sort_inventory()
		if(settings.player_save.get_inventory_size() < 7):
			for i in len(settings.player_save.inventory):
				if(settings.player_save.inventory[i] == ""):
					match(randi_range(0, 6)):
						0:
							settings.player_save.inventory[i] = "dog_salad"
						_:
							settings.player_save.inventory[i] = "dog_residue_" + str(randi_range(0, 5))
		ut_items.sort_inventory()
		await item.finished
		audio.play("menu/snd_dogresidue")
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		var item = audio.play("menu/item")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		ut_items.sort_inventory()
		if(settings.player_save.get_inventory_size() < 7):
			for i in len(settings.player_save.inventory):
				if(settings.player_save.inventory[i] == ""):
					match(randi_range(0, 6)):
						0:
							settings.player_save.inventory[i] = "dog_salad"
						_:
							settings.player_save.inventory[i] = "dog_residue_" + str(randi_range(0, 5))
		ut_items.sort_inventory()
		await item.finished
		audio.play("menu/snd_dogresidue")
		await vars.main_writer.done
		done.emit()

func get_use_text() -> String:
	if(settings.player_save.get_inventory_size() > 7):
		return "(enable:z)(enable:x)(sound:mono2)* You used the Dog Residue.(pc)* ...(pc)* You finished using it.(pc)* An uneasy atmosphere fills\n  the room.(pc)"
	else:
		return "(enable:z)(enable:x)(sound:mono2)* You used the Dog Residue.(pc)* The rest of your inventory\n  filled up with Dog Residue.(pc)"

func get_info_text() -> String:
	match(id):
		0:
			return "(enable:z)(enable:x)(sound:mono2)* \"Dog Residue\" - Dog Item\n* Shiny trail left\n  behind by a dog.(pc)"
		1:
			return "(enable:z)(enable:x)(sound:mono2)* \"Dog Residue\" - Dog Item\n* Dog-shaped husk shed\n  from a dog\'s carapace.(pc)"
		2:
			return "(enable:z)(enable:x)(sound:mono2)* \"Dog Residue\" - Dog Item\n* Dirty dishes left\n  unwashed by a dog.(pc)"
		3:
			return "(enable:z)(enable:x)(sound:mono2)* \"Dog Residue\" - Dog Item\n* Glowing crystals secreted\n  by a dog.(pc)"
		4:
			return "(enable:z)(enable:x)(sound:mono2)* \"Dog Residue\" - Dog Item\n* Jigsaw puzzle left\n  unfinished by a dog.(pc)"
		5:
			return "(enable:z)(enable:x)(sound:mono2)* \"Dog Residue\" - Dog Item\n* Web spun by a dog\n  to ensnare prey.(pc)"
		_:
			return "(enable:z)(enable:x)(sound:mono2)* Error!(pc)"
