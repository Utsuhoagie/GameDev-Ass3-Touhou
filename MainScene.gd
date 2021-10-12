extends Node2D


# Variables
var cameraScrollSpeed: float = -0.8

# Node refs
onready var currentPlayer = $Player
onready var camera = $Camera2D


# DEBUG CROSSHAIR


# Preloads
var preloadedPlayer = preload("res://Objects/Player/Player.tscn")


# ========= Functions ===========================

func _ready() -> void:
	pass
	#screenSize = get_viewport_rect().size
	#currentPlayer.connect("tree_exited", self, "_on_player_tree_exited_custom")
	#Signals.connect("onPlayerLivesChanged", self, "_onPlayerLivesChanged")

func _process(delta: float) -> void:
	#print(camera.position)
	
	camera.position.y += cameraScrollSpeed
	if currentPlayer != null:
		currentPlayer.position.y += cameraScrollSpeed
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
