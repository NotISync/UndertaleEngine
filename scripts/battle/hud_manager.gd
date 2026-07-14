extends Node2D
class_name HudManager

var mode := 0
var button_collide := false #SCRAPPED IDEA
var heart_tween
var button_index := 0
var enemy_index := 0
var item_index := 0
var last_item_index := 0 #Used for checking if you didn't attack the enemy or something
var item_page := 1

var show_kr_text := false

var serious_mode := false

var enemy_health_bars := []
var longest_enemy_name := 0
var eye = null #Attack eye
var weapon = null

signal eye_created

@onready var marker = $player

@onready var display : Dictionary = {
	name_text = $display/name,
	lv_text = $display/lv,
	hp = $display/hp,
	kr = $display/kr,
	health_text = $display/health,
	health_bar = $display/hp_bar,
	max_health_bar = $display/hp_bar/mask/hp_bar_max,
	current_health_bar = $display/hp_bar/mask/hp_bar_max/hp_bar_current,
	karma_health_bar = $display/hp_bar/mask/hp_bar_max/hp_bar_karma,
	corner = $display/hp_bar/mask/corner,
	buttons = $buttons.get_children(),
	item_texts = [],
	page_text = null,
	}

func setup_hud():
	var create_text : Callable = func(position : Vector2):
		var textblock = RichTextLabel.new()
		textblock.bbcode_enabled = true
		textblock.add_theme_font_override("normal_font", load("res://assets/fonts/main_mono.ttf"))
		textblock.add_theme_font_size_override("normal_font_size", 32)
		textblock.set("theme_override_colors/font_outline_color", Color(0, 0, 0))
		#textblock.set("theme_override_constants/outline_size", 9)
		textblock.position = position - vars.battle_box.position
		textblock.size = Vector2(100,100)
		textblock.clip_contents = false
		textblock.scroll_active = false
		textblock.autowrap_mode = TextServer.AUTOWRAP_OFF
		vars.battle_box.add_child(textblock)
		return textblock
	
	for row in range(3):
		for col in range(2):
			var i = row * 2 + col
			var location : Vector2 = Vector2(100 if col < 1 else 340, 271 + row * 31)
			var text : RichTextLabel = create_text.call(location)
			display.item_texts.append(text)
	display.page_text = create_text.call(Vector2(388,334))
	
	display_update()
	
	display.lv_text.position = display.name_text.position + Vector2((len(display.name_text.get_parsed_text()) * 14) + 32,0)

func _process(delta):
	inputs()
	display_update()
	hud_mode_update()
	heart_update()

func display_update():
	display.name_text.text = settings.player_save.player.name
	display.lv_text.text = "LV " + str(settings.player_save.player.lv)
	display.health_text.text = (str(settings.player_save.player.current_hp + settings.player_save.player.current_kr) if (settings.player_save.player.current_hp + settings.player_save.player.current_kr >= 10 || settings.player_save.player.max_hp < 10) else "0" + str(settings.player_save.player.current_hp + settings.player_save.player.current_kr)) + " / " + str(settings.player_save.player.max_hp)
	display.health_text.self_modulate = Color(1,.14,1,1) if(settings.player_save.player.current_kr > 0) else Color.WHITE
	
	var min_health_bar_size = max(settings.player_save.player.max_hp, 20)
	display.max_health_bar.size = ceil(Vector2(min_health_bar_size * 1.2,21))
	var hp_fix_value = max(float(min_health_bar_size), settings.player_save.player.current_hp)/max(float(settings.player_save.player.max_hp)/float(settings.player_save.player.current_hp), 1)
	display.current_health_bar.size = ceil(Vector2(hp_fix_value * 1.2,21))
	var karma_value = max(float(min_health_bar_size), settings.player_save.player.current_hp + settings.player_save.player.current_kr)/max(float(settings.player_save.player.max_hp)/float(settings.player_save.player.current_hp + settings.player_save.player.current_kr), 1)
	display.karma_health_bar.size = ceil(Vector2(karma_value * 1.2,21))
	var bar = display.max_health_bar if (settings.player_save.player.current_hp + settings.player_save.player.current_kr < min_health_bar_size) else display.karma_health_bar
	display.corner.position = bar.position + Vector2(-2, -2)
	display.corner.size.x = bar.size.x + 4
	
	display.kr.visible = show_kr_text
	match(show_kr_text):
		true:
			display.hp.position = Vector2(-76,165) - round(Vector2(20,0))#global_position = Vector2(244,405)
			display.health_bar.position = display.hp.position + Vector2(31,-5)
			display.kr.position = display.health_bar.position + Vector2(bar.size.x,0) + Vector2(9,5)
			display.health_text.position = display.kr.position + Vector2(40,-5)
		false:
			display.hp.position = Vector2(-76,165)
			display.health_bar.position = display.hp.position + Vector2(31,-5)
			display.health_text.position = display.health_bar.position + Vector2(bar.size.x,0) + Vector2(15,0)

