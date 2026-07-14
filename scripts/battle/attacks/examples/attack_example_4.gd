extends Attack

var a_vars : vars = vars

func _init():
	frames = 600

func pre_attack():
	super.pre_attack()
	a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.blue
	a_vars.battle_box.set_box_size([130,250,510,390])
	a_vars.player_heart.global_position = Vector2(320, 377)

func start_attack():
	super.start_attack()
	attack()

func attack():
	a_vars
