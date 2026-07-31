extends Node2D
class_name AfterImage

var trail_length := 6
var trail_spacing := 0.02
var starting_alpha := 1.0

var texture
@export var sprite = null

var trail_transform: Array = []
var trail_timer := 0.0

func _process(delta):
	trail_timer += delta
	if(trail_timer >= trail_spacing):
		trail_timer = 0.0
		
		if(sprite == null || !visible):
			return
			
		modulate = sprite.modulate
		self_modulate = sprite.self_modulate
		match(sprite.get_class()):
			"Sprite2D":
				texture = sprite.texture
			"AnimatedSprite2D":
				texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
		
		var frame = {
			"position": sprite.global_position, 
			"rotation": sprite.global_rotation,
			"scale": sprite.global_scale,
			"skew": sprite.global_skew,
			"offset": sprite.offset,
			"color": sprite.modulate * sprite.self_modulate,
			"flip_h": sprite.flip_h,
			"flip_v": sprite.flip_v,
			"is_centered": sprite.is_centered(),
			"texture": texture
		}
		
		trail_transform.push_front(frame)
		
		create_tween().tween_method(func(n): frame.color.a = n, starting_alpha, 0.0, 1.0)
		
		if trail_transform.size() > trail_length:
			trail_transform.pop_back()
			
	queue_redraw()

func _draw():
	if texture == null:
		return
	
	for i in range(trail_transform.size() - 1, -1, -1):
		var local_pos = to_local(trail_transform[i].position)
		var xf = Transform2D(trail_transform[i].rotation, trail_transform[i].scale, trail_transform[i].skew, local_pos)
		var is_centered = (-trail_transform[i].texture.get_size() / 2) if trail_transform[i].is_centered else Vector2.ZERO
		
		draw_set_transform_matrix(xf)
		draw_texture(trail_transform[i].texture, is_centered + trail_transform[i].offset, trail_transform[i].color)
		
	draw_set_transform_matrix(Transform2D.IDENTITY)
