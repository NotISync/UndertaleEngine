extends Node2D

@onready var text = $text
var next_scene = load("res://scenes/main_menu.tscn")
var naming_scene = load("res://scenes/name_select.tscn")

func _ready():
	vars.scene_cam = get_node("camera")
	audio.play("menu/snd_logo")
	await get_tree().create_timer(3, false).timeout
	text.visible = true

func _process(delta):
	if(Input.is_action_just_pressed("quit")):
		get_tree().quit()
	if(Input.is_action_just_pressed("confirm")):
		vars.display.change_scene(next_scene, true)
