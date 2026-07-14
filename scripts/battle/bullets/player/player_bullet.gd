extends Bullet
class_name BPlayerBullet

var charge = false
var hitbox
var tween = []

func _init():
	damage = 1.0
	karma = 0.0

func _ready():
	hitbox = $normal/area/collision if(!charge)else $charged/area/collision
	$normal.visible = !charge
	$normal/area/collision.disabled = charge
	$charged.visible = charge
	$charged/area/collision.disabled = !charge
	if(charge):
		create_tween().tween_method(
		func(val): 
			x = val.x
			y = val.y
		, Vector2.ZERO, Vector2(x, y), 1)
		create_tween().tween_method(func(val): scale.y = val, 0.0, 1.0, 0.5)
	else:
		tween = create_tween()
		tween.tween_property(self, "scale:y", 2.0, 0.5)

func deflect():
	if(!charge):
		vars.player_heart.bullet = null
		x = randf_range(-3, 3)
		y = 4
		rotation_speed = randf_range(-90, 90)
		$normal/area/collision.disabled = true
	
func hit():
	if(!charge):
		if(tween): tween.kill()
		vars.player_heart.bullet = null
		scale = Vector2.ONE
		x = 0
		y = 0
		$normal/area/collision.disabled = true
		$normal/sprite.play("hit")
		$normal/sprite.animation_finished.connect(func(): queue_free())


func _on_offscreen_screen_exited():
	queue_free()
