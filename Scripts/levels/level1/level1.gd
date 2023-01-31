extends Level


var _wall: StaticBody2D

func _ready():
	_director = get_parent() as Director
	_wall = get_node("Wall")


func _process(delta):
	pass




func collected(collectible):
	_director.player._on_item_collected(collectible)
	_collected += 1
	_director.emit_signal("collectible_added")
	if(_collected > 3):
		(_wall.get_child(0) as CollisionShape2D).disabled = true
	if(_collected == _required_collectibles):
		_level_completed()


func _level_completed():
	pass
