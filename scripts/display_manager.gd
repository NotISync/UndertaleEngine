extends Node2D
class_name DisplayManager
signal fade_done
signal start_room

@onready var camera := $camera
@onready var game_camera := $container/sub_viewport/camera
@onready var border = $container/sub_viewport/border
@onready var border_image = $container/sub_viewport/border/border_image
@onready var game = $container/sub_viewport/game
@onready var game_outline = $container/sub_viewport/game/game_outline
@onready var game_viewport := get_node_or_null("container/sub_viewport/game/game_container/sub_viewport")
@onready var quitting_text := $container/sub_viewport/game/quit
@onready var scene_viewport := get_node_or_null("container/sub_viewport/game/game_container/sub_viewport/scene_container/sub_viewport")
@onready var game_screen := $container/sub_viewport/game/game_container/sub_viewport/game_screen
@onready var game_shaders := $container/sub_viewport/game/game_container/sub_viewport/game_shaders
@onready var fade_overlay := $container/sub_viewport/game/game_container/sub_viewport/fade_overlay
@onready var screen := $screen
@onready var screen_shaders := $shaders

#var starting_scene = load("res://scenes/intro.tscn") #if you are gonna use this for rooms, do not use a save system.
#var starting_scene = load("res://scenes/battles/example_battles/battle_example.tscn")
var starting_scene = load("res://scenes/battles/example_battles/battle_example_asgore.tscn")
#var starting_scene = load("res://scenes/battles/example_battles/battle_example_whydyoujump.tscn")
#var starting_scene = load("res://scenes/rooms/example_rooms/room_water2.tscn")
#var starting_scene = load("res://scenes/rooms/example_rooms/room_0.tscn")
#var starting_scene = load("res://scenes/rooms/example_rooms/judgement_hall.tscn")
#var starting_scene = load("res://scenes/rooms/example_rooms/test_room.tscn")
var current_scene = null
var camera_intensity = 0.0
var camera_shake_spd = 0.8
var timer = 0
var camera_shake_tween = null
var global_timer = 0.0

var fade_tween

var fun := randi()

func _ready() -> void:
	vars.display = self
	await get_tree().process_frame
	restart_scene()

func restart_scene():
	await get_tree().process_frame
	change_scene(starting_scene)

func change_scene(path : Variant, fadeout = true, fadetime = .3, update_current_scene = true) -> Node:
	if(update_current_scene): current_scene = path
	for i in scene_viewport.get_children():
		i.queue_free()
	var scene = path.instantiate()
	vars.scene = scene
	scene_viewport.add_child(scene)
	if(fadeout):
		fade_out(fadetime)
	await get_tree().process_frame
	if(scene is OverworldRoom):
		settings.player_save.data.position = scene.room_spawnpoint.position
		settings.player_save.data.animation = "down"
	if(camera_shake_tween):
		camera_shake_tween.kill()
	camera_intensity = 0.0
	start_room.emit()
	return scene

func change_room(to_room : int, to_changer : int, fades : bool = true , fadetime = .3):
	if(fades):
		await fade_in(fadetime)
	for i in scene_viewport.get_children():
		i.queue_free()
	var room = OverworldRoom.rooms[to_room].instantiate() #change_scene(,true)
	vars.scene = room
	settings.player_save.data.player_room = to_room
	scene_viewport.add_child(room)
	if(fades):
		fade_out(fadetime)
	match(to_changer):
		-3: pass
		-2:
			settings.player_save.data.position = room.room_savepos.position
			settings.player_save.data.animation = "down"
		-1:
			settings.player_save.data.position = room.room_spawnpoint.position
			settings.player_save.data.animation = "down"
		_:
			for i in room.room_changers:
				if(i.changer == to_changer):
					settings.player_save.data.position = i.player_spawn.global_position
					settings.player_save.data.animation = i.animation_when_tp_here
	if(camera_shake_tween):
		camera_shake_tween.kill()
	camera_intensity = 0.0
	start_room.emit()
	return room

func fade_out(time : float, from_color : Color = Color(0,0,0,1), to_color : Color = Color(0,0,0,0)):
	fade_overlay.color = from_color
	if(fade_tween):
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(fade_overlay, "color", to_color, time)
	await fade_tween.finished
	fade_done.emit()

func fade_in(time : float, from_color : Color = Color(0,0,0,0), to_color : Color = Color(0,0,0,1)):
	fade_overlay.color = from_color
	if(fade_tween):
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(fade_overlay, "color", to_color, time)
	await fade_tween.finished
	fade_done.emit()

func screen_shake(amount : float, duration : float = 0.25) -> void:
	if(camera_shake_tween):
		camera_shake_tween.kill()
	camera_shake_tween = create_tween()
	camera_shake_tween.tween_method(func(value): camera_intensity = value, amount, 0.0, duration)

func _process(delta):
	global_timer += delta
	timer += (60 * delta)
	if(is_instance_valid(vars.scene_cam)):
		vars.scene_cam.offset = Vector2(sin(timer*camera_shake_spd) * (camera_intensity / 2.0), -cos((timer*camera_shake_spd)/1.15) * (camera_intensity / 2.0))
