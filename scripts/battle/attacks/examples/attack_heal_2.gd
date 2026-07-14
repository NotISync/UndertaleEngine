extends Attack

var a_vars : vars = vars

var soul_color

var bone = []

func _init():
	frames = 600

func pre_attack():
	super.pre_attack()
	soul_color = a_vars.player_heart.heart_mode
	a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	a_vars.player_heart.global_position = Vector2(320, 377)
	
func start_attack():
	super.start_attack()
	var plat = a_vars.attack_manager.platform(0, Vector2(320, 400), 0, 0, 120, true, -1)
	create_tween().tween_method(func(v): plat.position.y = v, 400, 330, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	bone.append(a_vars.attack_manager.bone(0, Vector2(320, 400), 0, 0, 120, 0, 0, 0, true, -1))
	create_tween().tween_method(func(v): bone[0].offset_top = v, 0, -50, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	audio.play("battle/bonestab")
	for i in range(5):
		await get_tree().create_timer(0.1).timeout
		var bone_1 = a_vars.attack_manager.bone(0, Vector2(320+((i+1)*12), 400), 0, 0, 120, 0, 0, 0, true, -1)
		var bone_2 = a_vars.attack_manager.bone(0, Vector2(320-((i+1)*12), 400), 0, 0, 120, 0, 0, 0, true, -1)
		create_tween().tween_method(func(v): bone_1.offset_top = v, 0, -50, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		create_tween().tween_method(func(v): bone_2.offset_top = v, 0, -50, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		audio.play("battle/bonestab")
		bone.append(bone_1)
		bone.append(bone_2)
	await get_tree().create_timer(0.1).timeout
	platsin(plat)
	for i in range(10):
		var bone_1 = a_vars.attack_manager.bone(0, Vector2(320, 220), 0, 1, 120, -15, 15, 0, true, -1)
		bone.append(bone_1)
		await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(1).timeout
	for i in range(0, 11):
		if i % 4 == 0 || i % 4 == 3:
			create_tween().tween_method(func(v): bone[i].y = v, 0.0, -3.0, 2)
	await get_tree().create_timer(0.75).timeout
	for i in range(0, 11):
		if i % 4 == 1 || i % 4 == 2:
			create_tween().tween_method(func(v): bone[i].y = v, 0.0, -3.0, 2)
	await get_tree().create_timer(1).timeout
	plat.y = 1
func platsin(plat):
	for i in range(360):
		await get_tree().process_frame
		plat.position.x = 320 + 35*sin(i/32.0)
	for i in range(35):
		await get_tree().process_frame
		plat.position.x += 1

func end_attack():
	a_vars.player_heart.heart_mode = soul_color
	super.end_attack()
