extends AttackAnimation

@onready var tip = $tip
@onready var sprite = $sprite

var mini_punches = 3

var punching = false

var punches = 0

var tip_delay = 0

signal final_hit

func attacking():
	await get_tree().create_timer((mini_punches+1)/4, false).timeout
	vars.hud_manager.eye.score = punches
	final_hit.emit()
	
func _process(delta):
	if(punching&&mini_punches>=0):
		if(tip_delay > 0):
			tip_delay -= 1
		elif(tip_delay==0):
			tip.visible = true
		if(Input.is_action_just_pressed("confirm")):
			if(mini_punches==0):
				vars.hud_manager.eye.score = punches + 1
				final_hit.emit()
			else:
				punch()
				tip_delay = 20
				tip.visible = false

func punch():
	punches += 1
	mini_punches -= 1
	var mini_sprite = sprite.duplicate()
	mini_sprite.scale = Vector2(0.5, 0.5)
	mini_sprite.visible = true
	add_child(mini_sprite)
	move_child(mini_sprite, 0)
	mini_sprite.global_position = enemy.global_position + (Vector2(enemy.sprite.sprite_frames.get_frame_texture(enemy.sprite.animation, enemy.sprite.frame).get_width(), enemy.sprite.sprite_frames.get_frame_texture(enemy.sprite.animation, enemy.sprite.frame).get_height())*Vector2(randf_range(-1, 1), randf_range(-1, 1)))
	mini_sprite.play()
	audio.play("weapons/snd_punchweak")
	mini_sprite.animation_finished.connect(func(): mini_sprite.visible = false)

func attack_animation():
	self.global_position = enemy.global_position
	self.visible = true
	tip.play()
	attacking()
	await get_tree().process_frame
	punching = true
	await final_hit
	punching = false
	tip.visible = false
	if(punches>0):
		vars.display.screen_shake(5)
		sprite.visible = true
		sprite.play()
		audio.play("weapons/snd_punchstrong")
		sprite.animation_finished.connect(func(): sprite.visible = false)
	await get_tree().create_timer(0.5, false).timeout
	hit_finish.emit()
