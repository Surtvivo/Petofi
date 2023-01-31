shader_type canvas_item;
render_mode blend_mix;

uniform bool fade_in = true;
uniform uint frames = 0;
uniform uint max_frames = 45;


void fragment(){
	float scale = float(frames)/float(max_frames);
	float antiscale = 1.0-scale;
	if(fade_in && frames < max_frames){
		COLOR = texture(TEXTURE,0.5+(UV-0.5)/scale);
	}
	else if(frames < max_frames){
		COLOR = texture(TEXTURE,0.5+(UV-0.5)/antiscale);
	}
	else{
		COLOR = texture(TEXTURE,UV);
	}
}