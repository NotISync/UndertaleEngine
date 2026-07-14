extends Node2D
class_name Enemy

enum e_dodge {
	none,
	dodge,
	grav,
}

@onready var sprite = null
@onready var damage_anchor : Node = self
@onready var speech_bubble = $speech_bubble/buffer/speech_container
@onready var speech_writer = $speech_bubble/buffer/speech_container/speech_writer
@onready var hitbox = $area

var enemy_name : String
var current_hp : int
var max_hp : int
var atk : float
var def : float
var dodge : e_dodge
var border_stick := true
var offset := 0.0 #Offset for border stick
var damage_siner := 0.0
var xp_reward := 0
var gold_reward := 0
var can_spare := false

var show_health_bar : bool = true

signal done_being_attacked

var act_options = {
	"Check" : check,
	}

func _init(enemy_name : String, hp : int, def : float):
	self.enemy_name = enemy_name
	self.current_hp = hp
	self.max_hp = hp
	self.def = def

func _process(delta):
	for i in hitbox.get_overlapping_areas():
		if(i.owner is BPlayerBullet):
			pass
			#audio.play("battle/bell")
			#i.owner.deflect()

func attack(damage : float):
	if(damage >= 0):
		match(dodge):
			e_dodge.none:
				attack_normal(damage)
			e_dodge.dodge:
				attack_dodge(damage)
	else:
		attack_no_damage(damage)

func attack_normal(damage : float, turn := true):
	if is_instance_valid(vars.hud_manager.eye) && is_instance_valid(vars.hud_manager.eye.weapon): await vars.hud_manager.eye.weapon.hit_finish
	await get_tree().create_timer(0.0333333).timeout
	audio.play("battle/hit")
	var buffer : BackBufferCopy = BackBufferCopy.new()
	var bar_smooth : NinePatchRect = NinePatchRect.new()
	var bar_max : ColorRect = ColorRect.new()
	var bar : ColorRect = ColorRect.new()
	var texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	bar_smooth.texture = load("res://assets/sprites/battle/hud/healthbar_outline.png")
	bar_smooth.self_modulate = Color(0, 0, 0)
	bar_smooth.patch_margin_left = 8
	bar_smooth.patch_margin_top = 8
	bar_smooth.patch_margin_right = 8
	bar_smooth.patch_margin_bottom = 8
	#bar_smooth.material = ShaderMaterial.new()
	#bar_smooth.material.shader = load("res://assets/effects/mask.gdshader")
	bar_max.color = Color(.5,.5,.5,1)
	bar_max.size = Vector2(texture.get_size().x * sprite.scale.x, 15)
	bar.color = Color(.1,1,.1,1)
	bar.size = Vector2((float(current_hp) / max_hp) * texture.get_size().x * sprite.scale.x, 15)
	bar_smooth.size = bar_max.size + Vector2(4, 4)
	#buffer.z_index = 1
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_smooth.global_position = bar_max.global_position - Vector2(2, 2)
	bar_max.add_child(bar)
	buffer.add_child(bar_max)
	buffer.add_child(bar_smooth)
	vars.scene.add_child(buffer)
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_smooth.global_position = bar_max.global_position - Vector2(2, 2)
	current_hp = clampf(current_hp - damage,0,max_hp)
	create_tween().tween_property(bar, "size", Vector2((float(current_hp) / max_hp) * texture.get_size().x * sprite.scale.x, 15), .25)
	buffer.visible = show_health_bar
	var damage_text : RichTextLabel = create_text("[center]"+ str(int(damage)))
	damage_text.self_modulate = Color(1, 0, 0, 1)
	damage_text.global_position = bar_max.global_position - Vector2(0,45)
	var damage_move = func():
		var drop_value = damage_anchor.global_position.y - 50.5
		var sprite_vel = -2
		while(damage_text.position.y < drop_value):
			if(is_instance_valid(damage_text)):
				sprite_vel += get_process_delta_time() * 6.0
				damage_text.position.y += sprite_vel * get_process_delta_time() * 60
			else: return
			await get_tree().process_frame
	damage_move.call()
	shake(15)
	await get_tree().create_timer(1.3).timeout
	buffer.queue_free()
	bar_smooth.queue_free()
	bar_max.queue_free()
	bar.queue_free()
	damage_text.queue_free()
	if(turn): post_attack(damage)

