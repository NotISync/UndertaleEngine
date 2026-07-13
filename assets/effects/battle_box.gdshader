shader_type canvas_item;

uniform vec4 fill = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 border = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 outline = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 inline = vec4(0.0, 0.0, 0.0, 1.0);

void fragment()
	{
		vec4 tex = texture(TEXTURE, UV);
		if(tex.rgb == vec3(1.0, 0.0, 0.0))
		{
			COLOR = fill;
		}
		if(tex.rgb == vec3(0.0, 1.0, 0.0))
		{
			COLOR = border;
		}
		if(tex.rgb == vec3(0.0, 0.0, 1.0))
		{
			COLOR = outline;
		}
		if(tex.rgb == vec3(1.0, 1.0, 0.0))
		{
			COLOR = inline;
		}
		if(tex.a == 0.0)
		{
			COLOR.a = tex.a;
		}
	}