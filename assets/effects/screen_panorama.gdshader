shader_type canvas_item;

uniform int zoom = 75;
uniform bool smoothed = true;
uniform bool vertical = false;
uniform bool noWrap = true;

//Diable this line for Godot 3.x//
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	lowp float fB;
	lowp float fC;

	//Change this if you want to make the stairstepping more/less intense//
	const float steps = 230.0;

	vec2 posTex;
	vec2 uv = SCREEN_UV;

  if(vertical == false){

    fB = 1.0 - (float(zoom) * .0015);
    fC = max(.02, 1.0 + (fB - 1.0) * 4.0 * pow((uv.x - 0.5), 2.0));
	if (!smoothed){
		fC = float(int(fC * steps)) / steps;
	}

    posTex = (uv * vec2(1.0, fC) + vec2(0.0, (1.0 - fC) / 2.0));

    if(noWrap == false || (posTex.y >= 0.0 && posTex.y <= 1.0)){
      COLOR.rgb = texture(SCREEN_TEXTURE, posTex).rgb;
    }

  } else {
    fB = 1.0 - (float(zoom) * .0015);
    fC = max(0.05, 1.0 + (fB - 1.0) * 4.0 * pow((uv.y - 0.5), 2.0));
	if (!smoothed){
		fC = float(int(fC * steps)) / steps;
	}

    posTex = uv * vec2(fC, 1.0) + vec2((1.0 - fC) / 2.0, 0.0);

    if(noWrap == false || (posTex.x >= 0.0 && posTex.x <= 1.0)){
      COLOR.rgb = textureLod(SCREEN_TEXTURE, posTex, 0.0).rgb;
    }
  }
}