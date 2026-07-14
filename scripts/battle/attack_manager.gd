extends Node
class_name AttackManager

signal heart_thrown
signal delete_bullets
signal attack_done

@onready var masks = get_node("buffer/masks")
@onready var box_masks = get_node("buffer/masks/box_mask")

var turn_num = 0
var attacks = [load("res://scripts/battle/attacks/attack_base.gd")]
var heal_attacks = [load("res://scripts/battle/attacks/attack_base.gd")]
var current_attack : Attack = null

func _ready():
	attack_done.connect(func(): delete_bullets.emit())

func set_writer_text():
	pass

func pre_attack() -> Attack:
	current_attack = Attack.new()
	if(attacks == []): current_attack.set_script(load("res://scripts/battle/attacks/attack_base.gd"))
	else: current_attack.set_script(attacks[wrapi(turn_num,0,len(attacks))])
	add_child(current_attack)
	current_attack.pre_attack()
	current_attack.attack_finished.connect(func(): attack_done.emit())
	return current_attack

func pre_heal_attack() -> Attack:
	current_attack = Attack.new()
	if(heal_attacks == []): current_attack.set_script(load("res://scripts/battle/attacks/attack_base.gd"))
	else: current_attack.set_script(heal_attacks.pick_random())
	add_child(current_attack)
	current_attack.pre_attack()
	current_attack.attack_finished.connect(func(): attack_done.emit())
	return current_attack

func pre_custom_attack(attack_script) -> Attack:
	current_attack = Attack.new()
	current_attack.set_script(attack_script)
	add_child(current_attack)
	current_attack.pre_attack()
	current_attack.attack_finished.connect(func(): attack_done.emit())
	return current_attack

func bullet(bullet_path : Variant, type : Bullet.e_type, position : Vector2, x : float, y : float, speed : float,
rotation_speed : float, masked = true, duration : float = -1) -> Bullet:
	var bullet = bullet_path.instantiate()
	bullet.masked = masked
	bullet.duration = duration
	bullet.x = x
	bullet.y = y
	bullet.speed = speed
	bullet.rotation_speed = speed
	bullet.global_position = position
	masks.add_child(bullet)
	return bullet

func box(position : Vector2, margin : Array, rotation_speed : float, masked = true, duration : float = -1) -> BBox:
	var box = preload("res://objects/battle/bullets/sans/box.tscn").instantiate()
	box.masked = masked
	box.duration = duration
	box.rotation_speed = rotation_speed
	box.global_position = position
	box_masks.add_child(box)
	box.margin = margin
	return box

func bone(type : Bullet.e_type, position : Vector2, x : float, y : float, speed : float,
offset_top: float, offset_bottom : float, rotation_speed : float, masked = true,
duration : float = -1) -> BBone:
	var bone = preload("res://objects/battle/bullets/sans/bone.tscn").instantiate()
	bone.masked = masked
	bone.duration = duration
	bone.x = x
	bone.y = y
	bone.speed = speed
	bone.rotation_speed = rotation_speed
	bone.global_position = position
	masks.add_child(bone)
	bone.type = type
	bone.offset_top = offset_top
	bone.offset_bottom = offset_bottom
	return bone
	
func bone_collidable(type : Bullet.e_type, position : Vector2, x : float, y : float, speed : float,
offset_top: float, offset_bottom : float, rotation_speed : float, masked = true,
duration : float = -1) -> BBoneCollidable:
	var bone = preload("res://objects/battle/bullets/sans/bone_collidable.tscn").instantiate()
	bone.masked = masked
	bone.duration = duration
	bone.x = x
	bone.y = y
	bone.speed = speed
	bone.rotation_speed = rotation_speed
	bone.global_position = position
	masks.add_child(bone)
	bone.type = type
	bone.offset_top = offset_top
	bone.offset_bottom = offset_bottom
	return bone

func bone_circle(type : Bullet.e_type, position : Vector2, bone_count : int, radius : float,
rotation_speed : float, masked : bool = true, duration : float = -1) -> BBoneCircle:
	var bone_circle = preload("res://objects/battle/bullets/sans/bone_circle.tscn").instantiate()
	bone_circle.masked = masked
	bone_circle.bone_count = bone_count
	bone_circle.radius = radius
	bone_circle.rotation_speed = rotation_speed
	bone_circle.global_position = position
	bone_circle.duration = duration
	masks.add_child(bone_circle)
	bone_circle.type = type
	return bone_circle

