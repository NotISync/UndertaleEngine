shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float radius = 0;
uniform float exponent = 0;
uniform float coeff = 0;
uniform float fPixelWidth = 1;
uniform float fPixelHeight = 1;

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

vec4 highlight(vec4 i)
{
	return vec4(pow(i.r, exponent)*coeff, pow(i.g, exponent)*coeff, pow(i.b, exponent)*coeff, pow(i.a, exponent)*coeff);
}

void fragment() {
	vec2 uv = SCREEN_UV;
    vec4 s = texture(SCREEN_TEXTURE,uv);
	vec4 o = highlight(s);
    for(int i=0;i<iterations;i++)
        o += highlight(texture(SCREEN_TEXTURE,uv+radius*SCREEN_PIXEL_SIZE*offsets[i]));
    o = vec4(o.r / float(iterations+1), o.g / float(iterations+1), o.b / float(iterations+1), o.a / float(iterations+1));
	COLOR = s+highlight(o);
}