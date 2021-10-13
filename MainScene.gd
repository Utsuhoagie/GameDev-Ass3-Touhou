extends Node2D


# Variables
var cameraScrollSpeed: float = -0.8
var cameraOGScrollSpeed: float = -0.8
var bossResumeScrollTimer: int = -1

# Node refs
onready var currentPlayer = $Player
onready var camera = $Camera2D
onready var HUD = $CanvasLayer/HUD


# DEBUG CROSSHAIR


# Preloads
var preloadedPlayer = preload("res://Objects/Player/Player.tscn")


# ========= Functions ===========================

func _ready() -> void:
	
	Signals.connect("bossDied", self, "_onBossDied")
	#screenSize = get_viewport_rect().size
	#currentPlayer.connect("tree_exited", self, "_on_player_tree_exited_custom")
	#Signals.connect("onPlayerLivesChanged", self, "_onPlayerLivesChanged")

func _process(delta: float) -> void:
	
	if bossResumeScrollTimer > 0:
		bossResumeScrollTimer -= 1
	elif bossResumeScrollTimer == 0:
		cameraScrollSpeed = cameraOGScrollSpeed
		bossResumeScrollTimer = -1
	
	camera.position.y += cameraScrollSpeed
	HUD.bossCutinSpawner.position.y += cameraScrollSpeed
	
	if currentPlayer != null:
		currentPlayer.position.y += cameraScrollSpeed
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _onBossDied(bossName: String):
	print(bossName + " died!")
	if bossName == "Satori":
		bossResumeScrollTimer = 120
