extends Node2D
class_name OverworldRoom

static var rooms = {
	0 : load("res://scenes/rooms/example_rooms/room_0.tscn"),
	1 : load("res://scenes/rooms/example_rooms/judgement_hall.tscn"),
	2 : load("res://scenes/rooms/example_rooms/room_water2.tscn"),
}

var player_character : Character
var room_sprite
var room_changers : Array[RoomChanger] = []
var room_spawnpoint
var room_savepos

func _ready():
	vars.main_writer = get_node("overworld_canvas/message_border/overworld_writer")
	vars.overworld_hud = get_node("overworld_canvas/overworld_hud")
	vars.scene_cam = get_node("camera")
	await vars.display.start_room
	player_character = Character.new(load("res://assets/sprite_frames/overworld/characters/frisk.tres"))
	player_character.scale = Vector2(2,2)
	add_child(player_character)
	player_character.global_position = settings.player_save.data.position
	player_character.sprite.animation = settings.player_save.data.animation
	player_character.setup_player()
	vars.player_character = player_character

func go_to_battle_anim(end_location : Vector2):
	audio.stop_music()
	vars.player_character.input_enabled = false
	var black_screen := ColorRect.new()
	black_screen.color = Color.BLACK
	black_screen.position = Vector2(-2500,-2500)
	black_screen.size = Vector2(5000,5000)
	black_screen.z_index = 4096
	add_child(black_screen)
	var heart_sprite := Sprite2D.new()
	heart_sprite.set_texture(load("res://assets/sprites/battle/heart/small_heart.png"))
	heart_sprite.scale = Vector2(2, 2)
	heart_sprite.z_index = 4096
	heart_sprite.global_position = vars.player_character.global_position
	heart_sprite.self_modulate = Color(1,0,0,1)
	add_child(heart_sprite)
	await get_tree().create_timer(.1).timeout
	heart_sprite.visible = false
	audio.play("battle/noise")
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = true
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = false
	audio.play("battle/noise")
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = true
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = false
	audio.play("battle/noise")
	await get_tree().create_timer(.05).timeout
	heart_sprite.visible = true
	var tween = create_tween()
	tween.tween_property(heart_sprite, "global_position", vars.scene_cam.get_screen_center_position() + end_location, .7)
	audio.play("overworld/snd_battlefall")
	await tween.finished

func get_room_size() -> Vector2:
	return room_sprite.get_texture().get_size() * room_sprite.scale

func get_place_text() -> String:
	return ""

#roomname= " ";
#if(argument0 == 0) roomname= "--";
#if(argument0 == real(6)) roomname= "Ruins - Entrance";
#if(argument0 == real(12)) roomname= "Ruins - Leaf Pile";
#if(argument0 == real(18)) roomname= "Ruins - Mouse Hole";
#if(argument0 == real(31)) roomname= "Ruins - Home";
#if(argument0 == real(44)) roomname= "Snowdin - Ruins Exit";
#if(argument0 == real(46)) roomname= "Snowdin - Box Road";
#if(argument0 == real(56)) roomname= "Snowdin - Spaghetti";
#if(argument0 == real(61)) roomname= "Snowdin - Dog House";
#if(argument0 == real(68)) roomname= "Snowdin - Town";
#if(argument0 == real(83)) roomname= "Waterfall - Checkpoint";
#if(argument0 == real(86)) roomname= "Waterfall - Hallway";
#if(argument0 == real(94)) roomname= "Waterfall - Crystal";
#if(argument0 == real(110)) roomname= "Waterfall - Bridge";
#if(argument0 == real(114)) roomname= "Waterfall - Trash Zone";
#if(argument0 == real(116)) roomname= "Waterfall - Quiet Area";
#if(argument0 == real(128))
	#roomname= "Waterfall - Temmie Village";
#if(argument0 == real(134))
	#roomname= "Waterfall - Undyne Arena";
#if(argument0 == real(164))
	#roomname= "Hotland - Bad Opinion Zone";
#if(argument0 == real(139))
	#roomname= "Hotland - Laboratory Entrance";
#if(argument0 == real(145)) roomname= "Hotland - Magma Chamber";
#if(argument0 == real(155)) roomname= "Hotland - Core View";
#if(argument0 == real(176))
	#roomname= "Hotland - Spider Entrance";
#if(argument0 == real(183)) roomname= "Hotland - Hotel Lobby";
#if(argument0 == real(196)) roomname= "Hotland - Core Branch";
#if(argument0 == real(210)) roomname= "Hotland - Core End";
#if(argument0 == real(216)) roomname= "Castle Elevator";
#if(argument0 == real(219)) roomname= "New Home";
#if(argument0 == real(231)) roomname= "Last Corridor";
#if(argument0 == real(232)) roomname= "Throne Entrance";
#if(argument0 == real(235)) roomname= "Throne Room";
#if(argument0 == real(236)) roomname= "The End";
#if(argument0 == real(246)) roomname= "True Laboratory";
#if(argument0 == real(251)) roomname= "True Lab - Bedroom";