func hud_mode_update():
	for i in display.item_texts:
		i.text = ""
	display.page_text.text = ""
	display.page_text.visible = false
	for i in enemy_health_bars:
		if(is_instance_valid(i)):
			i.queue_free()
	match(mode):
		-1:
			for i in display.buttons:
				i.frame = 0
		0:
			for i in range(display.buttons.size()):
				if i != button_index:
					display.buttons[i].frame = 0
				else:
					display.buttons[i].frame = 1
		1:
			var enemies : Array = []
			for i in vars.enemies.get_children():
				enemies.append(len(i.enemy_name))
			for i in range(enemies.size()):
				if(enemies[i] >= longest_enemy_name): longest_enemy_name = enemies[i]
			for i in range(vars.enemies.get_children().size()):
				display.item_texts[i * 2].text = "* " + vars.enemies.get_child(i).enemy_name
				if(vars.enemies.get_child(i).can_spare): display.item_texts[i * 2].text = "[color=#FFFF00]" + display.item_texts[i * 2].text
				var button_ref = display.buttons[button_index]
				if(button_ref==get_node_or_null("buttons/fight")&&vars.enemies.get_child(i).show_health_bar):
					var buffer : BackBufferCopy = BackBufferCopy.new()
					var bar_smooth : NinePatchRect = NinePatchRect.new()
					var bar_max : ColorRect = ColorRect.new()
					var bar : ColorRect = ColorRect.new()
					var bar_size := 101
					bar_smooth.texture = load("res://assets/sprites/battle/hud/healthbar_outline.png")
					bar_smooth.self_modulate = Color(0, 0, 0)
					bar_smooth.patch_margin_left = 8
					bar_smooth.patch_margin_top = 8
					bar_smooth.patch_margin_right = 8
					bar_smooth.patch_margin_bottom = 8
					bar_smooth.material = ShaderMaterial.new()
					#bar_smooth.material.shader = load("res://assets/effects/mask.gdshader")
					bar_max.color = Color.RED
					bar_max.size = Vector2(bar_size, 20)
					bar.color = Color(.1,1,.1,1)
					bar.size = Vector2((float(vars.enemies.get_child(i).current_hp) / vars.enemies.get_child(i).max_hp) * bar_size, 20)
					bar_smooth.size = bar_max.size + Vector2(4, 4)
					bar_max.add_child(bar)
					buffer.add_child(bar_max)
					buffer.add_child(bar_smooth)
					add_child(buffer)
					#bar_max.global_position = display.item_texts[i * 2].global_position + Vector2(187, 8)
					#bar_max.global_position = display.item_texts[i * 2].global_position + Vector2(187 + ((16*(len(vars.enemies.get_child(i).enemy_name)-6))if(len(vars.enemies.get_child(i).enemy_name)>6)else(0)), 8)
					bar_max.global_position = display.item_texts[i * 2].global_position + Vector2(187 + ((16*(longest_enemy_name-6))if(longest_enemy_name>6)else(0)), 8)
					bar_smooth.global_position = bar_max.global_position - Vector2(2, 2)
					buffer.z_index = 1
					enemy_health_bars.append(buffer)
				
		2:
			var button_ref = display.buttons[button_index]
			if(button_ref == get_node_or_null("buttons/act")):
				for i in range(vars.enemies.get_child(enemy_index).act_options.keys().size()):
					display.item_texts[i].text = "* " + vars.enemies.get_child(enemy_index).act_options.keys()[i]
			if(button_ref == get_node_or_null("buttons/item")):
				for i in range(4):
					if(settings.player_save.inventory[i + (item_page - 1) * 4] != ""):
						var item = ut_items.items[settings.player_save.inventory[i + (item_page - 1) * 4]]
						display.item_texts[i].text = "* " + item.names[1] if !serious_mode else "* " + item.names[2]
				if(settings.player_save.inventory[4] != ""):
					display.page_text.visible = true
					display.page_text.text = "PAGE " + str(item_page)
				else:
					display.page_text.visible = false
			if(button_ref == get_node_or_null("buttons/mercy")):
				display.item_texts[0].text = "* Spare"
				display.item_texts[1].text = " "
				display.item_texts[3].text = " "
				if(vars.scene.flee):
					display.item_texts[2].text = "* Flee"
				for i in range(vars.enemies.get_children().size()):
					if(vars.enemies.get_child(i).can_spare): display.item_texts[0].text = "[color=#FFFF00]" + display.item_texts[0].text

