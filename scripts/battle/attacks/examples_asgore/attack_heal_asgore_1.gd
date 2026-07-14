extends Attack

var a_vars : vars = vars
var left_side = false
var count = 2
var speed = 1

func _init():
	frames = INF

func pre_attack():
	vars.battle_box.resize_mode = 1
	vars.battle_box.set_box_size([200,250,440,390],500)
	vars.player_heart.visible = true
	vars.player_heart.global_position = Vector2(320, 320)
	
func start_attack():
	super.start_attack()
	audio.play("battle/noise")
	flash()
	vars.scene.get_node("dim").visible = true
	vars.enemies.get_node("asgore").animation_mode = 0
	vars.enemies.get_node("asgore/sprite_anchor/body").z_index = 1
	vars.enemies.get_node("asgore/sprite_anchor/body").animation = &"flash"
	await get_tree().create_timer(.5, false).timeout
	var code_slash : Array[int] = []
	var side = left_side
	for i in range(count):
		var rng = [2, 5].pick_random()
		blink_eye(rng, 1, i == count-1, side)
		await get_tree().create_timer(.5/speed, false).timeout
		side = !side
		code_slash.append(rng)
	await get_tree().create_timer(.5, false).timeout
	audio.play("battle/noise")
	flash()
	vars.scene.get_node("dim").visible = false
	vars.enemies.get_node("asgore/asgore_swipe").visible = false
	vars.enemies.get_node("asgore/sprite_anchor").visible = true
	vars.enemies.get_node("asgore/sprite_anchor/body").z_index = 0
	vars.enemies.get_node("asgore").animation_mode = 1
	vars.player_heart.z_index = 2
	vars.player_heart.z_as_relative = false
	await get_tree().create_timer(.5, false).timeout
	vars.enemies.get_node("asgore/asgore_swipe").visible = true
	vars.enemies.get_node("asgore/sprite_anchor").visible = false
	side = left_side
	for i in code_slash:
		vars.enemies.get_node("asgore/asgore_swipe").swipe(i, speed * 2, side)
		await get_tree().create_timer(.5/speed, false).timeout
		side = !side
	await get_tree().create_timer(1, false).timeout
	vars.enemies.get_node("asgore/asgore_swipe").visible = false
	vars.enemies.get_node("asgore/sprite_anchor").visible = true
	vars.enemies.get_node("asgore/sprite_anchor/body").z_index = 0
	vars.enemies.get_node("asgore").animation_mode = 1
	vars.player_heart.z_index = 0
	vars.player_heart.z_as_relative = true
	end_attack()

func end_attack():
	vars.enemies.get_node("asgore/sprite_anchor/body").z_index = 0
	super.end_attack()

func blink_eye(type : Bullet.e_type, speed : float = 1.0, last : bool = false, right_side : bool = false):
	var eye := vars.enemies.get_node("asgore/sprite_anchor/body/reye") if(right_side)else vars.enemies.get_node("asgore/sprite_anchor/body/leye")
	match(type):
		Bullet.e_type.blue, Bullet.e_type.blue_control:
			eye.self_modulate = Color(0,.64,.91)
		Bullet.e_type.orange, Bullet.e_type.orange_control:
			eye.self_modulate = Color(1,.63,.25)
		Bullet.e_type.green:
			eye.self_modulate = Color(0,1,0)
		_:
			eye.self_modulate = Color.WHITE
	audio.play("battle/mus_sfx_eyeflash", audio.global_volume, .8 if(last)else 1.1)
	eye.play(&"last" if(last)else &"default", speed)
	await eye.animation_finished

func flash():
	vars.black_screen.visible = true
	vars.black_screen.color = Color(1, 1, 1)
	var flashing = create_tween()
	flashing.finished.connect(
		func(): 
			vars.black_screen.visible = false
			vars.black_screen.color = Color(0, 0, 0))
	flashing.tween_method(func(v): vars.black_screen.color.a = v, 1.0, 0.0, 0.5)
	