func bone_gravity(type : Bullet.e_type, position : Vector2, bone_count : int, offset_bottom : float,
masked : bool = false, duration : float = -1) -> void:
	for i in range(bone_count):
		var bone = preload("res://objects/battle/bullets/sans/bone.tscn").instantiate()
		bone.duration = duration
		bone.masked = masked
		bone.global_position = position
		masks.add_child(bone)
		bone.type = type
		bone.offset_bottom = offset_bottom
		bone.gravity_enabled = true

func platform(platform_type : BPlatform.e_platform_type, position : Vector2, x : float,
y : float, speed : float, masked = false, duration : float = -1) -> BPlatform:
	var platform = preload("res://objects/battle/bullets/sans/platform.tscn").instantiate()
	platform.masked = masked
	platform.duration = duration
	platform.x = x
	platform.y = y
	platform.speed = speed
	platform.global_position = position
	masks.add_child(platform)
	platform.platform_type = platform_type
	return platform

func gaster_blaster(type : Bullet.e_type, start_position : Vector2, end_position : Vector2,
end_rotation : float, scale : Vector2, wait_time : float = 0, blast_time : float = 0,
masked = false, sounds : Array = []) -> BGasterBlaster:
	var gaster_blaster = preload("res://objects/battle/bullets/sans/gaster_blaster.tscn").instantiate()
	gaster_blaster.masked = false
	gaster_blaster.scale = scale
	gaster_blaster.wait_time = wait_time
	gaster_blaster.blast_time = blast_time
	gaster_blaster.end_position = end_position
	gaster_blaster.end_rotation = end_rotation
	gaster_blaster.global_position = start_position
	if(sounds!=[]):
		gaster_blaster.sound_entry = sounds[0]
		gaster_blaster.sound_blast = sounds[1]
	masks.add_child(gaster_blaster)
	gaster_blaster.type = type
	return gaster_blaster

func fake_gaster_blaster(type : Bullet.e_type, start_position : Vector2, end_position : Vector2,
end_rotation : float, scale : Vector2, wait_time : float = 0, blast_time : float = 0,
masked = false) -> FakeBGasterBlaster:
	var fake_gaster_blaster = preload("res://objects/battle/bullets/sans/fake_gaster_blaster.tscn").instantiate()
	fake_gaster_blaster.masked = false
	fake_gaster_blaster.scale = scale
	fake_gaster_blaster.wait_time = wait_time
	fake_gaster_blaster.blast_time = blast_time
	fake_gaster_blaster.end_position = end_position
	fake_gaster_blaster.end_rotation = end_rotation
	fake_gaster_blaster.global_position = start_position
	masks.add_child(fake_gaster_blaster)
	fake_gaster_blaster.type = type
	return fake_gaster_blaster

func bone_stab(type : Bullet.e_type, position : Vector2, length : float, height : float,
wait_time : float, up_time : float, bone_rotation : float, masked = true, sounds : Array = []) -> Bullet:
	var bone_stab = preload("res://objects/battle/bullets/sans/bone_stab.tscn").instantiate()
	bone_stab.visible = false
	bone_stab.length = length
	bone_stab.bone_height = height
	bone_stab.wait_time = wait_time
	bone_stab.up_time = up_time
	bone_stab.masked = masked
	bone_stab.global_position = position
	if(sounds!=[]):
		bone_stab.sound_warn = sounds[0]
		bone_stab.sound_entry = sounds[1]
	masks.add_child(bone_stab)
	bone_stab.type = type
	bone_stab.bone_rotation = bone_rotation
	bone_stab.visible = true
	return bone_stab
	
	
