extends Attack

var a_vars : vars = vars

func _init():
	frames = INF

func pre_attack():
	super.pre_attack()
	a_vars.battle_box.insta_box_size([240,230,400,390])
	a_vars.player_heart.global_position = Vector2(320, 310)
	a_vars.enemies.get_node("sans").position.y = 146

func start_attack():
	super.start_attack()
	attack()

var jumped = false

func jump_check():
	for i in range(30):
		if(Input.is_action_pressed("up")):
			jumped = true
		await get_tree().process_frame

func attack():
	#a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").play("flash")
	a_vars.enemies.get_node("sans").slam("down")
	audio.play("battle/mus_sfx_segapower", audio.global_volume, 1.5)
	await get_tree().create_timer(.25, false).timeout
	jump_check()
	await get_tree().create_timer(.25, false).timeout
	#a_vars.attack_manager.warning(Vector2(250, 382-50), Vector2(140, 50), 0.5)
	a_vars.attack_manager.bone_stab(0, Vector2(248, 257), 138, 25, 15, 60, 180, true)#.warning.visible = false
	await get_tree().create_timer(4, false).timeout
	a_vars.enemies.get_node("sans").speech_bubble.visible = true
	if(jumped):
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 0
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)(speed:0.03333333)huh...(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 4
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)that's weird...(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)couldn't help notice\nyour jump.(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 2
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)...(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 5
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)why'd you jump?(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 4
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)seemed like you\nexpected something(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 2
		a_vars.enemies.get_node("sans").speech_writer.event.connect((func(): a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 0), 4)
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)which is weird\n(delay:0.5)(event)seeing how caught off\nguard you were(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 2
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)so...(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 1
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").set_base_font(load("res://assets/fonts/dialogue.ttf"))
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_glyph = 0
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_space = 0
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_bottom = 4
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(speed:0.13333333)(size:13)(sound:none)Why'd you jump?(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").set_base_font(load("res://assets/fonts/sans.ttf"))
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_glyph = 2
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_space = 4
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_bottom = 4
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 2
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)(speed:0.03333333)...(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 0
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)welp, now that you are\nhere(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 4
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)everything turned\nout well,(delay:0.5) huh?(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 2
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)...(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 1
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").set_base_font(load("res://assets/fonts/dialogue.ttf"))
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_glyph = 0
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_space = 0
		a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_bottom = 4
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(size:13)(sound:none)Don't mess it up.(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 2
		a_vars.enemies.get_node("sans").speech_bubble.visible = false
		await get_tree().create_timer(1, false).timeout
		vars.attack_manager.black_screen(.1)
		await get_tree().create_timer(.1, false).timeout
		var attack = vars.attack_manager.pre_custom_attack(load("res://scripts/battle/attacks/whydyoujump/attack_serious.gd"))
		attack.start_attack()
	else:
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 0
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(sound:sans)(speed:0.03333333)darn.(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 4
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(sound:sans)can't believe\nyou dodged\rthat one.(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 2
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(sound:sans)heh.(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 5
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(sound:sans)well,(delay:0.5)\ni tried.(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 4
		a_vars.enemies.get_node("sans").speech_writer.writer_text = "(sound:sans)good fight.(pc)"
		await a_vars.enemies.get_node("sans").speech_writer.done
		await a_vars.enemies.get_node("sans").end_fight()

	#a_vars.enemies.get_node("sans").slam("up", false)
	#a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").play("default", 0)
	#a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 1
	#await get_tree().create_timer(.5, false).timeout
	#a_vars.enemies.get_node("sans").slam("right", false)
	#a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.red
	#audio.play("battle/bell")
	#await get_tree().create_timer(.25, false).timeout
	#audio.play("battle/mus_sfx_segapower", audio.global_volume, 1.5)
	#for i in range(21):
		#a_vars.attack_manager.bone(0, Vector2(240, 237), 3, 0, 120, 0, 25+20*sin(i/3.0), 0, true, -1)
		#a_vars.attack_manager.bone(0, Vector2(240, 383), 3, 0, 120, -85+20*sin(i/3.0), 0, 0, true, -1)
		#await get_tree().create_timer(.05, false).timeout
	#a_vars.attack_manager.gaster_blaster(0, Vector2(0, 0), Vector2(260, 180), 0, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(0, 0), Vector2(190, 250), -90, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(640, 480), Vector2(450, 370), 90, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(640, 480), Vector2(380, 440), 180, Vector2(1, 1), 15, 15, false)
	#await get_tree().create_timer(.75, false).timeout
	#a_vars.attack_manager.gaster_blaster(0, Vector2(0, 0), Vector2(190, 180), -45, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(640, 0), Vector2(450, 180), 45, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(0, 480), Vector2(190, 440), -135, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(640, 480), Vector2(450, 440), 135, Vector2(1, 1), 15, 15, false)
	#await get_tree().create_timer(.75, false).timeout
	#a_vars.attack_manager.gaster_blaster(0, Vector2(0, 0), Vector2(260, 180), 0, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(0, 0), Vector2(190, 250), -90, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(640, 480), Vector2(450, 370), 90, Vector2(1, 1), 15, 15, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(640, 480), Vector2(380, 440), 180, Vector2(1, 1), 15, 15, false)
	#await get_tree().create_timer(.75, false).timeout
	#a_vars.attack_manager.gaster_blaster(0, Vector2(0, 0), Vector2(120, 310), -90, Vector2(1.5, 1.5), 30, 30, false)
	#a_vars.attack_manager.gaster_blaster(0, Vector2(640, 0), Vector2(520, 310), 90, Vector2(1.5, 1.5), 30, 30, false)
	#
	#await get_tree().create_timer(2, false).timeout
	#a_vars.enemies.get_node("sans").speech_bubble.tail_texture(load("res://assets/sprites/battle/speech_bubble/speech_bubble_tail.png"))
	#a_vars.enemies.get_node("sans").speech_bubble.offset_right = 110
	#a_vars.enemies.get_node("sans").speech_bubble.offset_bottom = 52
	#a_vars.enemies.get_node("sans").speech_bubble.tail_side = "left"
	#a_vars.enemies.get_node("sans").speech_bubble.tail_pos = a_vars.enemies.get_node("sans").speech_bubble.get_tail_top_left()
	#a_vars.enemies.get_node("sans").speech_bubble.visible = true
	#a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 0
	#a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").set_base_font(load("res://assets/fonts/sans.ttf"))
	#a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_glyph = 2
	#a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_space = 4
	#a_vars.enemies.get_node("sans").speech_writer.get("theme_override_fonts/normal_font").spacing_bottom = 4
	#if(a_vars.scene.intro_skip):
		#a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(speed:0.03333333)(sound:sans)here we go.(pc)"
	#else:
		#a_vars.enemies.get_node("sans").speech_writer.writer_text = "(enable:x)(speed:0.03333333)(sound:sans)huh.(pc)"
		#await get_tree().create_timer(.01, false).timeout
		#a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 4
		#await a_vars.enemies.get_node("sans").speech_writer.done
		#a_vars.enemies.get_node("sans").get_node("sprite_anchor/torso").frame = 1
		#a_vars.enemies.get_node("sans").speech_writer.writer_text = "(sound:sans)always wondered why\npeople never use\ntheir strongest\nattack first.(pc)"
	#await a_vars.enemies.get_node("sans").speech_writer.done
	#a_vars.enemies.get_node("sans").speech_bubble.visible = false
	#a_vars.enemies.get_node("sans").animation_mode = 1
	#a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 0
	#a_vars.enemies.get_node("sans").get_node("sprite_anchor/torso").frame = 0
	#a_vars.enemies.get_node("sans").position.y = 169
	#end_attack()
