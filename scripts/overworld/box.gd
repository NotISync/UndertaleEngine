extends Node2D

signal event_called

@onready var sprite := $sprite
@onready var player_save : PlayerSave = settings.player_save
@onready var area : Interactable = $area
@onready var selection_border := $CanvasLayer/selection_border
@onready var text_container := $CanvasLayer/selection_border/text_container
@onready var items_list := $CanvasLayer/selection_border/text_container/items_list
@onready var heart = $CanvasLayer/heart

var item_texts = []
var mode := -1
var selection_index := 0

func _ready():
	area.event_called.connect(event)

func _process(delta):
	hud_update()

func _physics_process(delta):
	inputs()

func setup_hud():
	var create_text : Callable = func(position : Vector2):
		var textblock = RichTextLabel.new()
		textblock.bbcode_enabled = true
		textblock.add_theme_font_override("normal_font", load("res://assets/fonts/main_mono.ttf"))
		textblock.add_theme_font_size_override("normal_font_size", 32)
		textblock.set("theme_override_colors/font_outline_color", Color(0, 0, 0))
		textblock.position = position
		textblock.size = Vector2(100,100)
		textblock.z_index = 1
		textblock.clip_contents = false
		textblock.scroll_active = false
		textblock.autowrap_mode = TextServer.AUTOWRAP_OFF
		items_list.add_child(textblock)
		return textblock
	
	for i in range(8): #Inventory
		var location : Vector2 = Vector2(10, -10 + i * 31)
		var text : RichTextLabel = create_text.call(location)
		item_texts.append(text)
	for i in range(10): #Box
		var location : Vector2 = Vector2(300, -10 + i * 31)
		var text : RichTextLabel = create_text.call(location)
		item_texts.append(text)
	for i in range(18):
		item_texts[i].text = " [img width=180 height=22]res://assets/sprites/overworld/objects/box_blank_text.png[/img]"

func inputs():
	match(mode):
		0:
			if(Input.is_action_just_pressed("confirm")):
				match(selection_index):
					0:
						open()
					1:
						close()
			elif(Input.is_action_just_pressed("left")):
				selection_index = wrapi(selection_index - 1,0,2)
			elif(Input.is_action_just_pressed("right")):
				selection_index = wrapi(selection_index + 1,0,2)
		1:
			if(Input.is_action_just_pressed("confirm")):
				item_put(selection_index)
			elif(Input.is_action_just_pressed("exit")):
				close()
			elif(Input.is_action_just_pressed("left")):
				if(selection_index > 7 && selection_index < 16):
					selection_index -= 8
			elif(Input.is_action_just_pressed("right")):
				if(selection_index < 8):
					selection_index += 8
			elif(Input.is_action_just_pressed("up")):
				if(selection_index<8):
					selection_index = max(selection_index - 1, 0)
				else:
					selection_index = max(selection_index - 1, 8)
			elif(Input.is_action_just_pressed("down")):
				if(selection_index<8):
					selection_index = min(selection_index + 1, 7)
				else:
					selection_index = min(selection_index + 1, 17)
		

func hud_update():
	match(mode):
		-1:
			heart.visible = false
			selection_border.visible = false
		0:
			$CanvasLayer.layer
			heart.visible = true
			heart.global_position = vars.main_writer.global_position + Vector2(116 + 192 * selection_index, 78)
		1:
			heart.global_position = item_texts[selection_index].global_position + Vector2(-31, 8)
			selection_border.visible = true
			vars.player_character.input_enabled = false
			for i in player_save.get_inventory_size():
				if(player_save.inventory[i] != ""): item_texts[i].text = player_save.get_item(i).names[0]
			for i in player_save.get_box_size():
				if(player_save.box_inventory[i] != ""): item_texts[i+8].text = player_save.get_item_box(i).names[0]
			for i in range(8):
				if(player_save.inventory[i] == ""):
					item_texts[i].text = " [img width=180 height=22]res://assets/sprites/overworld/objects/box_blank_text.png[/img]"
			for i in range(10):
				if(player_save.box_inventory[i] == ""):
					item_texts[i+8].text = " [img width=180 height=22]res://assets/sprites/overworld/objects/box_blank_text.png[/img]"
			

func event():
	vars.main_writer.writer_text = "(sound:mono1)* Use the box?\n\n         Yes         No(pc)"
	await vars.main_writer.type_done
	mode = 0
	event_called.emit()

func open():
	setup_hud()
	mode = 1
	selection_index = 0

func item_put(index):
	if(index>7):
		if(player_save.get_inventory_size()<8):
			var temp = player_save.box_inventory[index-8]
			player_save.box_inventory[index-8] = ""
			player_save.inventory[player_save.get_inventory_size()] = temp
			item_texts[index].text = " [img width=180 height=22]res://assets/sprites/overworld/objects/box_blank_text.png[/img]"
	else:
		if(player_save.get_box_size()<10):
			var temp = player_save.inventory[index]
			player_save.inventory[index] = ""
			player_save.box_inventory[player_save.get_box_size()] = temp
			item_texts[index].text = " [img width=180 height=22]res://assets/sprites/overworld/objects/box_blank_text.png[/img]"
	ut_items.sort_inventory()
	ut_items.sort_box_inventory()

func close():
	mode = -1
	selection_index = 0
	item_texts.clear()
	for i in items_list.get_children():
		i.queue_free()
	await get_tree().physics_frame
	vars.player_character.input_enabled = true
