extends Node2D
class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _camera: Camera2D = null
var _cameraTarget:Vector2 = Vector2(0,0)
var _cameraLimitY:float = 30
var _cameraLimitX:float = 7742

var _active = true

enum BodyPart{TORSO = 0,HEAD = 1,UPPER_LEFT_ARM = 2,UPPER_RIGHT_ARM = 3,LOWER_LEFT_ARM = 4,LOWER_RIGHT_ARM = 5,UPPER_LEFT_LEG = 6,UPPER_RIGHT_LEG = 7,LOWER_LEFT_LEG = 8,LOWER_RIGHT_LEG = 9}

var _director: Director

var _selectedPart: RigidBody2D = null
var _body_parts: Array = []
var _can_be_dragged = true
var _show_next_poem = false


var _floorCast: RayCast2D = null
var _lastImpulse = Time.get_ticks_msec()
var _idling: bool = true

func _ready():
	_floorCast = get_node("RayCast2D")
	
	_director = get_parent() as Director
	#_director.player = self !!! director sets the player on reset, unneeded
	_camera = _director.get_node("Camera2D")
	_cameraTarget = _camera.global_position

	_body_parts.resize(10)
	_body_parts[BodyPart.TORSO] = get_node("Torso")
	_body_parts[BodyPart.HEAD] = get_node("Head")
	_body_parts[BodyPart.UPPER_LEFT_ARM] = get_node("LeftUpperArm")
	_body_parts[BodyPart.UPPER_RIGHT_ARM] = get_node("RightUpperArm")
	_body_parts[BodyPart.LOWER_LEFT_ARM] = get_node("LeftLowerArm")
	_body_parts[BodyPart.LOWER_RIGHT_ARM] = get_node("RightLowerArm")
	_body_parts[BodyPart.LOWER_LEFT_LEG] = get_node("LeftLowerLeg")
	_body_parts[BodyPart.LOWER_RIGHT_LEG] = get_node("RightLowerLeg")
	_body_parts[BodyPart.UPPER_LEFT_LEG] = get_node("LeftUpperLeg")
	_body_parts[BodyPart.UPPER_RIGHT_LEG] = get_node("RightUpperLeg")

	_connect_parts()
	#_initial_position = create_memento()
	




func _physics_process(delta):
	if(_active):
		if _reset_requested:
			reset_position()
			_reset_requested = false
		else:
			_drag_move(delta)

			var distance = max(2,_camera.global_position.distance_to(_cameraTarget)/100)
			_camera.global_position = _camera.global_position.lerp(_cameraTarget, delta*distance)

			if(_idling):
				_idle(delta)
			elif(_floorCast.is_colliding() && abs(_body_parts[BodyPart.HEAD].angular_velocity) < 0.2 && abs(_body_parts[BodyPart.TORSO].angular_velocity) < 0.2):
				if(Time.get_ticks_msec() - _lastImpulse > 300):
					_idling = true

			_floorCast.global_position = _body_parts[BodyPart.TORSO].global_position



func _drag_move(_delta):
	var mousePos = get_global_mouse_position()

	if(Input.is_action_pressed("ui_select") && _can_be_dragged):
		if(_selectedPart == null):
			var hovered = _get_hovered_part()
			if(hovered != null):
				_selectedPart = hovered
		else:
			var force = (mousePos - _selectedPart.global_position)/1.5
			_selectedPart.apply_impulse(force)
		_lastImpulse = Time.get_ticks_msec()
		_idling = false
		_idle_since = 0
	else:
		_selectedPart = null
		_cameraTarget = Vector2(
			clamp(_body_parts[BodyPart.TORSO].global_position.x,-_cameraLimitX,_cameraLimitX),
			clamp(_body_parts[BodyPart.TORSO].global_position.y,-_cameraLimitY,_cameraLimitY)
			)

var _idle_since = 0

func _idle(delta):
	_idle_since += delta
	if(_floorCast.is_colliding()):
		_body_parts[BodyPart.HEAD].apply_central_impulse(Vector2(0,-60))
		_body_parts[BodyPart.TORSO].apply_central_impulse(Vector2(0,-75))
	if(_show_next_poem && _idle_since > 1.0):
		_show_poem()


func _on_item_collected(collectible):
	_can_be_dragged = false
	_show_next_poem = true

func _show_poem():
	_show_next_poem = false
	var bubble = _director.create_speech_bubble(_body_parts[BodyPart.HEAD])
	bubble.write("idézet")
	bubble.connect("text_ended",Callable(self,"_on_poem_end"))

func _on_poem_end():
	_can_be_dragged = true

#--------------------- Memento -----------------------

#var _initial_position
var _reset_requested = false


func reset_position():
	_active = false
	_director.reset_player()
	#restore_memento(_initial_position)
	

func _on_reset_trigger_area_entered(area):
	_reset_requested = true


#Does not work with physics bodies
#func create_memento():
#	var memento = {
#		positions = [],
#		rotations = []
#	}
#	for part in _body_parts:
#		memento.positions.append(part.global_position)
#		memento.rotations.append(part.global_rotation)
#	return memento
#
#func restore_memento(memento):
#	for i in range(_body_parts.size()):
#		_body_parts[i].freeze = true
#		_body_parts[i].lock_rotation = true
#		_body_parts[i].sleeping = true
#		_body_parts[i].global_position = memento.positions[i]
#		_body_parts[i].global_rotation = memento.rotations[i]
#		_body_parts[i].force_update_transform()
#		_body_parts[i].freeze = false
#		_body_parts[i].lock_rotation = false
#		_body_parts[i].sleeping = false


#--------------------- Signals -----------------------


var _hoveringAboveParts = [null,null,null,null,null,null,null,null,null,null]

func _connect_parts():
	for i in range(_body_parts.size()):
		_body_parts[i].connect("mouse_entered", Callable(self, "_on_mouse_entered_body_part").bind(i))
		_body_parts[i].connect("mouse_exited", Callable(self, "_on_mouse_exited_body_part").bind(i))


func _get_hovered_part():
	for i in range(9, -1, -1):
		if(_hoveringAboveParts[i] != null):
			return _hoveringAboveParts[i]
	return null

func _on_mouse_entered_body_part(part):
	_hoveringAboveParts[part] = _body_parts[part]

func _on_mouse_exited_body_part(part):
	_hoveringAboveParts[part] = null
