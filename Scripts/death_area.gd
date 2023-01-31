extends Area2D



func _ready():
	connect("body_entered", Callable(self, "_on_player_entered"))




func _on_player_entered(bodypart):
	(bodypart.get_parent() as Player).reset_position()
