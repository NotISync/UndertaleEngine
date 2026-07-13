shader_type canvas_item;

uniform vec2 topleft;
uniform vec2 topright;
uniform vec2 bottomleft;
uniform vec2 bottomright;

group_uniforms Settings;
uniform bool snes_transparency = false;
uniform bool gba_transparency = false;
uniform bool horizontal_scan_line = false;
uniform bool vertical_scan_line = false;
uniform bool enable_palette_cycling = false;


group_uniforms Sprite_Scroll;
uniform vec2 sprite_scroll_direction = vec2(0.0, 0.0);
uniform float sprite_scroll_speed = 0.01;


group_uniforms GBA_Transparency;
uniform vec2 gba_transparency_scroll_direction = vec2(0.0, 0.0);
uniform float gba_transparency_scroll_speed = 0.01;
uniform float gba_transparency_value : hint_range(0.0, 1.0) = 0.5;


group_uniforms Horizontal_Wave;
uniform float horizontal_wave_amplitude = 0.0;
uniform float horizontal_wave_frequency = 0.0;
uniform float horizontal_wave_speed = 1.0;

group_uniforms Vertical_Wave;
uniform float vertical_wave_amplitude = 0.0;
uniform float vertical_wave_frequency = 0.0;
uniform float vertical_wave_speed = 1.0;


group_uniforms Horizontal_Deform;
uniform float horizontal_deform_amplitude = 0.0;
uniform float horizontal_deform_frequency = 0.0;
uniform float horizontal_deform_speed = 1.0;


group_uniforms Vertical_Deform;
uniform float vertical_deform_amplitude = 0.0;
uniform float vertical_deform_frequency = 0.0;
uniform float vertical_deform_speed = 1.0;


group_uniforms Size;
uniform float width = 0.0;
uniform float height = 0.0;


group_uniforms Palette_Cycling;
uniform float palette_cycling_speed = 0.1;
uniform sampler2D palette;



float calculate_diff(float uv, float amp, float freq, float spd){
	float diff_x = amp * sin((freq * uv) + (TIME * spd));
	return diff_x;
}

vec2 calculate_move(vec2 dir, float spd){
	vec2 move = dir * TIME*sprite_scroll_speed;
	return move;
}


float mycross( in vec2 a, in vec2 b ) { return a.x*b.y - a.y*b.x; }

vec2 invBilinear( in vec2 p, in vec2 a, in vec2 b, in vec2 c, in vec2 d )
{
   vec2 res = vec2(-1.0);

    vec2 e = b-a;
    vec2 f = d-a;
    vec2 g = a-b+c-d;
    vec2 h = p-a;
        
    float k2 = mycross( g, f );
    float k1 = mycross( e, f ) + mycross( h, g );
    float k0 = mycross( h, e );
    
    // if edges are parallel, this is a linear equation. Do not this test here though, do
    // it in the user code
    if( abs(k2)<0.001 )
    {
        float v = -k0/k1;
        float u  = (h.x*k1+f.x*k0) / (e.x*k1-g.x*k0);
        if( v>0.0 && v<1.0 && u>0.0 && u<1.0 )  res = vec2( u, v );
    }
	else
    {
        // otherwise, it's a quadratic
        float w = k1*k1 - 4.0*k0*k2;
        if( w<0.0 ) return vec2(-1.0);
        w = sqrt( w );

        float ik2 = 0.5/k2;
        float v = (-k1 - w)*ik2; if( v<0.0 || v>1.0 ) v = (-k1 + w)*ik2;
        float u = (h.x - f.x*v)/(e.x + g.x*v);
        if( u<0.0 || u>1.0 || v<0.0 || v>1.0 ) return vec2(-1.0);
        res = vec2( u, v );
    }
    
    return res;
}



