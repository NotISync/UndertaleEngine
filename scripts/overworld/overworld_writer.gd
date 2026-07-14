extends NinePatchRect
class_name OverworldDialog

@onready var writer : Writer = $overworld_writer

func _ready():
	writer.unpaused.connect(func():
		visible = true
		if(is_instance_valid(vars.player_character)):
			if(vars.player_character.get_position_on_screen().y >= 240):
				position = Vector2(32,10)
			else:
				position = Vector2(32,318))
	writer.done.connect(func(): visible = false)
