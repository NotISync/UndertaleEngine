shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform int mode : hint_range(0, 4) = 0;
uniform vec2 offset = vec2(0, 0);
uniform vec2 r_displacement = vec2(0, 0);
uniform vec2 g_displacement = vec2(0, 0);
uniform vec2 b_displacement = vec2(0, 0);
uniform float radius = 0.0;
uniform float angle = 0.0;
uniform float speed = 1.0;
uniform float time = 0.0;

void fragment()
{
	vec3 rgb;
	if(mode == 0) {
		vec2 r_displacement_const = vec2(radius * cos(angle+2.0*PI*0.0/3.0), radius * sin(angle+2.0*PI*0.0/3.0));
		vec2 g_displacement_const = vec2(radius * cos(angle+2.0*PI*1.0/3.0), radius * sin(angle+2.0*PI*1.0/3.0));
		vec2 b_displacement_const = vec2(radius * cos(angle+2.0*PI*2.0/3.0), radius * sin(angle+2.0*PI*2.0/3.0));
		rgb = vec3(texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(r_displacement_const)), 0.0).r, texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(g_displacement_const)), 0.0).g, texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(b_displacement_const)), 0.0).b);
	}else if(mode == 1) {
		vec2 r = vec2((r_displacement.x+round(offset.x)), (r_displacement.y+round(offset.y)));
		vec2 g = vec2((g_displacement.x+round(offset.x)), (g_displacement.y+round(offset.y)));
		vec2 b = vec2((b_displacement.x+round(offset.x)), (b_displacement.y+round(offset.y)));

		rgb = vec3(texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE*-r, 0.0).r, texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE*-g, 0.0).g, texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE*-b, 0.0).b);
	}else if(mode == 2) {
		vec2 uv = SCREEN_UV;
		uv = fract(uv + round(-offset) * SCREEN_PIXEL_SIZE);
		vec2 smooth_uv = round(-offset) * SCREEN_PIXEL_SIZE + SCREEN_UV;
		vec4 duv = vec4(dFdx(smooth_uv), dFdy(smooth_uv));
		rgb = textureGrad(SCREEN_TEXTURE, uv, duv.xy, duv.zw).rgb;
	}else if(mode == 3) {
		vec2 r_displacement_const = vec2(radius * cos((time*speed)+2.0*PI*0.0/3.0), radius * sin((time*speed)+2.0*PI*0.0/3.0));
		vec2 g_displacement_const = vec2(radius * cos((time*speed)+2.0*PI*1.0/3.0), radius * sin((time*speed)+2.0*PI*1.0/3.0));
		vec2 b_displacement_const = vec2(radius * cos((time*speed)+2.0*PI*2.0/3.0), radius * sin((time*speed)+2.0*PI*2.0/3.0));
		rgb = vec3(texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(r_displacement_const)), 0.0).r, texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(g_displacement_const)), 0.0).g, texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(b_displacement_const)), 0.0).b);
	}else if(mode == 4) {
		vec2 r_displacement_const = vec2(sin((time*speed)+0.0) * (radius / 2.0), -cos(((time*speed+0.0))/1.15) * (radius / 2.0));
		vec2 g_displacement_const = vec2(sin((time*speed)+45.0) * (radius / 2.0), -cos(((time*speed+45.0))/1.15) * (radius / 2.0));
		vec2 b_displacement_const = vec2(sin((time*speed)+90.0) * (radius / 2.0), -cos(((time*speed+90.0))/1.15) * (radius / 2.0));
		rgb = vec3(texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(r_displacement_const)), 0.0).r, texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(g_displacement_const)), 0.0).g, texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*round(b_displacement_const)), 0.0).b);
	}
	COLOR *= vec4(rgb, 1.0);
}