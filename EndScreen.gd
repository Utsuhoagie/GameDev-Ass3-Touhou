extends Control


func _ready() -> void:
	MenuMusicController.get_child(0).stream = MenuMusicController.GameOver
	MenuMusicController.get_child(0).play()
	pass


func _on_Return_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")
	MenuMusicController.isAlreadyPlaying = false
