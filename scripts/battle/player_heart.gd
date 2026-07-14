extends CharacterBody2D
class_name PlayerHeart

enum e_heart_mode {
	red,
	yellow,
	green,
	pink,
	blue,
	orange,
	cyan
	}

signal thrown_impact

var big_shot := 0
var max_big_shot := 30
var bullet = null
var tween_charge
var auto_change_color := true
var input_enabled := false
var lock_x := false
var lock_y := false
var heart_mode : e_heart_mode = e_heart_mode.red :
	set(value):
		heart_mode = value
		fall_speed = 0.0
		fall_gravity = 0.0
		jump_input = false
		if(auto_change_color):
			change_heart_color()
@onready var sprite = $sprite
@onready var sprite_flee = $sprite_flee
@onready var hitbox = $hitbox
@onready var shield = $shield
@onready var shield_barrier = $shield_barrier
@onready var shield_hitbox = $shield_hitbox
var speed := 2.0
var speed_buff := 0.0
var attack_buff := 0.0
const static_speed := 75.0 #Used to multiply with speed
var i_frames := 60.0 #Invincibility frames
var i_timer := 0.0
var karma_i_frames := 2.0
var karma_tick_timer := 0.0 #Ticks karma away depending on how much karma you have.
var move_input := Vector2.ZERO
var jump_direction := Vector2.ZERO
var jump_input := false
var jump_strength := -6.0
var jump_speed_multiplier := 2.0
var thrown := false
var throw_dmg := false
var floor_snap := false
var fall_speed := 0.0
var fall_gravity := 0.0
var angle := 0
var auto_color := true
var shield_rotation = 0
var shield_rotation_tween = null
var tp_timer = 0
var tp = 0
var invulnerable = false
var shield_barrier_tween = null

func _ready():
	floor_stop_on_slope = true
	#$buffer.visible = settings.battle_outline

func hurt(damage : float, extra_i_frames : float):
	audio.play("battle/hurt")
	var innocence = settings.player_save.player.kills==0
	settings.player_save.player.current_hp = max(settings.player_save.player.current_hp - damage, ((1)if(settings.player_save.player.current_hp>1&&innocence)else(0)))
	i_timer = i_frames + extra_i_frames + settings.player_save.get_weapon().inv + settings.player_save.get_armor().inv
	vars.display.screen_shake(3)
	
func heal(damage : float):
	audio.play("battle/heal")
	settings.player_save.player.current_kr = min(settings.player_save.player.current_kr - damage, settings.player_save.player.max_hp - settings.player_save.player.current_hp)
	settings.player_save.player.current_hp = min(settings.player_save.player.current_hp + damage, settings.player_save.player.max_hp)

func hurt_kr(damage, extra_i_frames : float):
	audio.play("battle/hurt")
	i_timer = karma_i_frames + extra_i_frames + settings.player_save.get_weapon().inv + settings.player_save.get_armor().inv
	
	if(settings.player_save.player.current_hp <= damage):
		if(settings.player_save.player.current_hp <= 1):
			if(settings.player_save.player.current_kr > damage):
				settings.player_save.player.current_kr = max(0, settings.player_save.player.current_kr - damage)
			else:
				if(settings.player_save.player.current_kr == 0):
					settings.player_save.player.current_hp = max(0, settings.player_save.player.current_hp - damage)
				settings.player_save.player.current_kr = 0
		else:
			settings.player_save.player.current_kr += settings.player_save.player.current_hp - 1
			settings.player_save.player.current_hp = 1
	if(settings.player_save.player.current_hp > damage):
		settings.player_save.player.current_kr += damage
		settings.player_save.player.current_hp = max(0, settings.player_save.player.current_hp - damage)

	#if(settings.player_save.player.current_hp > 1):
		#if(settings.player_save.player.current_kr <= 40):
			#settings.player_save.player.current_kr = max(0,settings.player_save.player.current_kr + damage)
			#settings.player_save.player.current_hp = max(1,settings.player_save.player.current_hp - (damage + 1))
		#else:
			#settings.player_save.player.current_hp = max(0,settings.player_save.player.current_hp - 1)
	#else:
		#if(settings.player_save.player.current_kr > 0):
			#settings.player_save.player.current_kr = max(0,settings.player_save.player.current_kr - 1)
		#else:
			#settings.player_save.player.current_hp = 0

func _process(delta : float):
	check_hit()
	check_death()
	tick(delta)

