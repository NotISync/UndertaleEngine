extends Node2D

@onready var title_text = $naming/title
@onready var name_position_text = $naming/offset
@onready var name_text = $naming/offset/name
@onready var upper_letters = $naming/up_letters
@onready var lower_letters = $naming/low_letters
@onready var buttons = $buttons.get_children()
@onready var display = {
	name = $display/name,
	lv = $display/lv,
	time = $display/time,
	room = $display/room,
	buttons = $naming/buttons.get_children(),
}

var name_input = ""
var index := 0
var mode := -1 if (settings.player_save.data.name == "") else 2
var letters := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var tweens = [null, null]
var white_out = null
var name_allow = true

func _ready():
	vars.scene_cam = $camera
	var old_player_save = ResourceLoader.load("user://saved.tres").duplicate()
	display.name.text = old_player_save.data.name
	display.lv.text = "LV %d" %[old_player_save.data.lv]
	display.room.text = old_player_save.data.place_name
	var minutes = floorf(old_player_save.data.time / 60)
	if(minutes >= 10):
		minutes = str(minutes)
	else:
		minutes = str(minutes)
	var seconds = floorf(fmod(old_player_save.data.time,60))
	if(seconds >= 10):
		seconds = str(seconds)
	else:
		seconds = "0" + str(seconds)
	display.time.text = "%s:%s"%[minutes,seconds]
	audio.play_music("menu/mus_menu"+str(old_player_save.data.pacifist_level+1))
	
func _process(delta):
	text_update()
	inputs()

func name_picked(le_name):
	$background.visible = false
	$display.visible = false
	$buttons.visible = false
	var check_name = functions.easter_egg_name(le_name)
	name_allow = check_name[1]
	name_text.text = le_name
	name_input = le_name
	title_text.text = check_name[0]
	if(!name_allow):
		$naming/buttons/no.text = "Go back"
		$naming/buttons/yes.text = ""
	mode = 1
	index = 0
	for i in range(3, 5):
		display.buttons[i].visible = true
	tweens[0] = create_tween()
	tweens[0].tween_method(func(value): name_position_text.scale = Vector2(value, value), 1.0, 3.0, 5)

func text_update():
	match(mode):
		-2:
			name_text.rotation_degrees = -.25 + randf_range(-.5, .5)
			name_text.position = Vector2(-39+randf_range(-.25, .25), 65+randf_range(-.25, .25))
		-1: 
			$instruction.visible = true
			$naming.visible = false
		0:
			$instruction.visible = false
			$naming.visible = true
			title_text.text = "Name the fallen human."
			for i in tweens:
				if(i):
					i.kill()
			name_position_text.scale = Vector2(1, 1)
			name_text.rotation_degrees = 0
			upper_letters.visible = true
			lower_letters.visible = true
			for i in range(3):
				display.buttons[i].visible = true
			for i in range(3, 5):
				display.buttons[i].visible = false
			var letters_left = letters.substr(0, index)
			var letters_right = letters.substr(index+1, len(letters)-1)
			var low_letters_left = letters.substr(0, index-26).to_lower()
			var low_letters_right = letters.substr(index-26+1, len(letters)-1).to_lower()
			upper_letters.text = "[shake rate=40.0 level=10]" + letters_left + "[color=yellow]" + letters.substr(index, 1) + "[/color]" + letters_right + "[/shake]"
			if(index>25): lower_letters.text = "[shake rate=40.0 level=10]" + low_letters_left + "[color=yellow]" + letters.substr(index-26, 1).to_lower() + "[/color]" + low_letters_right + "[/shake]"
			else: lower_letters.text = "[shake rate=40.0 level=10]" + letters.to_lower() + "[/shake]"
			for i in range(display.buttons.size()):
				if i != index-52:
					display.buttons[i].modulate = Color.WHITE
				else:
					display.buttons[i].modulate = Color.YELLOW
		1:
			$background.visible = false
			$display.visible = false
			$buttons.visible = false
			$instruction.visible = false
			$naming.visible = true
			upper_letters.visible = false
			lower_letters.visible = false
			name_text.rotation_degrees = -.25 + randf_range(-.5, .5)
			name_text.position = Vector2(-39+randf_range(-.25, .25), 65+randf_range(-.25, .25))
			for i in range(3, 5):
				if i != index+3:
					display.buttons[i].modulate = Color.WHITE
				else:
					display.buttons[i].modulate = Color.YELLOW
			for i in range(3):
				display.buttons[i].visible = false
		2:
			$background.visible = true
			$display.visible = true
			$buttons.visible = true
			$instruction.visible = false
			$naming.visible = false
			for i in range(buttons.size()):
				if i != index:
					buttons[i].modulate = Color.WHITE
				else:
					buttons[i].modulate = Color.YELLOW

