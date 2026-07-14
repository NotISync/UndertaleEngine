extends Node2D

func _ready():
	vars.scene_cam = $camera
	audio.play_music("menu/mus_story", audio.global_volume, 0.9, 0)

func _process(delta):
	if(Input.is_action_just_pressed("confirm") || !audio.music.playing):
		ending()

func ending():
	audio.stop_music()
	vars.display.change_scene(load("res://scenes/title_screen.tscn"),true)
