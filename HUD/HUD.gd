extends Control

# Variables
var graze: int = 0
var bossCutinTopPos = Vector2(0, -256)


# Node refs
onready var lifeContainer = $LifeContainer
onready var bombContainer = $BombContainer
onready var grazeCounter = $Graze

onready var bossCutinSpawner = $BossCutinSpawner
onready var bossCutinTimer = $BossCutinTimer


# Preloads
var preloadLifeIcon = preload("res://HUD/LifeIcon.tscn")
var preloadBombIcon = preload("res://HUD/BombIcon.tscn")

var preloadBossCutin = preload("res://HUD/BossCutin.tscn")
var preloadLoseText = preload("res://HUD/LoseText.tscn")


# ============ Functions ================================

func _ready() -> void:
	for life in lifeContainer.get_children():
		life.queue_free()
	for bomb in bombContainer.get_children():
		bomb.queue_free()
	
	Signals.connect("playerLivesChanged", self, "_onPlayerLivesChanged")
	Signals.connect("playerBombsChanged", self, "_onPlayerBombsChanged")
	Signals.connect("playerGraze", self, "_graze")
	Signals.connect("bossPhaseCutin", self, "_onBossPhaseCutin")
	Signals.connect("lose", self, "_lose")



# ----- Resources ------------------------

func setLives(n: int):
	for life in lifeContainer.get_children():
		life.queue_free()
		
	for i in range(n):
		var lifeIcon = preloadLifeIcon.instance()
		lifeContainer.add_child(lifeIcon)

func setBombs(n: int):
	for bomb in bombContainer.get_children():
		bomb.queue_free()
	
	for i in range(n):
		var bombIcon = preloadBombIcon.instance()
		bombContainer.add_child(bombIcon)

func _onPlayerLivesChanged(lives: int):
	setLives(lives)
	
func _onPlayerBombsChanged(bombs: int):
	setBombs(bombs)
	
func _graze():
	graze += 1
	grazeCounter.text = "Graze : %s" % graze
	
	
# ----- Gameplay --------------------
	
func _onBossPhaseCutin(newPhase: int):
	var bossCutin = preloadBossCutin.instance()
	bossCutin.rect_global_position = bossCutinSpawner.global_position
	get_tree().current_scene.add_child(bossCutin)


func _lose():
	var loseText = preloadLoseText.instance()
	var pos = Vector2(192, 320) - (loseText.rect_size/2 * loseText.rect_scale)
	loseText.rect_position = pos
	self.add_child(loseText)
