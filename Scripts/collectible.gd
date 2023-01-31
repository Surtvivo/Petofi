extends Node2D
class_name Collectible

var hitbox:Area2D
var level: Level

func _ready():
	hitbox = get_node("Area2D")
	hitbox.connect("body_entered",Callable(self,"_collected"))
	level = get_parent() as Level
	level.add_collectible(self)
	


func _collected(bodypart):
	level.collected(self)
	queue_free()
