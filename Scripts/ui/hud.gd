extends MarginContainer
class_name HUD

var _slot_texture = preload("res://Assets/ui/slot.png")
var _food_texture = preload("res://Assets/ui/food.png")

var _plate: HBoxContainer
var _director: Director

var _slots = []


func init():
	_director = get_parent().get_parent() as Director
	_director.connect("collectible_added",Callable(self,"add_food"))
	_plate = get_node("VBoxContainer/Plate") as HBoxContainer
	for i in range((_director.level as Level)._required_collectibles):
		var slot = TextureRect.new()
		slot.texture = _slot_texture
		_slots.append(slot)
		_plate.add_child(slot)


func add_food():
	var i = _director.level._collected-1
	_slots[i].texture = _food_texture
