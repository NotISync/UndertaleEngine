extends Node2D

@onready var buttons = get_children()

var spacing = 10

func _process(delta):
	for i in get_child_count():
		buttons[i].position.x = (54+spacing)*i
