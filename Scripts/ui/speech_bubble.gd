extends Control
class_name SpeechBubble

const _max_characters = 21*4

signal text_ended

var bubble: NinePatchRect
var fader: ShaderMaterial
var camera: Camera2D

var label: Label

var text:String = ""
const timeout = 240
const fade_duration = 45

var pin: Node2D = null
var frames_since_last_write = 0

func _ready():
	bubble = get_node("NinePatchRect")
	label = get_node("NinePatchRect/MarginContainer/Label")
	camera = get_parent().get_parent().get_node("Camera2D")
	fader = bubble.material as ShaderMaterial
	_fade_in()

func pin_to_target(node):
	pin = node
	

func _physics_process(delta):	
	var frames = fader.get_shader_parameter("frames")
	fader.set_shader_parameter("frames",frames+1)
	
	if(pin != null):
		global_position = pin.get_global_transform_with_canvas().origin+Vector2(-80,-225)
	
	frames_since_last_write += 1
	if(text == ""):
		if(frames_since_last_write == timeout):
			label.text = ""
			_fade_out()
		elif(frames_since_last_write > timeout + fade_duration):
			visible = false
			emit_signal("text_ended")
			queue_free()
	else:
		if(frames_since_last_write > fade_duration && frames_since_last_write % 3 == 0):
			_next_character()


func _fade_in():
	fader.set_shader_parameter("fade_in",true)
	fader.set_shader_parameter("frames",0)
	
func _fade_out():
	fader.set_shader_parameter("fade_in",false)
	fader.set_shader_parameter("frames",0)
	
	
func _next_character():
	if(text.length() > 0):
		label.text += text[0]
		text = text.substr(1)
		if(text == ""):
			frames_since_last_write = 0
	if(label.text.length() >= _max_characters):
		label.text = ""
	
func write(text):
	self.text = text
