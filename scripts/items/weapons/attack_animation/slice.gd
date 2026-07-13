extends AttackAnimation

@onready var sprite = $sprite

func attack_animation():
	self.global_position = enemy.global_position
	self.visible = true
	var distance = ((546 - vars.hud_manager.eye.distance)/546)
	sprite.scale = Vector2(distance, distance)
	sprite.play()
	audio.play("weapons/strike")
	sprite.animation_finished.connect(func(): sprite.visible = false)
	await get_tree().create_timer(0.75, false).timeout
	hit_finish.emit()
