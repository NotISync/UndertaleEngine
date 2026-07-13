extends AttackAnimation

@onready var sprite = $sprite

func attack_animation():
	self.global_position = enemy.global_position
	if(vars.hud_manager.eye.reticles_perfect_hit >= 3 && vars.hud_manager.eye.score > (settings.player_save.get_weapon().reticles-1)*110):
		audio.play("weapons/snd_saber3")
		self.modulate.b = 0.5
	self.visible = true
	create_tween().tween_property(sprite, "self_modulate:a",0,0.25)
	create_tween().tween_property(sprite, "rotation_degrees",-45,0.5)
	sprite.play()
	for i in range(8):
		var spriteparticle = Sprite2D.new()
		spriteparticle.position = sprite.position
		spriteparticle.texture = load("res://assets/sprites/battle/hud/weapons/pan/small.png")
		add_child(spriteparticle)
		move_child(spriteparticle, 0)
		create_tween().tween_property(spriteparticle, "self_modulate:a",0,0.75)
		create_tween().tween_property(spriteparticle, "rotation_degrees",90,0.75)
		create_tween().tween_property(spriteparticle, "position",sprite.position + Vector2(80*sin(i*(2*PI/8)), 80*cos(i*(2*PI/8))),0.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	audio.play("weapons/mus_sfx_frypan")
	await get_tree().create_timer(0.5, false).timeout
	hit_finish.emit()
