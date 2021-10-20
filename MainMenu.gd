extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not MenuMusicController.isAlreadyPlaying:
		MenuMusicController.get_child(0).stream = MenuMusicController.EarthSpirits
		MenuMusicController.get_child(0).play()
		MenuMusicController.isAlreadyPlaying = true


func _on_Start_pressed() -> void:
	MenuMusicController.get_child(0).playing = false
	MenuMusicController.isAlreadyPlaying = false
	get_tree().change_scene("res://MainScene.tscn")

func _on_Options_pressed() -> void:
	get_tree().change_scene("res://OptionsMenu.tscn")
	
func _on_About_pressed() -> void:
	get_tree().change_scene("res://AboutMenu.tscn")

func _on_Quit_pressed() -> void:
	get_tree().quit()
