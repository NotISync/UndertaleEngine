shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform vec3 color = vec3(1.0, 1.0, 1.0);

void fragment() {COLOR = texture(SCREEN_TEXTURE, SCREEN_UV) * texture(TEXTURE, UV) * vec4(color, COLOR.a);}