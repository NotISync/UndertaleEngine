shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 freq = vec2(0, 0);
uniform vec2 size = vec2(1, 1);
uniform vec2 speed = vec2(0, 0);
uniform float time = 0.0;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv.x += sin(uv.y*freq.x+(TIME*speed.x))/size.x;
	uv.y += sin(uv.x*freq.y+(TIME*speed.y))/size.y;
	vec4 tex = texture(SCREEN_TEXTURE, uv);
	COLOR = tex;
}