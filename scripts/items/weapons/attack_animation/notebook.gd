extends AttackAnimation

@onready var sprite = $sprite

func attack_animation():
	self.global_position = enemy.global_position
	if(vars.hud_manager.eye.reticles_perfect_hit >= 2 && vars.hud_manager.eye.score > (settings.player_save.get_weapon().reticles-1)*110):
		self.modulate.b = 0.5
	self.visible = true
	audio.play("weapons/mus_sfx_bookspin")
	var spin = create_tween()
	spin.tween_property(sprite, "scale:x", -2,0.2).set_trans(Tween.TRANS_SINE)
	await spin.finished
	spin = create_tween()
	spin.tween_property(sprite, "scale:x", 2,0.2).set_trans(Tween.TRANS_SINE)
	await spin.finished
	spin = create_tween()
	spin.tween_property(sprite, "scale:x", -2,0.2).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.1, false).timeout
	spin.kill()
	sprite.scale.x = 2
	sprite.play("hit")
	audio.play("weapons/mus_sfx_ballet_shoes")
	create_tween().tween_property(sprite, "self_modulate:a",0,0.2)
	create_tween().tween_property(sprite, "scale",Vector2(5, 5),0.2)
	if(vars.hud_manager.eye.reticles_perfect_hit >= 2 && vars.hud_manager.eye.score > (settings.player_save.get_weapon().reticles-1)*110):
		audio.play("weapons/snd_saber3")
	await get_tree().create_timer(0.25, false).timeout
	hit_finish.emit()
