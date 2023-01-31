shader_type canvas_item;

const float time_scale = 100.0;
uniform float radius = 0.1;

void vertex(){
	VERTEX += time_scale*vec2(cos(TIME*0.5)*radius,sin(TIME)*radius);
}