func inputs():
	if(Input.is_action_just_pressed("quit")):
		get_tree().quit()
	match(mode):
		-1: 
			if(Input.is_action_just_pressed("confirm")):
				mode = 0
		0:
			if(Input.is_action_just_pressed("confirm")):
				if(index>51&&index<55):
					match(index-52):
						0:
							mode = -1
						1:
							name_text.text = name_text.text.substr(0, max(len(name_text.text)-1, 0))
						2:
							if(name_text.text!=""): name_picked(name_text.text)
				else:
					if(len(name_text.text)==6):
						name_text.text = name_text.text.substr(0, max(len(name_text.text)-1, 0))
					if(len(name_text.text)<6):
						name_text.text += ((letters.substr(index-26, 1).to_lower())if(index>25)else(letters.substr(index, 1)))
			elif(Input.is_action_just_pressed("exit")):
				name_text.text = name_text.text.substr(0, max(len(name_text.text)-1, 0))
			elif(Input.is_action_just_pressed("right")):
				index = clampi(index + 1, 0, 54)
			elif(Input.is_action_just_pressed("left")):
				index = max(index - 1, 0)
			elif(Input.is_action_just_pressed("up")):
				if(index>=0&&index<3):
					index = 52
				elif(index>2&&index<5):
					index = 53
				elif(index>4&&index<7):
					index = 54
				elif(index>25&&index<31): 
					index = wrapi(index - 5, 0, 55)
				elif(index>30&&index<33): 
					index = wrapi(index - 12, 0, 55)
				elif(index>51&&index<55):
					index = 51
				else:
					index = wrapi(index - 7, 0, 55)
			elif(Input.is_action_just_pressed("down")):
				if(index>18&&index<21): 
					index = wrapi(index + 12, 0, 55)
				elif(index>20&&index<26): 
					index = wrapi(index + 5, 0, 55)
				elif(index>44&&index<52):
					index = 53
				elif(index>51&&index<55):
					match(index-52):
						0:
							index = 0
						1:
							index = 3
						2:
							index = 5
				else:
					index = wrapi(index + 7, 0, 55)
		1:
			if(name_allow):
				if(Input.is_action_just_pressed("confirm")):
					match(index):
						0:
							if(settings.player_save.data.name != ""):
								$background.visible = true
								$display.visible = true
								$buttons.visible = true
								$instruction.visible = false
								$naming.visible = false
								index = 1
								mode = 2
							else:
								name_text.text = name_input
								index = 54
								mode = 0
						1:
							audio.stop_music()
							audio.play("menu/mus_cymbal")
							$white_screen.visible = true
							var white_out = create_tween()
							white_out.tween_method(func(value): $white_screen.modulate.a = value, 0.0, 1.0, 5)
							mode = -2
							title_text.visible = false
							for i in range(3, 5):
								display.buttons[i].visible = false
							await white_out.finished
							await get_tree().create_timer(.5).timeout
							settings.player_save = PlayerSave.new()
							settings.player_save.data.name = name_input
							settings.player_save.player.name = name_input
							settings.player_save.data.resets += 1
							vars.display.change_room(settings.player_save.data.player_room,-1, false)
				if(Input.is_action_just_pressed("left")):
					index = wrapi(index + 1, 0, 2)
				elif(Input.is_action_just_pressed("right")):
					index = wrapi(index - 1, 0, 2)
			else:
				if(Input.is_action_just_pressed("confirm")):
					$naming/buttons/no.text = "No"
					$naming/buttons/yes.text = "Yes"
					name_text.text = name_input
					index = 54
					mode = 0
		2:
			if(Input.is_action_just_pressed("confirm")):
				audio.play("menu/menu_select")
				match(index):
					0:
						audio.stop_music()
						vars.display.change_room(settings.player_save.data.player_room,-2,false)
					1:
						name_picked(settings.player_save.data.name)
						index = 0
						mode = 1
			if(Input.is_action_just_pressed("right")):
				audio.play("menu/menu_move")
				index = wrapi(index + 1, 0, buttons.size())
			if(Input.is_action_just_pressed("left")):
				audio.play("menu/menu_move")
				index = wrapi(index - 1, 0, buttons.size())