void fragment(){
	vec2 topleftUV = topleft /vec2(textureSize(TEXTURE,0));
	vec2 toprightUV = vec2(1.0,0.0)+topright /vec2(textureSize(TEXTURE,0));
	vec2 bottomrightUV = vec2(1.0,1.0)+bottomright /vec2(textureSize(TEXTURE,0));
	vec2 bottomleftUV =vec2(0.0,1.0)+ bottomleft /vec2(textureSize(TEXTURE,0));
	vec2 newUV = invBilinear(UV,topleftUV,toprightUV,bottomrightUV,bottomleftUV);
	
	/*if (topleft.x==0.0&& topright.x== 0.0) {
		COLOR = texture(TEXTURE,UV);
	}else{
	if (newUV == vec2(-1.0,-1.0)){
		COLOR = vec4(0.0,0.0,0.0,0.0);
	}else{
		COLOR = texture(TEXTURE,newUV);
	}
	}*/
	
	float def_x = calculate_diff(newUV.x, horizontal_deform_amplitude, horizontal_deform_frequency, horizontal_deform_speed);
	float def_y = calculate_diff(newUV.y, vertical_deform_amplitude, vertical_deform_frequency, vertical_deform_speed);
	float wav_x = calculate_diff(newUV.y, horizontal_wave_amplitude, horizontal_wave_frequency, horizontal_wave_speed);
	float wav_y = calculate_diff(newUV.x, vertical_wave_amplitude, vertical_wave_frequency, vertical_wave_speed);
	
	vec2 move = calculate_move(sprite_scroll_direction, sprite_scroll_speed);
	
	
	if ( int( newUV.y * height ) % 2 == 0 && snes_transparency)
	{
		
		wav_x = -wav_x;
		
	}
	
	
	vec4 textube = texture(TEXTURE, vec2(newUV.x+def_x + wav_x, newUV.y+def_y + wav_y) + move);
	
	
	if (gba_transparency)
	{
		
		float copy_wav_x = -calculate_diff(newUV.y, horizontal_wave_amplitude, horizontal_wave_frequency, horizontal_wave_speed);
		vec4 tex_copy;
		
		
		if ( int( newUV.y * height ) % 2 == 1 && snes_transparency)
		{
			
			copy_wav_x = -copy_wav_x;
			
		}
		
		if (gba_transparency_scroll_direction != vec2(0.0))
		{
			
			vec2 copy_move = calculate_move(gba_transparency_scroll_direction, gba_transparency_scroll_speed);
			tex_copy = texture(TEXTURE, vec2(newUV.x+def_x + copy_wav_x, newUV.y+def_y + wav_y) + copy_move);
			
		}
		else tex_copy = texture(TEXTURE, vec2(newUV.x+def_x + copy_wav_x, newUV.y+def_y + wav_y) + move);
		
		
		textube = mix(textube, tex_copy, gba_transparency_value);
		
	}
	
	
	float palette_swap = mod(textube.r - TIME*palette_cycling_speed, 1.0);
	
	
	if (enable_palette_cycling)
	{
		
		textube = vec4(texture(palette, vec2(palette_swap, 0)).rgb, textube.a);
		
	}
	
	COLOR = textube;
	
	if (horizontal_scan_line) COLOR = mix(vec4(0.0, 0.0, 0.0, 1.0), COLOR, float(int(newUV.y * height) % 2));
	if (vertical_scan_line) COLOR = mix(vec4(0.0, 0.0, 0.0, 1.0), COLOR, float(int(newUV.x * width) % 2));
	

		
}
//void vertex(){
//if( UV.x <= 0.0 && UV.y <= 0.0) {
//VERTEX+=topleft
//}
//if( UV.x >= 1.0 && UV.y <= 0.0) {
//VERTEX+=topright
//}
//if( UV.x <= 0.0 && UV.y >= 1.0) {
//VERTEX+=bottomleft
//}
//if( UV.x >= 1.0 && UV.y >= 1.0) {
//VERTEX+=bottomright
//}
//
//}