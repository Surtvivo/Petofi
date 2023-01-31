extends Control
class_name Director

const player_scene = preload("res://Scenes/player.tscn")
const speech_bubble_scene = preload("res://Scenes/speech_bubble.tscn")

signal collectible_added

var canvas:CanvasLayer
var level:Level
var player:Player
var hud:HUD
var _player_initial_position:Vector2


func _ready():
	player = get_node("Player") as Player
	canvas = get_node("CanvasLayer") as CanvasLayer
	level = get_node("Level") as Level
	hud = get_node("CanvasLayer/HUD") as HUD
	hud.init()
	_player_initial_position = player.position
	
	
func reset_player():
	player._active = false
	player.visible = false
	player.queue_free()
	player = player_scene.instantiate()
	player.position = _player_initial_position
	add_child(player)


func create_speech_bubble(head):
	var bubble = speech_bubble_scene.instantiate() as SpeechBubble
	canvas.add_child(bubble)
	bubble.pin_to_target(head)
	return bubble
