extends Attack

var a_vars : vars = vars

func _init():
	frames = 400

func pre_attack():
	super.pre_attack()
	a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	a_vars.battle_box.set_box_size([130,250,510,390])
	a_vars.player_heart.global_position = Vector2(320, 377)

func start_attack():
	super.start_attack()
	attack()

func attack():
	for i in range(8):
		a_vars.attack_manager.bone(0, Vector2(130, 256), 1.5, 0, 120, 0, 90, 0, true, -1)
		a_vars.attack_manager.bone(0, Vector2(510, 256), -1.5, 0, 120, 0, 90, 0, true, -1)
		a_vars.attack_manager.bone(0, Vector2(130, 384), 1.5, 0, 120, -20, 0, 0, true, -1)
		a_vars.attack_manager.bone(0, Vector2(510, 384), -1.5, 0, 120, -20, 0, 0, true, -1)
		await get_tree().create_timer(.6, false).timeout
