extends Node2D
class_name AfterImage

var trail_length := 6
var trail_spacing := 0.02

var texture
var sprite

var trail_transform: Array = []
var trail_timer := 0.0

func _process(delta):
	trail_timer += delta
	if(trail_timer >= trail_spacing):
		trail_spacing = 0.0
		
		if(sprite == null || !visible):
			return
			
		modulate = sprite.modulate
		self_modulate = sprite.self_modulate
		match(sprite.get_class()):
			"Sprite2D":
				texture = sprite.texture
			"AnimatedSprite2D":
				texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
		
		trail_transform.push_front({
			"position": sprite.global_position, 
			"rotation": sprite.global_rotation,
			"scale": sprite.global_scale,
			"skew": sprite.global_skew,
			"offset": sprite.offset,
			"texture": texture
		})
		
		if trail_transform.size() > trail_length:
			trail_transform.pop_back()
			
		queue_redraw()

func _draw():
	if texture == null:
		return
	
	for i in range(trail_transform.size() - 1, -1, -1):
		var tex_size = texture.get_size()
		var t = float(i) / max(1.0, trail_transform.size() - 1.0)
		var c = Color(1, 1, 1, 1)
		c.a = lerp(0.0, c.a, 1.0 - t)
		
		var local_pos = to_local(trail_transform[i].position)
		var xf = Transform2D(trail_transform[i].rotation, trail_transform[i].scale, trail_transform[i].skew, local_pos)
		
		
		draw_set_transform_matrix(xf)
		draw_texture(trail_transform[i].texture, (-tex_size / 2) + trail_transform[i].offset, c)
		
	draw_set_transform_matrix(Transform2D.IDENTITY)
