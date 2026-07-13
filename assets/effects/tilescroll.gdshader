shader_type canvas_item;

uniform float zoom = 1.0;
uniform vec2 offset = vec2(0.0);

void vertex(){
	UV = (((VERTEX * (1.0/(zoom)))-offset) * TEXTURE_PIXEL_SIZE)+vec2(0.5, 0.5);
}