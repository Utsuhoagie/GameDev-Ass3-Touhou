extends Node

var isAlreadyPlaying: bool = false
onready var music = $Music

var EarthSpirits = load("res://SA Assets/Usable/Audio/Awakening of the Earth Spirits - Ryuuha Mikakutei.ogg")
var GameOver = load("res://SA Assets/Usable/Audio/Game Over.ogg")


func _ready() -> void:
	music.set_stream(EarthSpirits)
	music.play()
	isAlreadyPlaying = true
	
