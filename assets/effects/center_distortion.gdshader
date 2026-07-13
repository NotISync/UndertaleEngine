shader_type canvas_item;

uniform bool enabel_x = true;
uniform bool enabel_y = false;
uniform vec2 size = vec2(640, 480);
uniform vec2 amp = vec2(1, 0);

vec2 uvp(vec2 uv) {
	return clamp(uv, 0.0, 1.0);
}

float rand(vec2 co) {
	return fract(sin(dot(co.xy,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec3 col;
	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE);
	vec3 texOrig = texture(TEXTURE, uvp(uv)).rgb;
	if(enabel_x){
		uv.x += (rand(vec2(trunc(uv.y*size.x)/size.x, TIME)) - 0.5) * (-amp.x * SCREEN_PIXEL_SIZE.x);
	}
	if(enabel_y){
		uv.y += (rand(vec2(trunc(uv.x*size.y)/size.y, TIME)) - 0.5) * (-amp.y * SCREEN_PIXEL_SIZE.y);
	}
	vec3 tex = texture(TEXTURE, uvp(uv)).rgb;
	tex *= (-amp.x * SCREEN_PIXEL_SIZE.x) + 1.0;
	tex *= (-amp.y * SCREEN_PIXEL_SIZE.y) + 1.0;
	tex = fract(tex);
	col = tex;
	COLOR = vec4(col, 1.0);
}