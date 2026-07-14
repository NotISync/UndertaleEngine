extends Node2D

var prev_scene = vars.display.current_scene

var scene = vars.scene
var scene_revive = vars.scene.revive

var heart_shards: Array[Node] = []
var heart_shard_anim: AnimatedTexture = load("res://assets/sprites/battle/heart/heart_shard.tres")

func _ready() -> void:
	settings.player_save.data.death_count += 1
	vars.scene_cam = get_node("camera")
	audio.stop_music()
	audio.stop_all_sounds()
	if(scene is BattleRoom):
		if(!scene_revive):
			heart_shatter()
			await get_tree().create_timer(3.5).timeout
			audio.play_music("music/mus_gameover")
			var tween = create_tween()
			tween.tween_property($game_over,"self_modulate:a",1.0,1).set_trans(Tween.TRANS_SINE)
			await tween.finished
			$writer.writer_text = "(disable:x)(speed:0.0666667)(sound:asgore)You cannot give\nup just yet...(pc)%s!\n(delay:.5)Stay determined...(pc)" %[settings.player_save.player.name]
			await $writer.done
			await get_tree().process_frame
			while(true):
				if(Input.is_action_just_pressed("confirm")):
					break
				await get_tree().process_frame
			create_tween().tween_property(audio.music,"volume_db",-60.0,3)
			create_tween().tween_property(self,"modulate:a",0.0,1.5).set_trans(Tween.TRANS_SINE)
			await get_tree().create_timer(2.5).timeout
			audio.stop_music()
			settings.load_game()
			#vars.display.change_scene(vars.display.starting_scene, true)
			vars.display.change_room(settings.player_save.data.player_room,-2,false)
		else:
			heart_shatter()
			await get_tree().create_timer(2.5).timeout
			for i in range(120):
				vars.display.screen_shake(2)
				await get_tree().process_frame
			$heart.frame = 0
			audio.play("battle/break")
			await get_tree().create_timer(.5).timeout
			$writer.position.y = 120
			$writer.writer_text = "(disable:x)(disable:z)(speed:0.0666667)* But it refused."
			await get_tree().create_timer(2.5).timeout
			vars.display.fade_in(.3, Color(1,1,1,0), Color(1,1,1,1))
			await get_tree().create_timer(1.5).timeout
			for i in vars.display.scene_viewport.get_children():
				i.queue_free()
			var scene = prev_scene.instantiate()
			vars.display.fade_out(.6, Color(1,1,1,1), Color(1,1,1,0))
			vars.display.scene_viewport.add_child(scene)
			settings.player_save.player.current_hp = max(settings.player_save.player.current_hp, settings.player_save.player.max_hp)

func heart_shatter():
	$heart.global_position = settings.death_position
	await get_tree().create_timer(0.666667).timeout
	$heart.frame = 1
	audio.play("battle/break")
	await get_tree().create_timer(1.33333).timeout
	if(scene_revive): return
	$heart.visible = false
	audio.play("battle/break2")
	for i in 5:
		var obj: Sprite2D = Sprite2D.new()
		obj.texture = heart_shard_anim
		obj.modulate = $heart.modulate
		obj.position = $heart.position
		obj.rotation_degrees = randi() % 360
		obj.set_meta("vx", 180 * cos(obj.rotation))
		obj.set_meta("vy", 180 * sin(obj.rotation))
		add_child(obj)
		heart_shards.append(obj)

func _process(delta: float) -> void:
	if !heart_shards.is_empty(): for i in heart_shards:
		var vx: float = i.get_meta("vx")
		var vy: float = i.get_meta("vy")
		
		i.position += Vector2(vx, vy) * delta
		i.rotation_degrees += 300 * delta
		
		i.set_meta("vx", vx + cos(rotation + deg_to_rad(90)) * 300 * delta)
		i.set_meta("vy", vy + sin(rotation + deg_to_rad(90)) * 300 * delta)
