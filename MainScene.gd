extends Node2D


# Variables
var cameraScrollSpeed: float = -0.65
var cameraScrollSpeed2: float = -0.25
var bossResumeScrollTimer: int = -1

var okuuBGSpin: bool = false
var okuuBGSpinDegree: float = 0.15

var gameOverTimer: int = -1

# Node refs
onready var player = $Player
onready var camera = $Camera2D
onready var HUD = $CanvasLayer/HUD
onready var playArea = $PlayArea
onready var backgrounds = $Backgrounds

# Music player


# Preloads
var preloadedPlayer = preload("res://Objects/Player/Player.tscn")


# ========= Functions ===========================

func _ready() -> void:
	Signals.connect("bombExploded", self, "clearAllBullets")
	Signals.connect("bossEntered", self, "_onBossEntered")
	Signals.connect("bossDied", self, "_onBossDied")


func _process(delta: float) -> void:
	
	if gameOverTimer > 0:
		gameOverTimer -= 1
	elif gameOverTimer == 0:
		get_tree().change_scene("res://EndScreen.tscn")
	
	if bossResumeScrollTimer > 0:
		bossResumeScrollTimer -= 1
	elif bossResumeScrollTimer == 0:
		cameraScrollSpeed = cameraScrollSpeed2
		bossResumeScrollTimer = -1
	
	if okuuBGSpin:
		backgrounds.get_child(3).rotation_degrees += okuuBGSpinDegree
	
	camera.position.y += cameraScrollSpeed
	playArea.position.y += cameraScrollSpeed
	HUD.bossCutinSpawner.position.y += cameraScrollSpeed

	
	if player != null:
		player.position.y += cameraScrollSpeed
	
	
	if Input.is_action_pressed("increase_scroll"):
		cameraScrollSpeed -= 0.05
		cameraScrollSpeed2 -= 0.05
		print("Cam1 = %s /t Cam2 = %s" % [cameraScrollSpeed, cameraScrollSpeed2])
	if Input.is_action_pressed("decrease_scroll"):
		cameraScrollSpeed += 0.05
		cameraScrollSpeed2 += 0.05
		print("Cam1 = %s /t Cam2 = %s" % [cameraScrollSpeed, cameraScrollSpeed2])
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _onBossEntered(bossName: String):
	if bossName == "Satori":
		cameraScrollSpeed = 0
		backgrounds.get_child(1).play("Default")
	elif bossName == "Okuu":
		cameraScrollSpeed = 0
		okuuBGSpin = true
		#backgrounds.get_child(3)


func _onBossDied(bossName: String):
	if bossName == "Satori":
		bossResumeScrollTimer = 180
		backgrounds.get_child(1).play("Reverse")
	elif bossName == "Okuu":
		clearAllBullets()
		gameOverTimer = 180
		
func clearAllBullets():
	for eBullet in self.get_children():
		if eBullet.is_in_group("eBullet") or (eBullet.name.substr(0,3) == "@S_"):
			eBullet.queue_free()