func attack_dodge(damage : float, turn := true):
	var buffer : BackBufferCopy = BackBufferCopy.new()
	var bar_smooth : NinePatchRect = NinePatchRect.new()
	var bar_max : ColorRect = ColorRect.new()
	var bar : ColorRect = ColorRect.new()
	var texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	bar_smooth.texture = load("res://assets/sprites/battle/hud/healthbar_outline.png")
	bar_smooth.self_modulate = Color(0, 0, 0)
	bar_smooth.patch_margin_left = 8
	bar_smooth.patch_margin_top = 8
	bar_smooth.patch_margin_right = 8
	bar_smooth.patch_margin_bottom = 8
	#bar_smooth.material = ShaderMaterial.new()
	#bar_smooth.material.shader = load("res://assets/effects/mask.gdshader")
	bar_max.color = Color(.5,.5,.5,1)
	bar_max.size = Vector2(texture.get_size().x * sprite.scale.x, 15)
	bar.color = Color(.1,1,.1,1)
	bar.size = Vector2((float(current_hp) / max_hp) * texture.get_size().x * sprite.scale.x, 15)
	bar_smooth.size = bar_max.size + Vector2(4, 4)
	#buffer.z_index = 1
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_smooth.global_position = bar_max.global_position - Vector2(2, 2)
	bar_max.add_child(bar)
	buffer.add_child(bar_max)
	buffer.add_child(bar_smooth)
	vars.scene.add_child(buffer)
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_smooth.global_position = bar_max.global_position - Vector2(2, 2)
	var damage_text : RichTextLabel = create_text("[center]MISS")
	damage_text.self_modulate = Color(.7, .7, .7, 1)
	damage_text.global_position = bar_max.global_position - Vector2(0,45)
	buffer.visible = false
	damage_text.visible = false
	var tween = create_tween()
	tween.tween_property(self,"global_position",global_position - Vector2(100,0), .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if is_instance_valid(vars.hud_manager.eye) && is_instance_valid(vars.hud_manager.eye.weapon): await vars.hud_manager.eye.weapon.hit_finish
	damage_text.visible = true
	var damage_move = func():
		var drop_value = damage_anchor.global_position.y - 50.5
		var sprite_vel = -2
		while(damage_text.position.y < drop_value):
			if(is_instance_valid(damage_text)):
				sprite_vel += get_process_delta_time() * 6.0
				damage_text.position.y += sprite_vel * get_process_delta_time() * 60
			else: return
			await get_tree().process_frame
	damage_move.call()
	await get_tree().create_timer(.9).timeout
	tween = create_tween()
	tween.tween_property(self,"global_position",global_position + Vector2(100,0), .4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	buffer.queue_free()
	bar_smooth.queue_free()
	bar_max.queue_free()
	bar.queue_free()
	damage_text.queue_free()
	if(turn): post_attack(damage)

func attack_no_damage(damage : float, turn := true):
	var buffer : BackBufferCopy = BackBufferCopy.new()
	var bar_smooth : NinePatchRect = NinePatchRect.new()
	var bar_max : ColorRect = ColorRect.new()
	var bar : ColorRect = ColorRect.new()
	var texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	bar_smooth.texture = load("res://assets/sprites/battle/hud/healthbar_outline.png")
	bar_smooth.self_modulate = Color(0, 0, 0)
	bar_smooth.patch_margin_left = 8
	bar_smooth.patch_margin_top = 8
	bar_smooth.patch_margin_right = 8
	bar_smooth.patch_margin_bottom = 8
	#bar_smooth.material = ShaderMaterial.new()
	#bar_smooth.material.shader = load("res://assets/effects/mask.gdshader")
	bar_max.color = Color(.5,.5,.5,1)
	bar_max.size = Vector2(texture.get_size().x * sprite.scale.x, 15)
	bar.color = Color(.1,1,.1,1)
	bar.size = Vector2((float(current_hp) / max_hp) * texture.get_size().x * sprite.scale.x, 15)
	bar_smooth.size = bar_max.size + Vector2(4, 4)
	#buffer.z_index = 1
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_smooth.global_position = bar_max.global_position - Vector2(2, 2)
	bar_max.add_child(bar)
	buffer.add_child(bar_max)
	buffer.add_child(bar_smooth)
	vars.scene.add_child(buffer)
	bar_max.global_position = damage_anchor.global_position - bar_max.size / 2
	bar_smooth.global_position = bar_max.global_position - Vector2(2, 2)
	buffer.visible = false
	var damage_text : RichTextLabel = create_text("[center]MISS")
	damage_text.self_modulate = Color(.7, .7, .7, 1)
	damage_text.global_position = bar_max.global_position - Vector2(0,60)
	await get_tree().create_timer(.75).timeout
	buffer.queue_free()
	bar_smooth.queue_free()
	bar_max.queue_free()
	bar.queue_free()
	damage_text.queue_free()
	if(turn): post_attack(-1)

func shake(shake_intensity : float = 15):
	var previous_position = position
	for i in range(shake_intensity):
		position.x = previous_position.x + shake_intensity
		shake_intensity = shake_intensity * -0.8
		await get_tree().create_timer(.05).timeout
	position = previous_position

func post_attack(damage : float):
	done_being_attacked.emit()
	if(current_hp <= 0):
		death()
		visible = false
		if(vars.enemies.get_child_count()>1):
			vars.attack_manager.pre_attack()
			vars.dialouge_manager.start()
			await vars.dialouge_manager.done
			if vars.battle_box.margin != vars.battle_box.target:
				await vars.battle_box.resize_finished
			vars.attack_manager.current_attack.start_attack()
			vars.attack_manager.turn_num += 1
			for i in vars.enemies.get_children():
				if i != self:
					i.xp_reward += xp_reward
					i.gold_reward += gold_reward
					break
			queue_free()
		else:
			won()
	else:
		if(damage != -1):
			vars.attack_manager.pre_attack()
			vars.dialouge_manager.start()
			await vars.dialouge_manager.done
			if vars.battle_box.margin != vars.battle_box.target:
				await vars.battle_box.resize_finished
			vars.attack_manager.current_attack.start_attack()
			vars.attack_manager.turn_num += 1
		else:
			vars.attack_manager.pre_heal_attack()
			if vars.battle_box.margin != vars.battle_box.target:
				await vars.battle_box.resize_finished
			vars.attack_manager.current_attack.start_attack()

func death():
	var dust_enemy = load("res://objects/battle/dusted_enemy.tscn").instantiate()
	dust_enemy.set_texture(sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame()))
	vars.scene.add_child(dust_enemy)
	dust_enemy.global_position = sprite.global_position
	dust_enemy.Start()

func create_text(text : String):
	var textblock = RichTextLabel.new()
	textblock.bbcode_enabled = true
	var texture = sprite.get_sprite_frames().get_frame_texture(sprite.animation,sprite.get_frame())
	textblock.size = Vector2(texture.get_size().x * sprite.scale.x, 15)
	textblock.add_theme_font_override("normal_font", load("res://assets/fonts/damage.ttf"))
	textblock.add_theme_font_size_override("normal_font_size", 28)
	textblock.set("theme_override_colors/font_outline_color", Color(0,0,0,1))
	textblock.set("theme_override_constants/outline_size", 9)
	textblock.z_index = 1
	textblock.clip_contents = false
	textblock.scroll_active = false
	textblock.autowrap_mode = TextServer.AUTOWRAP_OFF
	vars.scene.add_child(textblock)
	textblock.text = text
	return textblock

func check():
	vars.hud_manager.mode = -1
	vars.player_heart.visible = false
	vars.main_writer.writer_text = "(enable:z)(sound:mono2)* Enemy 1 ATK 1 DEF\n* Example Text.(pc)"
	await vars.main_writer.done
	vars.hud_manager.reset()

func spare():
	audio.stop_music()
	audio.play("battle/snd_vaporized")
	modulate = Color(0.5, 0.5, 0.5)
	won(false)

func won(killed := true):
	audio.stop_music()
	vars.hud_manager.mode = -1
	vars.player_heart.visible = false
	settings.player_save.player.gold += gold_reward
	settings.player_save.player.exp += xp_reward
	if(killed): settings.player_save.player.kills += 1
	else: xp_reward = 0
	if(functions.exp_for_lv(settings.player_save.player.lv)>settings.player_save.player.exp):
		vars.main_writer.writer_text = "(enable:z)(disable:x)(sound:mono2)* YOU WON!\n* You earned " + str(xp_reward) + " XP and " + str(gold_reward) + " gold.(pc)"
	else:
		if(!vars.hud_manager.serious_mode): audio.play("menu/snd_levelup")
		vars.main_writer.writer_text = "(enable:z)(disable:x)(sound:mono2)* YOU WON!\n* You earned " + str(xp_reward) + " XP and " + str(gold_reward) + " gold.\n* Your LOVE increased.(pc)"
		while(settings.player_save.player.exp>=functions.exp_for_lv(settings.player_save.player.lv)):
			settings.player_save.player.lv += 1
			if(functions.exp_for_lv(settings.player_save.player.lv)>settings.player_save.player.exp):
				settings.player_save.player.max_hp = 16 + (4 * settings.player_save.player.lv)
				settings.player_save.player.atk = -2 + (2 * settings.player_save.player.lv)
				settings.player_save.player.def = int((settings.player_save.player.lv - 1) / 4)if(settings.player_save.player.lv>1)else(0)
				break
	await vars.main_writer.done
	end_fight()

func end_fight():
	(vars as vars).display.change_room(settings.player_save.data.player_room, -3)
