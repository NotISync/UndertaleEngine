extends Node
class_name Attack

var attack_started := false
var current_frames := 0.0
var frames := 0.0
signal attack_finished

func pre_attack():
	vars.battle_box.resize_mode = 1
	vars.battle_box.set_box_size([250,250,390,390],500)
	vars.player_heart.visible = true
	vars.player_heart.global_position = Vector2(320, 320)

func start_attack():
	vars.player_heart.input_enabled = true
	attack_started = true

func end_attack():
	vars.battle_box.resize_mode = 2
	vars.hud_manager.reset()
	settings.player_save.get_weapon().turn_effect()
	settings.player_save.get_armor().turn_effect()
	attack_finished.emit()
	queue_free()

func _process(delta):
	if(attack_started):
		current_frames += delta * 60
		if(current_frames > frames):
			current_frames = 0
			end_attack()
