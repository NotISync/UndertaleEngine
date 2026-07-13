shader_type canvas_item;

uniform bool x_slice = false;
uniform vec2 freq = vec2(0, 0);
uniform vec2 size = vec2(1, 1);
uniform vec2 speed = vec2(0, 0);
uniform vec2 splitcount = vec2(1, 1);
uniform vec2 splitsize = vec2(1, 1);
uniform float time = 0.0;

void fragment() {
	vec2 uv = UV;
	if(x_slice) {
		uv.x += mod(trunc(uv.x * splitcount.x), splitsize.x);
		uv.y += sin(uv.x*freq.y+(time*speed.y))/size.y;
	}else{
		uv.y += mod(trunc(uv.y * splitcount.y), splitsize.y);
		uv.x += sin(uv.y*freq.x+(time*speed.x))/size.x;
	}
	vec4 tex = texture(TEXTURE, uv);
	COLOR.rgb = tex.rgb;
}