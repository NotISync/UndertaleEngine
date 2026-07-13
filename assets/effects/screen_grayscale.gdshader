shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

float lerp(float a, float b, float t) {
	return (a + (b - a) * t);
}

void fragment() {
	vec4 sampler = texture(SCREEN_TEXTURE, SCREEN_UV);
	float AvgCol = ((sampler.r + sampler.g + sampler.b)/3.0);
	COLOR *= vec4(lerp(sampler.r, AvgCol, intensity), lerp(sampler.g, AvgCol, intensity), lerp(sampler.b, AvgCol, intensity), 1.0);
}

