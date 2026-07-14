extends Bullet
class_name CoolerBBone

@onready var sprite := $coolerbone
@onready var collision := $coolerbone/area/collision
@onready var collisionhitbox := $coolerbone/area/collisionhitbox

func _init():
	curse = e_curse.karma
	damage = 1
	karma = 1

func _ready():
	super._ready()
	area2d = $coolerbone/area

func _process(delta):
	pass

func _physics_process(delta):
	global_position += Vector2(x,y) * speed * delta
	#sprite.rotation_degrees += rotation_speed * delta
	duration_tick(delta)
	if(gravity_enabled):
		global_position.y += gravity_drag.y * delta
		gravity_drag.y += max(abs(gravity_drag.y),200) * delta * 2
		global_position.x += gravity_drag.x * delta
		rotation_degrees += gravity_drag.x * 2 * delta
