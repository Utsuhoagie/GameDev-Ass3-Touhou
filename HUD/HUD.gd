extends Control

# Variables
var score: int = 0
var power: float = 1.0
var graze: int = 0


# Node refs
onready var scoreCounter = $Score
onready var powerCounter = $Power
onready var lifeContainer = $LifeContainer
onready var bombContainer = $BombContainer
onready var grazeCounter = $Graze


onready var bossHP = $BossHP
onready var bossName = $BossName
onready var bossSpellContainer = $BossSpellContainer
var bossCutinTopPos = Vector2(0, -256)
onready var bossCutinSpawner = $BossCutinSpawner
onready var bossCutinTimer = $BossCutinTimer


# Preloads
var preloadLifeIcon = preload("res://HUD/LifeIcon.tscn")
var preloadBombIcon = preload("res://HUD/BombIcon.tscn")

var preloadBossSpellIcon = preload("res://HUD/BossSpellIcon.tscn")
var preloadBossCutin = preload("res://HUD/BossCutin.tscn")
var preloadLoseText = preload("res://HUD/LoseText.tscn")


# ============ Functions ================================

func _ready() -> void:
	for life in lifeContainer.get_children():
		life.queue_free()
	for bomb in bombContainer.get_children():
		bomb.queue_free()
	
	bossHP.visible = false
	bossName.visible = false
	bossSpellContainer.visible = false	
	
	Signals.connect("playerPowerChanged", self, "_onPlayerPowerChanged")
	Signals.connect("playerLivesChanged", self, "_onPlayerLivesChanged")
	Signals.connect("playerBombsChanged", self, "_onPlayerBombsChanged")
	Signals.connect("playerGraze", self, "_graze")
	
	
	Signals.connect("enemyDie", self, "_onEnemyDie")
	
	Signals.connect("bossEntered", self, "_onBossEntered")
	Signals.connect("bossHPChanged", self, "_onBossHPChanged")
	Signals.connect("bossSpellsChanged", self, "_onBossSpellsChanged")
	Signals.connect("bossPhaseCutin", self, "_onBossPhaseCutin")
	Signals.connect("bossDied", self, "_onBossDied")
	
	
	Signals.connect("lose", self, "_lose")



# ----- Resources ------------------------

func _onEnemyDie(points: int):
	score += points
	scoreCounter.text = str(score)

func _onPlayerPowerChanged(newPower: float):
	power = newPower
	powerCounter.text = "%.1f" % power

func _onPlayerLivesChanged(lives: int):
	for life in lifeContainer.get_children():
		life.queue_free()
		
	for i in range(lives):
		var lifeIcon = preloadLifeIcon.instance()
		lifeContainer.add_child(lifeIcon)
	
func _onPlayerBombsChanged(bombs: int):
	for bomb in bombContainer.get_children():
		bomb.queue_free()
	
	for i in range(bombs):
		var bombIcon = preloadBombIcon.instance()
		bombContainer.add_child(bombIcon)

	
func _graze():
	graze += 1
	grazeCounter.text = str(graze)
	
func _process(delta: float) -> void:
	#print(rect_global_position)
	pass
# ----- Gameplay --------------------

func _onBossEntered(_bossName: String):
	bossHP.visible = true
	bossName.visible = true
	bossName.text = _bossName
	bossSpellContainer.visible = true

func _onBossHPChanged(HP: int, maxHP: int):
	bossHP.value = 100 * float(HP)/float(maxHP)		# percent of max HP

func _onBossSpellsChanged(newSpell: int):
	for bossSpell in bossSpellContainer.get_children():
		bossSpell.queue_free()
		
	for i in range(newSpell):
		var bossSpellIcon = preloadBossSpellIcon.instance()
		bossSpellContainer.add_child(bossSpellIcon)
	
func _onBossPhaseCutin(newPhase: int):
	var bossCutin = preloadBossCutin.instance()
	bossCutin.rect_global_position = bossCutinSpawner.global_position
	bossCutin.phaseAfterCutin = newPhase
	get_tree().current_scene.add_child(bossCutin)

func _onBossDied(_bossName: String):
	bossHP.visible = false
	bossName.visible = false
	bossSpellContainer.visible = false

# --------------------------------------

func _lose():
	var loseText = preloadLoseText.instance()
	var pos = Vector2(192, 320) - (loseText.rect_size/2 * loseText.rect_scale)
	loseText.rect_position = pos
	self.add_child(loseText)