func tick(delta):
	i_timer = max(i_timer - (delta * 60), 0)
	if(i_timer <= 0):
		sprite.modulate = Color(1, 1, 1, sprite.modulate.a)
	else:
		#modulate.a = wrapf(modulate.a + delta * 2,0,1)
		var col = .75 + ((.25*cos((i_timer)/2)) * (60 * delta))
		sprite.modulate = Color(col, col, col, sprite.modulate.a)
		
	#if settings.player_save.player.current_kr > 0:
		#karma_tick_timer += delta * 60
		#var PowerOfKarma = float(settings.player_save.player.max_hp)/float(settings.player_save.player.current_kr)*5.0
		#if PowerOfKarma > 20:
			#PowerOfKarma = 20
		#if karma_tick_timer > PowerOfKarma:
			#settings.player_save.player.current_kr -= 1
			#karma_tick_timer = 0
	#else:
		#settings.player_save.player.current_kr = 0

	karma_tick_timer += (delta * 60)
	if(karma_tick_timer > 1):
		if(settings.player_save.player.current_kr >= 40):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	if(karma_tick_timer > 2):
		if(settings.player_save.player.current_kr >= 30 && settings.player_save.player.current_kr <= 39):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	if(karma_tick_timer > 5):
		if(settings.player_save.player.current_kr >= 20 && settings.player_save.player.current_kr <= 29):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	if(karma_tick_timer > 15):
		if(settings.player_save.player.current_kr >= 10 && settings.player_save.player.current_kr <= 19):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	if(karma_tick_timer > 30):
		if(settings.player_save.player.current_kr>= 1 && settings.player_save.player.current_kr <= 9):
			settings.player_save.player.current_kr -= 1
			karma_tick_timer = 0
	

func check_hit():
	for i in $hitbox.get_overlapping_areas():
		if(i.owner is Bullet && i.owner is not BPlayerBullet):
			i.owner.hit()
	match(heart_mode):
		e_heart_mode.green:
			for i in $shield_hitbox.get_overlapping_areas():
				if(i.owner is Bullet && i.owner is not BGasterBlaster):
					audio.play("battle/bell")
					i.owner.queue_free()
					shield.play()

func _physics_process(delta):
	inputs(delta)

func change_heart_color():
	shield.visible = false
	shield_barrier.visible = false
	$shield_hitbox/collision.disabled = true
	match(heart_mode):
		e_heart_mode.red:
			sprite.self_modulate = Color(1,0,0,sprite.self_modulate.a)
			sprite.rotation = deg_to_rad(0)
		e_heart_mode.yellow:
			sprite.self_modulate = Color(1,1,0,sprite.self_modulate.a)
			sprite.rotation = deg_to_rad(180)
		e_heart_mode.green:
			sprite.self_modulate = Color(0,.5,0,sprite.self_modulate.a)
			sprite.rotation = deg_to_rad(0)
			shield_barrier.self_modulate = Color(0,.5,0,shield_barrier.self_modulate.a)
			shield.visible = true
			shield_barrier.visible = true
			$shield_hitbox/collision.disabled = false
		e_heart_mode.pink:
			sprite.self_modulate = Color(1,0,1,sprite.self_modulate.a)
			sprite.rotation = deg_to_rad(0)
		e_heart_mode.blue:
			sprite.self_modulate = Color(0,0,1,sprite.self_modulate.a)
			sprite.rotation = deg_to_rad(0)
		e_heart_mode.orange:
			sprite.self_modulate = Color(1,.63,.25,sprite.self_modulate.a)
			sprite.rotation = deg_to_rad(0)
		e_heart_mode.cyan:
			sprite.self_modulate = Color(0,1,1,sprite.self_modulate.a)
			sprite.rotation = deg_to_rad(0)

