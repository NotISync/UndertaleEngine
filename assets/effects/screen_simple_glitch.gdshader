shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float time = 0.0;

//2D (returns 0 - 1)
float random2d(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float randomRange (in vec2 seed, in float min, in float max) {
		return min + random2d(seed) * (max - min);
}

// return 1 if v inside 1d range
float insideRange(float v, float bottom, float top) {
   return step(bottom, v) - step(top, v);
}

//inputs
uniform float AMT = 0.2; //0 - 1 glitch amount
uniform float STR = 0.1; //0 - 1 glitch strength
uniform float SPEED = 0.1; //0 - 1 speed
   
void fragment()
{

	float time_floor = floor(time * SPEED * 60.0);    
	vec2 uv = SCREEN_UV;

	//copy orig
	vec3 outCol = texture(SCREEN_TEXTURE, uv).rgb;

	//randomly offset slices horizontally
    for (float i = 0.0; i < 10.0 * AMT; i += 1.0) {
		float sliceY = random2d(vec2(time_floor , 2345.0 + float(i)));
		float sliceH = random2d(vec2(time_floor , 9035.0 + float(i))) * 0.25;
		float hOffset = randomRange(vec2(time_floor , 9625.0 + float(i)), -STR/2.0, STR/2.0);
		vec2 uvOff = uv;
		uvOff.x = fract(uvOff.x + round(hOffset / SCREEN_PIXEL_SIZE.x)*SCREEN_PIXEL_SIZE.x);
		vec2 smooth_uv = round(hOffset / SCREEN_PIXEL_SIZE.x)*SCREEN_PIXEL_SIZE.x + uv;
		vec4 duv = vec4(dFdx(smooth_uv), dFdy(smooth_uv));
		if (insideRange(uv.y, sliceY, fract(sliceY+sliceH)) == 1.0 ){
			outCol = textureGrad(SCREEN_TEXTURE, uvOff, duv.xy, duv.zw).rgb;
		}
	}
	COLOR = vec4(outCol,1.0);
}