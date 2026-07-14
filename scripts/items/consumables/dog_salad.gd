extends Consumable
class_name DogSalad

var random_heals = [30, 10, 2, 999]
var heal

func _init():
	names = ["Dog Salad", "Dog Salad", "Dog Salad"]
	sound_heal = "menu/snd_dogsalad"

func use(inventory_slot : int):
	heal = randi_range(0, 3)
	if(vars.scene is BattleRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		set_hp(random_heals[heal]+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		var swallowing = audio.play("menu/snd_swallow")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		set_hp(random_heals[heal]+settings.player_save.get_weapon().extra_heal+settings.player_save.get_armor().extra_heal)
		ut_items.sort_inventory()
		await swallowing.finished
		audio.play(sound_heal)
		await vars.main_writer.done
		done.emit()

func get_use_text() -> String:
	match(heal):
		0:
			return "(enable:z)(enable:x)(sound:mono2)* You eat the Dog Salad.(delay:0.5)\n* Oh.(delay:0.5) Tastes yappy...\n" + str(hp_message(30)) + "(pc)"
		1:
			return "(enable:z)(enable:x)(sound:mono2)* You eat the Dog Salad.(delay:0.5)\n* Oh.(delay:0.5) Fried tennis ball...\n" + str(hp_message(10)) + "(pc)"
		2:
			return "(enable:z)(enable:x)(sound:mono2)* You eat the Dog Salad.(delay:0.5)\n* Oh.(delay:0.5) There are bones...\n" + str(hp_message(2)) + "(pc)"
		3:
			return "(enable:z)(enable:x)(sound:mono2)* You eat the Dog Salad.(delay:0.5)\n* It's literally garbage???\n" + str(hp_message(999)) + "(pc)"
		_:
			return "(enable:z)(enable:x)(sound:mono2)* Error!(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Dog Salad\" - Heals ?? HP\n* Recovers HP.\n* (lp)Hit Poodles.(rp)(pc)"
