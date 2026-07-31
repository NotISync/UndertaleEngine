extends NinePatchRect

@onready var mask = $mask
@onready var tail = $tail

var tail_side := "left" :
	set(value):
		tail_side = value
		_on_item_rect_changed()
var tail_pos := 22 : 
	set(value):
		tail_pos = value
		_on_item_rect_changed()

func _ready():
	_on_item_rect_changed()

func _process(delta):
	pivot_offset = size/2.0

func tail_texture(path : Variant):
	tail.texture = path
	mask.texture = path

func get_tail_top_left():
	match(tail_side):
		"left", "right":
			return 22
		"top", "bottom":
			return 9
	
func get_tail_bottom_right():
	match(tail_side):
		"left", "right":
			return size.y-40
		"top", "bottom":
			return size.x-53
	
func get_tail_middle():
	match(tail_side):
		"left", "right":
			return round(size.y/2)-9
		"top", "bottom":
			return round(size.x/2)-22

func _on_item_rect_changed():
	match(tail_side):
		"left":
			mask.set_anchors_preset(Control.PRESET_CENTER_LEFT)
			tail.set_anchors_preset(Control.PRESET_CENTER_LEFT)
			mask.position = Vector2(-22, tail_pos)
			tail.position = Vector2(-22, tail_pos)
		"top":
			mask.set_anchors_preset(Control.PRESET_CENTER_TOP)
			tail.set_anchors_preset(Control.PRESET_CENTER_TOP)
			mask.position = Vector2(tail_pos, -9)
			tail.position = Vector2(tail_pos, -9)
		"right":
			mask.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
			tail.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
			mask.position = Vector2(size.x-22, tail_pos)
			tail.position = Vector2(size.x-22, tail_pos)
		"bottom":
			mask.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
			tail.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
			mask.position = Vector2(tail_pos, size.y-9)
			tail.position = Vector2(tail_pos, size.y-9)
	match(tail_side):
		"left", "top":
			mask.scale.x = 1
			tail.scale.x = 1
		"right", "bottom":
			mask.scale.x = -1
			tail.scale.x = -1
	match(tail_side):
		"left", "right":
			mask.rotation_degrees = 0
			tail.rotation_degrees = 0
		"top", "bottom":
			mask.rotation_degrees = 90
			tail.rotation_degrees = 90
