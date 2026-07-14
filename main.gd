extends Node

var window := NinePatchRect.new()
var window_container := SubViewportContainer.new()
var viewport := SubViewport.new()

@onready var display = preload("res://scenes/mobile_display_manager.tscn") if(OS.get_model_name()!="GenericDevice") else preload("res://scenes/display_manager.tscn")

func _ready():
	add_child(display.instantiate())
	
