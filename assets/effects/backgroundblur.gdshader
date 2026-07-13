shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float fX = 5;
uniform float fY  = 5;
uniform float fA = 0;

const int iterations = 12;

const vec2 offsets[iterations] = {
   vec2(-0.326212, -0.405805),
   vec2(-0.840144, -0.073580),
   vec2(-0.695914,  0.457137),
   vec2(-0.203345,  0.620716),
   vec2(0.962340, -0.194983),
   vec2(0.473434, -0.480026),
   vec2(0.519456,  0.767022),
   vec2(0.185461, -0.893124),
   vec2(0.507431,  0.064425),
   vec2(0.896420,  0.412458),
   vec2(-0.321940, -0.932615),
   vec2(-0.791559, -0.597705)
};

void fragment() {
	vec2 uv = SCREEN_UV;
	
	vec4 back = texture(SCREEN_TEXTURE,uv);
	vec4 fore = texture(SCREEN_TEXTURE,uv);
    for(int i=0;i<12;i++)
        back += texture(SCREEN_TEXTURE,vec2(max(0.0,min(1.0,uv.x+fX*SCREEN_PIXEL_SIZE.x*offsets[i].x)), max(0.0,min(1.0,uv.y+fY*SCREEN_PIXEL_SIZE.y*offsets[i].y))));
    back = vec4(back.r/13.0, back.g/13.0, back.b/13.0, back.a/13.0);
    back += (texture(SCREEN_TEXTURE,uv)-back)*(1.0-fore.a);

	
	back += (texture(SCREEN_TEXTURE,uv)-back)*(1.0-fore.a);
	back.rgb += (fore.rgb-back.rgb)*fore.a*fA;
	back.a += fore.a;
	COLOR = back;
}