func bone_stab_collidable(type : Bullet.e_type, position : Vector2, length : float, height : float,
wait_time : float, up_time : float, bone_rotation : float, masked = true, sounds : Array = []) -> Bullet:
	var bone_stab = preload("res://objects/battle/bullets/sans/bone_stab_collidable.tscn").instantiate()
	bone_stab.visible = false
	bone_stab.length = length
	bone_stab.bone_height = height
	bone_stab.wait_time = wait_time
	bone_stab.up_time = up_time
	bone_stab.masked = masked
	bone_stab.global_position = position
	if(sounds!=[]):
		bone_stab.sound_warn = sounds[0]
		bone_stab.sound_entry = sounds[1]
	masks.add_child(bone_stab)
	bone_stab.type = type
	bone_stab.bone_rotation = bone_rotation
	bone_stab.visible = true
	return bone_stab

func vector_slash(type : Bullet.e_type, position : Vector2, wait_time : float,
starting_rotation : float, rotation_speed : float, stop_rotation_after : bool, masked = false) -> BVectorSlash:
	var vector_slash = preload("res://objects/battle/bullets/sans/vector_slash.tscn").instantiate()
	vector_slash.global_position = position
	vector_slash.wait_time = wait_time
	vector_slash.rotation_degrees = starting_rotation
	vector_slash.stop_rotation_after = stop_rotation_after
	vector_slash.rotation_speed = rotation_speed
	vector_slash.masked = stop_rotation_after
	masks.add_child(vector_slash)
	vector_slash.type = type
	return vector_slash
	
func slash(type : Bullet.e_type, position : Vector2, wait_time : float,
starting_rotation : float, rotation_speed : float, stop_rotation_after : bool, masked = false) -> BSlash:
	var slash = preload("res://objects/battle/bullets/sans/slash.tscn").instantiate()
	slash.global_position = position
	slash.wait_time = wait_time
	slash.rotation_degrees = starting_rotation
	slash.stop_rotation_after = stop_rotation_after
	slash.rotation_speed = rotation_speed
	slash.masked = stop_rotation_after
	slash.z_index = 1
	masks.add_child(slash)
	slash.type = type
	return slash

func warning(position : Vector2, size : Vector2, duration : float, masked = true) -> NinePatchRect:
	audio.play("battle/warning")
	var warning = NinePatchRect.new()
	warning.texture = preload("res://assets/sprites/battle/square.png")
	warning.patch_margin_left = 1
	warning.patch_margin_top = 1
	warning.patch_margin_right = 1
	warning.patch_margin_bottom = 1
	warning.modulate = Color.RED
	warning.size = size
	warning.global_position = position
	warning.show_behind_parent = masked
	masks.add_child(warning)
	var kill_warning = func():
		if(is_instance_valid(warning)):
			warning.queue_free()
	create_tween().tween_method(func(v): warning.modulate.a = v, 1.0, 0.0, duration)
	get_tree().create_timer(duration, false).timeout.connect(kill_warning)
	attack_done.connect(kill_warning)
	return warning

func throw(direction : float = 0, fall_speed : float = 8.0) -> void:
	heart_thrown.emit(direction)
	vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	vars.player_heart.sprite.rotation = deg_to_rad(direction)
	#await get_tree().physics_frame
	vars.player_heart.fall_speed = fall_speed#750
	vars.player_heart.thrown = true

func black_screen(time : float) -> void:
	vars.black_screen.visible = true
	audio.play("battle/noise")
	var volume = audio.global_volume
	if(is_instance_valid(audio.music)):
		volume = audio.music.volume_db
		audio.music.volume_db = linear_to_db(0.00001)
	await get_tree().create_timer(time).timeout
	vars.black_screen.visible = false
	audio.play("battle/noise")
	if(is_instance_valid(audio.music)):
		audio.music.volume_db = volume

func reset_attack():
	if(is_instance_valid(current_attack)):
		var reinstanced_attack = current_attack.duplicate()
		delete_bullets.emit()
		current_attack.queue_free()
		current_attack = reinstanced_attack
		current_attack.attack_finished.connect(func(): attack_done.emit())
		vars.battle_box.resize_finished.connect(start_resetted_attack)
		add_child(current_attack)
		current_attack.pre_attack()

func start_resetted_attack():
	if(is_instance_valid(current_attack)):
		current_attack.start_attack(); vars.battle_box.resize_finished.disconnect(start_resetted_attack)
