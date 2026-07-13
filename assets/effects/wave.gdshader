shader_type canvas_item;

uniform vec2 freq = vec2(0, 0);
uniform vec2 size = vec2(1, 1);
uniform vec2 speed = vec2(0, 0);
uniform float time = 0.0;
varying vec4 v_vertex_color;

void vertex() {
	v_vertex_color = COLOR;
}
void fragment() {
	vec2 uv = UV;
	uv.x += sin(uv.y*freq.x+(time*speed.x))/size.x;
	uv.y += sin(uv.x*freq.y+(time*speed.y))/size.y;
	vec4 tex = texture(TEXTURE, uv);
	COLOR = v_vertex_color * tex;
}