extends Node

var player_save : PlayerSave = null
var death_position : Vector2 = Vector2.ZERO
var last_window_position = DisplayServer.window_get_position() #Fullscreen Border Offset Fix!
var window_borders := false :
	set(value):
		window_borders = value
		toggle_borders()
var debug_enabled := OS.is_debug_build() #Disable in public builds
var exit_countdown = 0
var pause_tweens = []
var fullscreen_disabled := false

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	start()
	if(!settings.debug_enabled): load_game()
	else: reset_game()
	await get_tree().process_frame
	window_borders = true

func start() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	DisplayServer.window_set_mode(0)
	get_viewport().size = Vector2(640,480)

func restart_game():
	if(is_instance_valid(vars.scene)):
		audio.stop_music()
		audio.stop_all_sounds()
		vars.scene.queue_free()
		vars.display.game_shaders.active_shaders.clear()
		vars.display.screen_shaders.active_shaders.clear()
		for i in vars.display.game_shaders.get_children(): i.queue_free()
		for i in vars.display.screen_shaders.get_children(): i.queue_free()
		load_game()
		vars.display.restart_scene()

func reset_game():
	player_save = PlayerSave.new()
	save_game()

func load_game():
	if(ResourceLoader.exists("user://saved.tres")):
		var old_player_save = player_save
		player_save = ResourceLoader.load("user://saved.tres").duplicate()
		player_save.data.death_count = old_player_save.data.death_count
	else:
		reset_game()

func save_game():
	ResourceSaver.save(player_save, "user://saved.tres")
	
func _process(delta):
	match(settings.player_save.player.name.to_lower()):
		"frisk": settings.player_save.data.hard_mode = true
		"tiny": settings.player_save.inventory = ["cookie", "cookie", "cookie", "cookie", "cookie", "cookie", "cookie", "cookie"]
	if(Input.is_action_pressed("quit")):
		exit_countdown += 1
		vars.display.quitting_text.visible = true
		vars.display.quitting_text.modulate.a += (1 - vars.display.quitting_text.modulate.a)/16
		if(exit_countdown % 30 == 0) :
			vars.display.quitting_text.text += "."
		if(exit_countdown == 90):
			get_tree().quit()
	else:
		exit_countdown = 0
		vars.display.quitting_text.visible = false
		vars.display.quitting_text.modulate.a = 0
		vars.display.quitting_text.text = "QUITTING"
	if(Input.is_action_just_pressed("pause")):
		get_tree().paused = !get_tree().paused
	if(Input.is_action_just_pressed("restart") && settings.debug_enabled):
		restart_game()
	if(Input.is_action_just_pressed("fullscreen") && !Input.is_action_pressed("alt") && !fullscreen_disabled):
		toggle_resolution()
	if(Input.is_action_just_pressed("border") && settings.debug_enabled):
		window_borders = !window_borders
	if(player_save != null):
		player_save.data.time += delta

func toggle_resolution():
	match(DisplayServer.window_get_mode()):
		0:
			last_window_position = DisplayServer.window_get_position()
			DisplayServer.window_set_mode(3)
			vars.display.camera.zoom = Vector2(int(DisplayServer.screen_get_size().y*1.3333), DisplayServer.screen_get_size().y) / Vector2(640,480)
			#vars.display.camera.zoom = Vector2(DisplayServer.screen_get_size()) / Vector2(853.3333, 480)
		3:
			DisplayServer.window_set_mode(0)
			vars.display.camera.zoom = Vector2(1, 1)
			if(window_borders):
				get_viewport().position = DisplayServer.window_get_position() - Vector2i(160, 30)
			else:
				get_viewport().position = DisplayServer.window_get_position() + Vector2i(160, 30)
	toggle_borders(true)

func toggle_borders(toggle_fullscreen : bool = false):
	if(window_borders):
		vars.display.border.visible = true
		vars.display.game_outline.visible = true
		match(DisplayServer.window_get_mode()):
			0:
				get_viewport().size = Vector2(960,540)
				get_viewport().position = ((last_window_position)if(toggle_fullscreen)else(DisplayServer.window_get_position())) - Vector2i(160, 30)
				last_window_position = DisplayServer.window_get_position()
			3:
				vars.display.camera.zoom = Vector2(int(DisplayServer.screen_get_size().y*1.7778), DisplayServer.screen_get_size().y) / Vector2(960,540)
				last_window_position += Vector2i(160, 30)
	else:
		vars.display.border.visible = false
		vars.display.game_outline.visible = false
		match(DisplayServer.window_get_mode()):
			0:
				get_viewport().size = Vector2(640,480)
				get_viewport().position = ((last_window_position)if(toggle_fullscreen)else(DisplayServer.window_get_position())) + Vector2i(160, 30)
				last_window_position = DisplayServer.window_get_position()
			3:
				vars.display.camera.zoom = Vector2(int(DisplayServer.screen_get_size().y*1.3333), DisplayServer.screen_get_size().y) / Vector2(640,480)
				last_window_position -= Vector2i(160, 30)
