extends AttackAnimation

@onready var sprite = $sprite

var radius := 0.0
var particle_1 = []
var particle_2 = []
var circle = false

func attack_animation():
	self.global_position = enemy.global_position
	if(vars.hud_manager.eye.reticles_perfect_hit >= 3 && vars.hud_manager.eye.score > (settings.player_save.get_weapon().reticles-1)*110):
		audio.play("weapons/snd_saber3")
		self.modulate.b = 0.5
	self.visible = true
	sprite.play()
	sprite.animation_finished.connect(sprite_finish)
	audio.play("weapons/mus_sfx_gunshot")
	create_tween().tween_property(sprite, "scale", Vector2(0.25, 0.25), 0.75).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	create_tween().tween_property(self, "modulate:a", 0.0, .25).set_trans(Tween.TRANS_SINE).set_delay(.5)
	await get_tree().create_timer(.75, false).timeout
	hit_finish.emit()

func sprite_finish():
	sprite.self_modulate.a = 0
	circle = true
	particle_1_spawn()
	particle_2_spawn()
	for i in particle_1:
		create_tween().tween_property(i, "scale", Vector2(0.25, 0.25), 0.5)
		i.play()
	
func _process(delta):
	if(circle):
		radius += 100
	sprite.rotation_degrees = -radius/10
	for i in range(particle_1.size()):
		var formula = deg_to_rad(i * 22.5 + 90)+(2*PI)*(i/8)
		particle_1[i].offset = (Vector2((radius-100) * cos(formula), (radius-100) * sin(formula)))/20

func particle_1_spawn():
	for i in range(8):
		var spriteparticle = AnimatedSprite2D.new()
		var animation = SpriteFrames.new()
		animation.add_frame("default", load("res://assets/sprites/battle/hud/weapons/gun/0.png"))
		animation.add_frame("default", load("res://assets/sprites/battle/hud/weapons/gun/1.png"))
		animation.set_animation_speed("default", 15)
		animation.set_animation_loop("default", true)
		spriteparticle.position = sprite.position
		spriteparticle.sprite_frames = animation
		var formula = deg_to_rad(i * 22.5 + 90)+(2*PI)*(i/8)
		spriteparticle.rotation_degrees = rad_to_deg(formula) + 90
		sprite.add_child(spriteparticle)
		particle_1.append(spriteparticle)
func particle_2_spawn():
	for i in range(3):
		var particle = Sprite2D.new()
		particle.texture = load("res://assets/sprites/battle/hud/weapons/gun/circle.png")
		particle.scale = Vector2(0.5, 0.5)
		add_child(particle)
		move_child(particle, 0)
		create_tween().tween_property(particle, "scale", Vector2(3.5, 3.5), .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		var alpha = create_tween()
		alpha.tween_property(particle, "modulate:a", 0.0, .5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
		alpha.finished.connect(func(): particle.queue_free())
		await get_tree().create_timer(.1, false).timeout
		
