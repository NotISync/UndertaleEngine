extends Bullet
class_name BAsgoreSwipe

signal done

@onready var spr := $sprite
@onready var spear := $spear
@onready var hitbox := $area
@onready var hitbox_col := $area/collision

func swipe(type : Bullet.e_type, speed : float = 1.0, backwards : bool = false):
	self.type = type
	spr.frame = 0
	spear.frame = 0
	spr.flip_h = backwards
	spear.flip_h = backwards
	spr.play(&"default", speed)
	spr.animation_finished.connect(
		func():
			spr.flip_h = !backwards
			spr.frame = 0
			, Object.ConnectFlags.CONNECT_ONE_SHOT)
	spear.play(&"default", speed)
	spear.animation_finished.connect(
		func():
			spear.flip_h = !backwards
			spear.frame = 0
			, Object.ConnectFlags.CONNECT_ONE_SHOT)

func _init():
	curse = e_curse.none
	damage = 5

func _ready():
	pass

func change_color():
	match(type):
		e_type.blue, e_type.blue_control:
			spear.modulate = Color(0,.64,.91,modulate.a)
		e_type.orange, e_type.orange_control:
			spear.modulate = Color(1,.63,.25,modulate.a)
		e_type.green:
			spear.modulate = Color(0,1,0,modulate.a)
		_:
			spear.modulate = Color.WHITE
			
func _on_spear_frame_changed() -> void:
	if(spear.frame == 5): audio.play("battle/mus_sfx_cinematiccut")
	hitbox_col.disabled = !(spear.frame == 5 || spear.frame == 6)
