extends Attack

var a_vars : vars = vars

func _init():
	frames = 600

func pre_attack():
	super.pre_attack()
	a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	a_vars.battle_box.set_box_size([130,250,510,390])
	a_vars.player_heart.global_position = Vector2(320, 377)

func start_attack():
	super.start_attack()
	attack()

func attack():
	for i in range(5):
		var speed_l = [1.2, 1.5, 1.8].pick_random()
		var speed_r = [1.2, 1.5, 1.8].pick_random()
		var size = [[90, -20], [80, -30], [70, -40], [50, -60]].pick_random()
		a_vars.attack_manager.bone(0, Vector2(130-190*(speed_l-1), 256), speed_l, 0, 120, 0, size[0], 0, true, -1)
		a_vars.attack_manager.bone(0, Vector2(130-190*(speed_l-1), 384), speed_l, 0, 120, size[1], 0, 0, true, -1)
		a_vars.attack_manager.bone(0, Vector2(510+190*(speed_r-1), 256), -speed_r, 0, 120, 0, size[0], 0, true, -1)
		a_vars.attack_manager.bone(0, Vector2(510+190*(speed_r-1), 384), -speed_r, 0, 120, size[1], 0, 0, true, -1)
		await get_tree().create_timer(1.8, false).timeout
