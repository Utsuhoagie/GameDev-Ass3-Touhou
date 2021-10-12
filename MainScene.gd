extends Node2D


# Variables
var screenSize
var life: int

# Node refs
onready var currentPlayer = $Player

# Preloads
var preloadedPlayer = preload("res://Objects/Player/Player.tscn")


# ========= Functions ===========================

func _ready() -> void:
	screenSize = get_viewport_rect().size
	#currentPlayer.connect("tree_exited", self, "_on_player_tree_exited_custom")
	#Signals.connect("onPlayerLivesChanged", self, "_onPlayerLivesChanged")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
