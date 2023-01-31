shader_type canvas_item;

uniform float speed = 1;


void fragment() {
	COLOR = texture(TEXTURE,UV+vec2(TIME/1000.0*speed,0));
}
