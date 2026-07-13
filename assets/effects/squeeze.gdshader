shader_type canvas_item;

uniform float fCoeff = 1;
uniform float fAngle = 0;

void fragment() {
	vec2 uv = UV;
	float Dist = distance(uv.xy, vec2(0.5,0.5)) * 2.0;
	if (Dist < 1.0){
		float Angle = atan(uv.y - 0.5, uv.x - 0.5) + pow(1.0 - Dist,2) * fAngle;
		Dist = (pow(Dist,fCoeff)) / 2.0;
		uv.x = cos(Angle) * Dist + 0.5;
		uv.y = sin(Angle) * Dist + 0.5;
	}
 	COLOR = texture(TEXTURE, uv);
}