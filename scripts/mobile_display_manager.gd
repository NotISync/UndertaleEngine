extends Node2D

@onready var game_container = $container
@onready var game_viewport = $container/sub_viewport
var screen_size = Vector2(int(DisplayServer.screen_get_size().x*1.7778), DisplayServer.screen_get_size().x)
var game_size = float(DisplayServer.screen_get_size().y) / 640

func _ready():
	vars.mobile_controls = $touch_controls
	vars.mobile_controls.touch_buttons.modulate.a = 0.5
	vars.mobile_controls.joystick.knob.modulate.a = 0.5
	vars.mobile_controls.joystick.ring.modulate.a = 0.5
	game_container.size = screen_size
	game_viewport.size = screen_size
	game_container.position = Vector2((DisplayServer.screen_get_size().x/2)-(screen_size.x/2), 0)
	vars.mobile_controls.joystick.scale = Vector2(game_size, game_size)
	vars.mobile_controls.joystick.position = Vector2(120*vars.mobile_controls.joystick.scale.x, screen_size.y - 120*vars.mobile_controls.joystick.scale.y)
	vars.mobile_controls.touch_buttons.scale = Vector2(game_size, game_size)
	vars.mobile_controls.touch_buttons.position = Vector2(DisplayServer.screen_get_size().x - 200*vars.mobile_controls.touch_buttons.scale.x, screen_size.y - 120*vars.mobile_controls.touch_buttons.scale.y)
	screen_size = Vector2(int(DisplayServer.screen_get_size().y*1.7778), DisplayServer.screen_get_size().y)
	game_size = float(DisplayServer.screen_get_size().x) / 640
	
func _process(delta):
	game_container.size = screen_size
	game_viewport.size = screen_size
	game_container.position = Vector2((DisplayServer.screen_get_size().x/2)-(screen_size.x/2), 0)
	vars.mobile_controls.joystick.scale = Vector2(game_size, game_size)
	vars.mobile_controls.joystick.position = Vector2(120*vars.mobile_controls.joystick.scale.x, screen_size.y - 120*vars.mobile_controls.joystick.scale.y)
	vars.mobile_controls.touch_buttons.scale = Vector2(game_size, game_size)
	vars.mobile_controls.touch_buttons.position = Vector2(DisplayServer.screen_get_size().x - 200*vars.mobile_controls.touch_buttons.scale.x, screen_size.y - 120*vars.mobile_controls.touch_buttons.scale.y)
	screen_size = Vector2(int(DisplayServer.screen_get_size().y*1.7778), DisplayServer.screen_get_size().y)
	game_size = float(DisplayServer.screen_get_size().x) / 640
