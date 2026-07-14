extends CharacterBody2D
class_name Character

signal event_called

@onready var sprite := AnimatedSprite2D.new()
@onready var warning_sprite := AnimatedSprite2D.new()
@onready var collision := CollisionShape2D.new()
@onready var interactable := Interactable.new()
@onready var interactable_hitbox := CollisionShape2D.new()
@onready var ray_cast

var sprite_frames : SpriteFrames :
	set(value):
		sprite_frames = value
		sprite.set_sprite_frames(value)
var x := 0.0
var y := 0.0
var speed := 210.0
var dance = false
var ray_cast_range := 15.0
var auto_sprite_update := true
var snap_camera := true
var cutscene := false :
	set(value):
		cutscene = value
		if(value):
			x = 0.0
			y = 0.0
var input_enabled := true :
	set(value):
		input_enabled = value
		if(!value):
			x = 0.0
			y = 0.0
			dance = false

func _init(sprite_frames):
	var add_sprite_frames = func():
		if(!is_node_ready()):
			await ready
		self.sprite_frames = sprite_frames
		set_warning_position()
	add_sprite_frames.call()

func _ready():
	platform_floor_layers = 0
	sprite.position = Vector2(-10,-15)
	sprite.set_centered(false)
	add_child(sprite)
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(21,10)
	collision.position = Vector2(.5,10)
	add_child(collision)
	interactable.event_called.connect(event)
	add_child(interactable)
	interactable_hitbox.shape = RectangleShape2D.new()
	interactable_hitbox.shape.size = Vector2(21,10)
	interactable_hitbox.position = Vector2(.5,10)
	interactable.add_child(interactable_hitbox)
	warning_sprite.visible = false
	warning_sprite.set_sprite_frames(load("res://assets/sprite_frames/overworld/characters/character_alert.tres"))
	add_child(warning_sprite)


func setup_player():
	ray_cast = RayCast2D.new()
	ray_cast.position = Vector2(0,5)
	ray_cast.scale.x = 10
	ray_cast.target_position = Vector2(0,ray_cast_range)
	ray_cast.collide_with_areas = true
	ray_cast.collide_with_bodies = false
	ray_cast.hit_from_inside = true
	ray_cast.add_exception(interactable)
	add_child(ray_cast)
	vars.main_writer.unpaused.connect(func(): input_enabled = false)
	vars.main_writer.done.connect(func(): input_enabled = true)

func set_warning_position():
	var texture := sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	warning_sprite.position = Vector2(texture.get_size().x - 10,-15)

func event():
	event_called.emit()

func _process(delta):
	if(vars.player_character == self):
		settings.player_save.data.position = global_position
		settings.player_save.data.animation = sprite.animation
		if(snap_camera):
			camera_movement()
	if(auto_sprite_update):
		sprite_update()

func _physics_process(delta):
	if(vars.player_character == self && input_enabled && !cutscene):
		inputs()
	velocity = Vector2(x,y) * speed
	move_and_slide()
	if(is_instance_valid(ray_cast)):
		var target_rotation = 0.0
		match(sprite.animation):
			"up":
				target_rotation = 180.0
			"down":
				target_rotation = 0.0
			"left":
				target_rotation = 90.0
			"right":
				target_rotation = 270.0
		ray_cast.rotation_degrees = target_rotation

func inputs():
	x = 0
	y = 0
	if(Input.is_action_pressed("right")): x = 1.0
	if(Input.is_action_pressed("down")): y = 1.0
	if(Input.is_action_pressed("left")): x = -1.0
	if(Input.is_action_pressed("up")): y = -1.0
	#if(Input.is_action_pressed("exit")):
		#x *= 1.5
		#y *= 1.5
	sprite.speed_scale = max(abs(x), abs(y))
	if(Input.is_action_just_pressed("confirm")):
		if(ray_cast.get_collider() is Interactable):
			ray_cast.get_collider().event()

func camera_movement():
	if(is_instance_valid(vars.scene_cam) && vars.scene is OverworldRoom):
		(vars as vars).scene_cam.global_position = global_position
		(vars as vars).scene_cam.limit_top = -vars.scene.get_room_size().y / 2
		(vars as vars).scene_cam.limit_bottom = vars.scene.get_room_size().y / 2
		(vars as vars).scene_cam.limit_left = -vars.scene.get_room_size().x / 2
		(vars as vars).scene_cam.limit_right = vars.scene.get_room_size().x / 2

func sprite_update():
	var frame = sprite.frame
	var frame_progress = sprite.frame_progress
	match(sprite.animation):
		"right":
			if(x<=0 || velocity.x == 0.0):
				if(x<0): sprite.animation = "left"
				if(y>0): sprite.animation = "down"
				elif(y<0): sprite.animation = "up"
		"left":
			if(x>=0 || velocity.x == 0.0):
				if(x>0): sprite.animation = "right"
				if(y>0): sprite.animation = "down"
				elif(y<0): sprite.animation = "up"
		"down":
			if(y<=0 || velocity.y == 0.0):
				if(y<0): sprite.animation = "up"
				if(x>0): sprite.animation = "right"
				elif(x<0): sprite.animation = "left"
					
		"up":
			if(y>=0 || velocity.y == 0.0):
				if(y>0): sprite.animation = "down"
				if(x>0): sprite.animation = "right"
				elif(x<0): sprite.animation = "left"
	if(velocity != Vector2.ZERO):
		sprite.set_frame_and_progress(frame, frame_progress)
		if(!sprite.is_playing()):
			if(vars.player_character == self): settings.player_save.data.step_encounter[0] += 1
			sprite.frame = 1
			sprite.play(sprite.animation)
	if(velocity == Vector2.ZERO):
		sprite.stop()
		sprite.frame = 0

func get_position_on_screen() -> Vector2:
	return Vector2(320,240) + global_position - vars.scene_cam.get_screen_center_position()

func move_to(new_position : Vector2, move_speed : float = 0.5):
	while(true):
		if global_position.distance_to(new_position) <= move_speed:
			global_position = new_position
			x = 0
			y = 0
			break
		if(global_position.direction_to(new_position).x > 0): x = move_speed
		elif(global_position.direction_to(new_position).x < 0): x = -move_speed
		if(global_position.direction_to(new_position).y > 0): y = move_speed
		elif(global_position.direction_to(new_position).y < 0): y = -move_speed
		await get_tree().process_frame
