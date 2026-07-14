extends Bullet
class_name BBox

@onready var box := $battle_box
@onready var mask_box := $box_mask
@onready var collision := $battle_box/collisions

@onready var margin = box.margin :
	set(value):
		margin = value
		box.offset_left = value[0]
		box.offset_top = value[1]
		box.offset_right = value[2]
		box.offset_bottom = value[3]
		box.margin = value
		box.target = value
		mask_box.offset_left = value[0]
		mask_box.offset_top = value[1]
		mask_box.offset_right = value[2]
		mask_box.offset_bottom = value[3]
		mask_box.margin = value
		mask_box.target = value
