extends AttackAnimation

@onready var sprite = $sprite

func attack_animation():
	vars.display.screen_shake(5)
	self.global_position = enemy.global_position
	if(vars.hud_manager.eye.reticles_perfect_hit >= 3 && vars.hud_manager.eye.score > (settings.player_save.get_weapon().reticles-1)*110):
		audio.play("weapons/snd_saber3")
		self.modulate.b = 0.5
	self.visible = true
	sprite.play()
	audio.play("weapons/mus_sfx_ballet_shoes")
	sprite.animation_finished.connect(func(): sprite.visible = false)
	await get_tree().create_timer(0.5, false).timeout
	hit_finish.emit()