func heart_update() -> void:
	match(mode):
		0:
			marker.reparent(vars.hud_manager)
			if(button_collide):
				if(heart_tween): heart_tween.kill()
				heart_tween = create_tween()
				heart_tween.tween_property(marker, "position", display.buttons[button_index].position + Vector2(-39, 0), .5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			else:
				marker.position = display.buttons[button_index].position + Vector2(-39, 0)
			vars.player_heart.global_position = marker.global_position
		1:
			marker.reparent(vars.battle_box)
			if(button_collide):
				if(heart_tween): heart_tween.kill()
				heart_tween = create_tween()
				heart_tween.tween_property(marker, "position", display.item_texts[enemy_index * 2].position + Vector2(-28, 17), .5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			else:
				marker.position = display.item_texts[enemy_index * 2].position + Vector2(-28, 17)
			vars.player_heart.global_position = marker.global_position
		2:
			marker.reparent(vars.battle_box)
			if(button_collide):
				if(heart_tween): heart_tween.kill()
				heart_tween = create_tween()
				heart_tween.tween_property(marker, "position", display.item_texts[item_index].position + Vector2(-28, 17), .5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			else:
				marker.position = display.item_texts[item_index].position + Vector2(-28, 17)
			vars.player_heart.global_position = marker.global_position

func inputs():
	match(mode):
		-1:
			return
		0:
			var button_ref = display.buttons[button_index]
			if(button_collide):
				for i in display.buttons:
					for j in i.get_node("hitbox").get_overlapping_areas():
						if(j.owner is PlayerHeart):
							button_ref = i
			if (Input.is_action_just_pressed("confirm")):
				audio.play("menu/menu_select")
				if(button_ref != get_node_or_null("buttons/item")):
					vars.main_writer.writer_text = ""
					enemy_index = 0
					mode = 1 if(button_ref in [get_node_or_null("buttons/fight"),get_node_or_null("buttons/act")]) else 2
				else:
					if(settings.player_save.inventory[0] != ""):
						vars.main_writer.writer_text = ""
						enemy_index = 0
						mode = 1 if(button_ref in [get_node_or_null("buttons/fight"),get_node_or_null("buttons/act")]) else 2
				item_index = 0
				item_page = 1
				return
			if(Input.is_action_just_pressed("right")):
				audio.play("menu/menu_move")
				button_index = wrapi(button_index + 1, 0, display.buttons.size())
			if(Input.is_action_just_pressed("left")):
				audio.play("menu/menu_move")
				button_index = wrapi(button_index - 1, 0, display.buttons.size())
	var button_ref = display.buttons[button_index]
	var last_button_ref = button_ref
	if(button_collide):
		for i in display.buttons:
			for j in i.get_node("hitbox").get_overlapping_areas():
				if(j.owner is PlayerHeart):
					button_ref = i
	if(button_ref == get_node_or_null("buttons/fight")):
		match(mode):
			1:
				var enemy_array : Array = vars.enemies.get_children()
				if(Input.is_action_just_pressed("up")):
					if(enemy_array.size() > 1):
						audio.play("menu/menu_move")
					enemy_index = wrapi(enemy_index - 1,0,enemy_array.size())
				if(Input.is_action_just_pressed("down")):
					if(enemy_array.size() > 1):
						audio.play("menu/menu_move")
					enemy_index = wrapi(enemy_index + 1,0,enemy_array.size())
				if(Input.is_action_just_pressed("exit")):
					reset(0)
				elif(Input.is_action_just_pressed("confirm")):
					fight()
	if(button_ref == get_node_or_null("buttons/act")):
		match(mode):
			1:
				var enemy_array : Array = vars.enemies.get_children()
				if(Input.is_action_just_pressed("up")):
					if(enemy_array.size() > 1):
						audio.play("menu/menu_move")
					enemy_index = wrapi(enemy_index - 1,0,enemy_array.size())
				if(Input.is_action_just_pressed("down")):
					if(enemy_array.size() > 1):
						audio.play("menu/menu_move")
					enemy_index = wrapi(enemy_index + 1,0,enemy_array.size())
				if(Input.is_action_just_pressed("exit")):
					reset(0)
				elif(Input.is_action_just_pressed("confirm")):
					audio.play("menu/menu_select")
					mode = 2
			2:
				var last_string_index = func() -> int:
					for i in range(display.item_texts.size()):
						if(display.item_texts[i].text == ""):
							return i
					return display.item_texts.size()
				if(last_string_index.call()>2):
					if(Input.is_action_just_pressed("up")||Input.is_action_just_pressed("down")):
							audio.play("menu/menu_move")
				if(last_string_index.call()>1):
					if(Input.is_action_just_pressed("right")||Input.is_action_just_pressed("left")):
						audio.play("menu/menu_move")
				if(Input.is_action_just_pressed("right")):
					if((item_index + 1) % 2 != 0):
						if(item_index + 1 < last_string_index.call()):
							item_index += 1
					else:
						item_index -= 1
				if(Input.is_action_just_pressed("left")):
					if((item_index + 1) % 2 == 0):
						if(item_index - 1 < last_string_index.call()):
							item_index -= 1
					elif(item_index + 1 < last_string_index.call()):
						item_index += 1
				if(Input.is_action_just_pressed("up")):
					if(item_index - 2 < 0):
						if(5 - (item_index + 1) % 2 < last_string_index.call()):
							item_index = 5 - (item_index + 1) % 2
					else:
						item_index -= 2
				if(Input.is_action_just_pressed("down")):
					if(item_index + 2 >= last_string_index.call()):
						item_index = -1 - (item_index + 1) % 2
					item_index += 2
				if(Input.is_action_just_pressed("exit")):
					mode = 1
				elif(Input.is_action_just_pressed("confirm")):
					check()
	if(button_ref == get_node_or_null("buttons/item")):
		match(mode):
			2: 
				var last_string_index = func() -> int:
					for i in range(display.item_texts.size()):
						if(display.item_texts[i].text == ""):
							return i
					return display.item_texts.size() - 1
				if(last_string_index.call()>2):
					if(Input.is_action_just_pressed("up")||Input.is_action_just_pressed("down")):
							audio.play("menu/menu_move")
				if(last_string_index.call()>1):
					if(Input.is_action_just_pressed("right")||Input.is_action_just_pressed("left")):
						audio.play("menu/menu_move")
				if(Input.is_action_just_pressed("right")):
					if((item_index + 1) % 2 != 0):
						if(item_index + 1 < last_string_index.call()):
							item_index += 1
					else:
						if(settings.player_save.inventory[4] != "" && item_page == 1):
							item_index -= 1
							item_page = 2
							if(settings.player_save.inventory[6] == "" && item_index == 2):
								item_index = 0
						else:
							item_index -= 1
				if(Input.is_action_just_pressed("left")):
					if((item_index + 1) % 2 == 0):
						if(item_index - 1 < last_string_index.call()):
							item_index -= 1
					else:
						if(settings.player_save.inventory[4] != "" && item_page == 2):
							item_index += 1
							item_page = 1
						else:
							if(item_index + 1 < last_string_index.call()):
								item_index += 1
				if(Input.is_action_just_pressed("up")):
					if(item_index - 2 < 0):
						if(3 - (item_index + 1) % 2 < last_string_index.call()):
							item_index = 3 - (item_index + 1) % 2
					else:
						item_index -= 2
				if(Input.is_action_just_pressed("down")):
					if(item_index + 2 >= last_string_index.call()):
						item_index = -1 - (item_index + 1) % 2
					item_index += 2
				if(Input.is_action_just_pressed("exit")):
					reset(0)
				elif(Input.is_action_just_pressed("confirm")):
					use(item_index + (item_page - 1) * 4)
	if(button_ref == get_node_or_null("buttons/mercy")):
		match(mode):
			2: 
				if(vars.scene.flee):
					var last_string_index = func() -> int:
						for i in range(display.item_texts.size()):
							if(display.item_texts[i].text == ""):
								return i
						return display.item_texts.size() - 1
					if(Input.is_action_just_pressed("up")):
						audio.play("menu/menu_move")
						if(item_index - 2 < 0):
							if(3 - (item_index + 1) % 2 < last_string_index.call()):
								item_index = 3 - (item_index + 1) % 2
						else:
							item_index -= 2
					if(Input.is_action_just_pressed("down")):
						audio.play("menu/menu_move")
						if(item_index + 2 >= last_string_index.call()):
							item_index = -1 - (item_index + 1) % 2
						item_index += 2
				if(Input.is_action_just_pressed("exit")):
					reset(0)
				elif(Input.is_action_just_pressed("confirm")):
					mercy(item_index)

func reset(m : int = -1):
	vars.player_heart.visible = false
	vars.player_heart.change_heart_color()
	mode = m
	item_index = 0
	vars.battle_box.reset_box_size()
	vars.player_heart.global_position = display.buttons[button_index].global_position + Vector2(-39, 0)
	vars.player_heart.input_enabled = false
	if vars.battle_box.margin != vars.battle_box.target:
		await vars.battle_box.resize_finished
	await get_tree().process_frame
	mode = 0
	vars.player_heart.visible = true
	vars.attack_manager.set_writer_text()

func disable():
	mode = -1
	last_item_index = item_index
	item_index = 0
	vars.player_heart.visible = false
	vars.player_heart.global_position = display.buttons[button_index].global_position + Vector2(-39, 0)
	vars.player_heart.input_enabled = false

# ACTIONS WHEN PRESSING CONFIRM
# ... So you can override them.

func fight():
	audio.play("menu/menu_select")
	disable()
	eye = ut_items.items[settings.player_save.player.weapon].attack_eye.instantiate()
	eye.enemy = vars.enemies.get_child(enemy_index)
	weapon = ut_items.items[settings.player_save.player.weapon].attack_animation.instantiate()
	weapon.enemy = eye.enemy
	weapon.z_index = 1
	eye.weapon = weapon
	vars.battle_box.add_child(eye)
	vars.scene.add_child(weapon)
	await get_tree().process_frame
	eye_created.emit()

func check():
	audio.play("menu/menu_select")
	vars.enemies.get_child(enemy_index).act_options.values()[item_index].call()

func use(item_index : int):
	audio.play("menu/menu_select")
	var item = settings.player_save.get_item(item_index)
	disable()
	item.use(item_index)
	await item.done
	var attack = vars.attack_manager.pre_heal_attack()
	if vars.battle_box.margin != vars.battle_box.target:
		await vars.battle_box.resize_finished
	attack.start_attack()

func mercy(item_index : int):
	audio.play("menu/menu_select")
	if(vars.enemies.get_child(enemy_index).can_spare):
		vars.enemies.get_child(enemy_index).spare()
		return
	if(item_index == 2):
		vars.scene.escape()
		return
	disable()
	vars.scene.mercy += 1
	var attack = vars.attack_manager.pre_heal_attack()
	if vars.battle_box.margin != vars.battle_box.target:
		await vars.battle_box.resize_finished
	attack.start_attack()
