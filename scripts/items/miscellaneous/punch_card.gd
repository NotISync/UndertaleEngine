extends Miscellaneous
class_name PunchCard

func _init():
	names = ["Punch Card", "PunchCard", "PunchCard"]

func use(inventory_slot : int):
	if(vars.scene is BattleRoom):
		audio.play("menu/snd_tearcard")
		vars.main_writer.writer_text = get_use_text()
		settings.player_save.inventory[inventory_slot] = ""
		ut_items.sort_inventory()
		await vars.main_writer.done
		done.emit()
	elif(vars.scene is OverworldRoom):
		done.emit()
		vars.overworld_hud.mode = -2
		vars.overworld_hud.visible = false
		vars.player_character.input_enabled = false
		var card = Sprite2D.new()
		card.texture = load("res://assets/sprites/overworld/objects/punch_card.png")
		card.scale = Vector2(2, 2)
		card.position = Vector2(320, 240)
		vars.overworld_hud.punch_card = card
		vars.scene.get_node("overworld_canvas").add_child(card)

func get_use_text() -> String:
	if(settings.player_save.player.weapon=="tough_glove"):
		var add = 6
		if(settings.player_save.player.atk > 18): add= 5
		if(settings.player_save.player.atk > 23): add= 4
		if(settings.player_save.player.atk > 26): add= 3
		if(settings.player_save.player.atk > 28): add= 2
		if(is_instance_valid(vars.player_heart)):
			vars.player_heart.attack_buff += add
		return "(enable:z)(enable:x)(sound:mono2)* OOOORAAAAA!!!(delay:0.5)\n* You rip up the punch card!(pc)* Your hands are burning!(delay:0.5)\n* AT increased by " + str(add) + "!(pc)"
	return "(enable:z)(enable:x)(sound:mono2)* OOOORAAAAA!!!(delay:0.5)\n* You rip up the punch card!(pc)* But nothing happened.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Punch Card\" - Battle Item\n* Use to make punching attacks\n  stronger in one battle.(pc)* Use outside of battle to\n  look at the card.(pc)"
