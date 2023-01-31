extends Node2D

const leg_angle_min = -0.78
const leg_angle_max = 0.78

var legs = []
var legs_rotation_dir = []

@export var speed = 200
@export var anim_speed = 1.5

enum Direction{
	Left,
	Right
}

var direction:Direction = Direction.Left


func _ready():
	legs.append(get_node("Leg1"))
	legs.append(get_node("Leg2"))
	legs.append(get_node("Leg3"))
	legs.append(get_node("Leg4"))
	legs_rotation_dir.append(Direction.Left)
	legs_rotation_dir.append(Direction.Right)
	legs_rotation_dir.append(Direction.Left)
	legs_rotation_dir.append(Direction.Right)


func _process(delta):
	
	animate_legs(delta)
	var step = Vector2(0, 0)
	if direction == Direction.Left:
		step.x -= 1
	else:
		step.x += 1
	position += step * delta * speed


func animate_legs(delta):
	for i in range(legs.size()):
		var angle = legs[i].rotation
		if angle > leg_angle_max or angle < leg_angle_min:
			if legs_rotation_dir[i] == Direction.Left:
				legs_rotation_dir[i] = Direction.Right
			else:
				legs_rotation_dir[i] = Direction.Left
		if legs_rotation_dir[i] == Direction.Left:
			legs[i].rotation += delta*anim_speed
		else:
			legs[i].rotation -= delta*anim_speed

	
func _on_obstacle_entered(body):
	if direction == Direction.Left:
		direction = Direction.Right
		scale.x = -1
	else:
		direction = Direction.Left
		scale.x = 1
	
