extends Node2D
class_name Shaders

var effects = {
	"bloom" : "res://assets/effects/bloom.gdshader",
	"blur" : "res://assets/effects/blur.gdshader",
	"chromatic" : "res://assets/effects/chromatic.gdshader",
	"wave" : "res://assets/effects/wave.gdshader",
	"distortion" : "res://assets/effects/distortion.gdshader",
	"center_distortion" : "res://assets/effects/center_distortion.gdshader",
	"grayscale" : "res://assets/effects/grayscale.gdshader",
	"vhs" : "res://assets/effects/retro.gdshader",
	"squeeze" : "res://assets/effects/squeeze.gdshader",
	"wirp" : "res://assets/effects/wirp.gdshader",
	"bgblur" : "res://assets/effects/backgroundblur.gdshader",
	"glitch" : "res://assets/effects/glitch.gdshader",
	"simple_glitch" : "res://assets/effects/simple_glitch.gdshader",
	"rain" : "res://assets/effects/rain_effect.gdshader",
	}
	
var active_shaders = {}

func add_shader(effect_name : String, parameters : Array = []):
	var buffer = BackBufferCopy.new()
	var shader = Sprite2D.new()
	shader.texture = CanvasTexture.new()
	buffer.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	shader.scale = Vector2(960,540)
	shader.material = ShaderMaterial.new()
	shader.material.shader = load(effects[effect_name])
	for i in parameters:
		shader.material.set_shader_parameter(i[0], i[1])
	active_shaders[effect_name] = shader
	add_child(buffer)
	buffer.add_child(shader)
	return shader
