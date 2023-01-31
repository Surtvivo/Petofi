extends Node2D
class_name Level

var _required_collectibles = 0
var _collected = 0
var _director:Director

func _ready():
	_director = get_parent() as Director


func _process(delta):
	pass


func add_collectible(collectible):
	_required_collectibles+=1


func collected(collectible):
	_director.player._on_item_collected(collectible)
	_collected+=1
	if(_collected == _required_collectibles):
		_level_completed()


func _level_completed():
	pass
