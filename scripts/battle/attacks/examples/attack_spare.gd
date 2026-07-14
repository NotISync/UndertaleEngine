extends Attack

var a_vars : vars = vars

func _init():
	frames = INF

func pre_attack():
	super.pre_attack()
	vars.battle_box.resize_mode = 2
	a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.red
	a_vars.battle_box.set_box_size([270,290,370,390])
	a_vars.player_heart.global_position = Vector2(320, 340)
	a_vars.enemies.get_node("sans").position.y = 202

func start_attack():
	super.start_attack()
	attack()

func attack():
	a_vars.enemies.get_node("sans").get_node("sprite_anchor/head").frame = 3
	a_vars.enemies.get_node("sans").get_node("sprite_anchor/torso").frame = 1
	var bone = a_vars.attack_manager.bone_stab(0, Vector2(242, 387), 150, 90, 15, INF, 0, true, ["", "battle/bonestab"])
	bone.warning.visible = false
