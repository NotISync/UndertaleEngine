extends Node2D
class_name BattleRoom

var mercy := 0
var flee := true
var revive := false

func _ready():
	vars.scene = self
	vars.attack_manager = $attack_manager
	vars.dialouge_manager = $dialouge_manager
	vars.enemies = $enemies
	vars.battle_box = $battle_box
	vars.hud_manager = $hud_manager
	vars.main_writer = $battle_box/battle_writer
	vars.player_heart = $player_heart
	vars.scene_cam = $camera
	vars.black_screen = $hud/black_screen
	vars.hud_manager.setup_hud()

func escape():
	vars.hud_manager.mode = -1
	vars.player_heart.sprite.visible = false
	vars.player_heart.sprite_flee.visible = true
	audio.play("menu/snd_escaped")
	var rng = randi_range(0, 20)
	if(rng == 0 || rng == 1):
		vars.main_writer.writer_text = "(disable:x)(disable:z)(sound:mono2)* I'm outta here.(pc)"
	elif(rng == 2):
		vars.main_writer.writer_text = "(disable:x)(disable:z)(sound:mono2)* Don't slow me down.(pc)"
	elif(rng == 3):
		vars.main_writer.writer_text = "(disable:x)(disable:z)(sound:mono2)* I've got better to do.(pc)"
	elif(rng > 3):
		vars.main_writer.writer_text = "(disable:x)(disable:z)(sound:mono2)* Escaped...(pc)"
	var tween = create_tween()
	tween.tween_property(vars.player_heart, "position:x", -20, 1)
	await tween.finished
	audio.stop_music()
	(vars as vars).display.change_room(settings.player_save.data.player_room, -1)
