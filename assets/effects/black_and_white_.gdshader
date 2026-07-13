shader_type canvas_item;

uniform bool invert = false;

void fragment()
{
    COLOR = texture(TEXTURE, UV);
    float avg = (COLOR.r + COLOR.g + COLOR.b);
	if (invert) {
        avg = 1.0 - avg;
    }
    COLOR.rgb = vec3(avg);
}