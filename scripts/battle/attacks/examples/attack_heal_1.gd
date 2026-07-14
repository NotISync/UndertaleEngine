extends Attack

var a_vars : vars = vars

func _init():
	frames = 200

func start_attack():
	super.start_attack()
	a_vars.attack_manager.gaster_blaster(0, Vector2(320, -20), Vector2(320, 120), 0, Vector2(1, 1), 30, 15, false)