func inputs(delta):
	var temp_speed = speed + speed_buff
	var move_input = Vector2.ZERO
	var move_x = 0.0
	var move_y = 0.0
	if(input_enabled):
		if !lock_x: move_x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		if !lock_y: move_y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		if(Input.is_action_pressed("exit")):
			temp_speed /= 2
	match(heart_mode):
		e_heart_mode.red:
			velocity = (Vector2(move_x, move_y) * temp_speed * static_speed) * (60 * delta)
			move_and_slide()
			move_input = velocity
		e_heart_mode.yellow:
			if(bullet == null && input_enabled && is_instance_valid(vars.attack_manager.current_attack) && vars.attack_manager.current_attack.attack_started):
				if(Input.is_action_pressed("confirm")):
					if(big_shot == max_big_shot-1):
						var chargin = audio.play("battle/snd_chargeshot_charge", 0.0, 0.0)
						create_tween().tween_method(func(val): chargin.volume_db = linear_to_db(val), 0.0, audio.global_volume, 0.5)
						create_tween().tween_method(func(val): chargin.pitch_scale = val, 0.0, 1.0, 0.5)
						tween_charge = create_tween()
						tween_charge.tween_method(func(val): sprite.self_modulate = val, sprite.self_modulate, Color(1,1,1,sprite.self_modulate.a), 0.5)
					big_shot = min(big_shot + 1, max_big_shot)
				if(Input.is_action_just_released("confirm")):
					if(big_shot >= max_big_shot-1):
						audio.stop_sound("battle/snd_chargeshot_charge")
					if(big_shot == max_big_shot):
						audio.play("battle/snd_chargeshot_fire")
					else: 
						audio.play("battle/snd_heartshot")
					bullet = load("res://objects/battle/bullets/player/player_bullet.tscn").instantiate()
					bullet.charge = big_shot == max_big_shot
					big_shot = 0
					bullet.rotation = deg_to_rad(sprite.rotation_degrees-180)
					bullet.global_position = position + (Vector2(0, 16)).rotated(sprite.rotation)
					bullet.x = Vector2(0, 4).rotated(sprite.rotation).x
					bullet.y = Vector2(0, 4).rotated(sprite.rotation).y
					bullet.speed = 120
					bullet.masked = false
					vars.attack_manager.get_node("buffer/masks").add_child(bullet)
					if(tween_charge): tween_charge.kill()
					sprite.self_modulate = Color(1,1,0,sprite.self_modulate.a)
			else:
				audio.stop_sound("battle/snd_chargeshot_charge")
			velocity = (Vector2(move_x, move_y) * temp_speed * static_speed) * (60 * delta)
			move_and_slide()
			move_input = velocity
		e_heart_mode.green:
			if(input_enabled && is_instance_valid(vars.attack_manager.current_attack) && vars.attack_manager.current_attack.attack_started):
				if(Input.is_action_just_pressed("up")):
					if(shield_rotation_tween):
						shield_rotation_tween.kill()
						if(shield_rotation_tween.is_valid()):
							shield.rotation_degrees = 0
							shield_rotation = 0
					shield_rotation_tween = create_tween()
					shield_rotation_tween.tween_method(func(value): shield.rotation_degrees = value, shield_rotation, 0 if(shield_rotation!=270)else 360, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
					shield_rotation = 0
					if(shield_rotation_tween.is_valid()):
						shield.rotation_degrees = 0
				if(Input.is_action_just_pressed("right")):
					if(shield_rotation_tween):
						shield_rotation_tween.kill()
						if(shield_rotation_tween.is_valid()):
							shield.rotation_degrees = 90
							shield_rotation = 90
					shield_rotation_tween = create_tween()
					shield_rotation_tween.tween_method(func(value): shield.rotation_degrees = value, shield_rotation, 90, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
					shield_rotation = 90
				if(Input.is_action_just_pressed("down")):
					if(shield_rotation_tween):
						shield_rotation_tween.kill()
						if(shield_rotation_tween.is_valid()):
							shield.rotation_degrees = 180
							shield_rotation = 180
					shield_rotation_tween = create_tween()
					shield_rotation_tween.tween_method(func(value): shield.rotation_degrees = value, shield_rotation, 180, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
					shield_rotation = 180
				if(Input.is_action_just_pressed("left")):
					if(shield_rotation_tween):
						shield_rotation_tween.kill()
						if(shield_rotation_tween.is_valid()):
							shield.rotation_degrees = 270
							shield_rotation = 270
					shield_rotation_tween = create_tween()
					shield_rotation_tween.tween_method(func(value): shield.rotation_degrees = value, shield_rotation if(shield_rotation!=0)else 360, 270, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
					shield_rotation = 270
			var Turn = is_instance_valid(vars.attack_manager.current_attack)
			shield_barrier.visible = Turn if(Turn!=null)else false
			shield.visible = Turn if(Turn!=null)else false
			shield_hitbox.rotation_degrees = shield_rotation
		e_heart_mode.pink:
			velocity = (Vector2(move_x, move_y) * temp_speed * static_speed) * (60 * delta)
			move_and_slide()
			move_input = velocity
		e_heart_mode.blue:
			var angle = round(rad_to_deg($sprite.rotation))
			var jsm_accel = (jump_speed_multiplier)**2
			var jsm_velo = jump_speed_multiplier
			if(is_instance_valid(vars.attack_manager.current_attack) && vars.attack_manager.current_attack.attack_started):
				if(fall_speed <= -4.0 / jsm_velo): fall_gravity = 0.2 / jsm_accel
				if(-4.0 / jsm_velo < fall_speed && fall_speed <= -1.0 / jsm_velo): fall_gravity = 0.5 / jsm_accel
				if(-1.0 / jsm_velo < fall_speed && fall_speed <= 0.5 / jsm_velo): fall_gravity = 0.2 / jsm_accel
				if(0.5 / jsm_velo < fall_speed && fall_speed < 8.0 / jsm_velo): fall_gravity = 0.6 / jsm_accel
				if(8.0 / jsm_velo <= fall_speed): fall_gravity = 0.0 / jsm_accel
			
				if(!is_on_floor()):
					fall_speed += fall_gravity
				else:
					if(!jump_input && !thrown):
						fall_speed = 0.0
			
				if(angle == 0 || angle == 180):
					if(input_enabled):
						jump_input = Input.is_action_pressed("up") if(angle == 0) else Input.is_action_pressed("down")
					move_input = Vector2(move_x * temp_speed * static_speed, 60 * fall_speed * (-1 if(angle == 180) else 1))
					jump_direction = Vector2.UP  if(angle == 0) else Vector2.DOWN
					
				if(angle == 90 || angle == 270):
					if(input_enabled):
						jump_input = Input.is_action_pressed("left") if(angle == 270) else Input.is_action_pressed("right")
					move_input = Vector2(60 * fall_speed * (-1 if(angle == 90) else 1), move_y * (temp_speed * static_speed))
					jump_direction = Vector2.LEFT if(angle == 270) else Vector2.RIGHT
				
				up_direction = jump_direction
				velocity = move_input * (60 * delta)
			else:
				velocity = Vector2.ZERO
				fall_speed = 0.0
			move_and_slide()
			if(is_instance_valid(vars.attack_manager.current_attack) && vars.attack_manager.current_attack.attack_started):
				if(!is_on_ceiling()):
					if(is_on_floor() && jump_input && !thrown):
						floor_snap = false
						fall_speed = jump_strength / jsm_velo
					elif(!jump_input && fall_speed <= -1.0 / jsm_velo):
						fall_speed = -1.0 / jsm_velo
				else:
					if(!thrown):
						fall_speed = 0.0
			if(is_instance_valid(vars.attack_manager.current_attack) && vars.attack_manager.current_attack.attack_started):
				if(is_on_floor()):
					if(thrown):
						thrown = false
						vars.display.screen_shake(floor(abs(fall_speed)))
						audio.play("battle/impact")
						thrown_impact.emit()
		e_heart_mode.orange:
			velocity = (Vector2(move_x, move_y) * temp_speed * static_speed) * (60 * delta)
			move_and_slide()
			move_input = velocity
		e_heart_mode.cyan:
			velocity = (Vector2(move_x, move_y) * temp_speed * static_speed) * (60 * delta)
			move_and_slide()
			move_input = velocity

func check_death():
	if(settings.player_save.player.current_hp <= 0):
		settings.death_position = global_position
		vars.display.change_scene(preload("res://scenes/game_over.tscn"), false, .3, false)

func is_moving():
	match(heart_mode):
		e_heart_mode.red, e_heart_mode.yellow, e_heart_mode.pink, e_heart_mode.orange, e_heart_mode.cyan:
			var move_x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
			var move_y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
			if(move_y != 0 || move_x != 0):
				return true
		e_heart_mode.blue:
			var move_x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
			var angle = round(rad_to_deg(sprite.rotation))
			if(angle == 0 || angle == 180):
				jump_input = Input.is_action_pressed("up") if(angle == 0) else Input.is_action_pressed("down")
			if(angle == 90 || angle == 270):
				jump_input = Input.is_action_pressed("left") if(angle == 270) else Input.is_action_pressed("right")
			
			if(jump_input != false || move_x != 0 || fall_speed > 1):
				return true
			return false
	return false
