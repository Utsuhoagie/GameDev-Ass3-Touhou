extends Control

var timer: int = 240

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if timer > 0:
		timer -= 1
	else:
		get_tree().change_scene("res://MainMenu.tscn")
