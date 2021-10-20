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
onready var bossCutinSpawner = $BossCutinSpawner
onready var bossCutinTimer = $BossCutinTimer
onready var okuuCaution = $OkuuCaution

var gameOverTimer: int = -1


# Preloads
var preloadLifeIcon = preload("res://HUD/LifeIcon.tscn")
var preloadBombIcon = preload("res://HUD/BombIcon.tscn")

var preloadBossSpellIcon = preload("res://HUD/BossSpellIcon.tscn")
var preloadBossCutin = preload("res://HUD/BossCutin.tscn")


# Sfx players
onready var sfx = $Sfx
onready var sfx2 = $Sfx2
onready var sfxP = $SfxPlayer
var playerBomb = preload("res://SA Assets/Usable/Sound/se_nep00.wav")
var enemyDie = preload("res://SA Assets/Usable/Sound/se_enep00.wav")
var okuuSpell = preload("res://SA Assets/Usable/Sound/se_alert.wav")
var bossSpellEnd = preload("res://SA Assets/Usable/Sound/se_enep02.wav")
var bossDie = preload("res://SA Assets/Usable/Sound/se_enep01.wav")

# Music player
onready var music = $Music
var TheBridge = preload("res://SA Assets/Usable/Audio/The_Bridge_People_No_Longer_Cross.ogg")
var SatoriMaiden = preload("res://SA Assets/Usable/Audio/Satori Maiden ~ 3rd Eye (RichaadEB).ogg")
var lullabyTimer: int = 211
var Lullaby = preload("res://SA Assets/Usable/Audio/Lullaby_of_Deserted_Hell_Folk.ogg")
var NuclearFusion = preload("res://SA Assets/Usable/Audio/Nuclear_Fusion_SymphonicMetal.ogg")
var endTimer: int = 181



# ============ Functions ================================

func _ready() -> void:
	music.set_stream(TheBridge)
	music.play()
	
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
	Signals.connect("bombExploded", self, "_onBombExploded")
	
	Signals.connect("playerPointsChanged", self, "_onPlayerPointsChanged")
	Signals.connect("enemyDie", self, "_onEnemyDie")
	
	Signals.connect("bossEntered", self, "_onBossEntered")
	Signals.connect("bossHPChanged", self, "_onBossHPChanged")
	Signals.connect("bossSpellsChanged", self, "_onBossSpellsChanged")
	Signals.connect("bossPhaseCutin", self, "_onBossPhaseCutin")
	Signals.connect("bossPhaseCutinEnd", self, "_onBossPhaseCutinEnd")
	Signals.connect("bossDied", self, "_onBossDied")
	
	
	Signals.connect("gameOver", self, "_onGameOver")

func _process(delta: float) -> void:
	
	if gameOverTimer > 0:
		gameOverTimer -= 1
	elif gameOverTimer == 0:
		# lose
		gameOverTransition()
	
	if lullabyTimer == 0:
		music.volume_db += 21 + 3
		music.set_stream(Lullaby)
		music.play()
		
		lullabyTimer = -1
		
	elif lullabyTimer > 0 and lullabyTimer <= 210:
		lullabyTimer -= 1
		music.volume_db -= 0.1
	
	if endTimer > 0 and endTimer <= 180:
		endTimer -= 1
		music.volume_db -= 0.12

# ----- Resources ------------------------

func _onEnemyDie(points: int):
	sfx.set_stream(enemyDie)
	sfx.play()
	
	score += points
	scoreCounter.text = str(score)
	
func _onPlayerPointsChanged(points: int):
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
	var oldBombCount: int = bombContainer.get_child_count()
	if bombs < oldBombCount and not bombs >= 5:
		sfxP.set_stream(playerBomb)
		sfxP.play()
	
	for bomb in bombContainer.get_children():
		bomb.queue_free()
	
	for i in range(bombs):
		var bombIcon = preloadBombIcon.instance()
		bombContainer.add_child(bombIcon)

func _onBombExploded():
	pass
	
func _graze():
	graze += 1
	grazeCounter.text = str(graze)
	
	
# ----- Gameplay --------------------

func _onBossEntered(_bossName: String):
	if _bossName == "Satori":
		bossName.text = "Satori Komeiji"
		music.set_stream(SatoriMaiden)
		music.play()
	elif _bossName == "Okuu" and bossName.visible == false:
		bossName.text = "Utsuho Reiuji"
		music.volume_db -= 6
		music.set_stream(NuclearFusion)
		music.play()
	
	bossHP.visible = true
	bossName.visible = true
	bossSpellContainer.visible = true
	

func _onBossHPChanged(HP: int, maxHP: int):
	bossHP.value = 100 * float(HP)/float(maxHP)		# percent of max HP

func _onBossSpellsChanged(bossName: String, newSpell: int):
	if bossName == "Satori" and newSpell < 2:
		sfx.set_stream(bossSpellEnd)
		sfx.play()
	elif bossName == "Okuu" and newSpell < 4:
		sfx.set_stream(bossSpellEnd)
		sfx.play()
	
	for bossSpell in bossSpellContainer.get_children():
		bossSpell.queue_free()
		
	for i in range(newSpell):
		var bossSpellIcon = preloadBossSpellIcon.instance()
		bossSpellContainer.add_child(bossSpellIcon)
	
func _onBossPhaseCutin(bossName: String, newPhase: int):
	var bossCutin = preloadBossCutin.instance()
	bossCutin.init(bossName)
	get_tree().current_scene.add_child(bossCutin)
	if bossName == "Satori":
		bossCutin.rect_global_position = bossCutinSpawner.global_position
	elif bossName == "Okuu":
		bossCutin.rect_global_position = bossCutinSpawner.global_position
		bossCutin.rect_global_position.x -= 150
		okuuCaution.visible = true
		sfx2.set_stream(okuuSpell)
		sfx2.volume_db += 18
		sfx2.play()
		sfx2.volume_db -= 18
	bossCutin.phaseAfterCutin = newPhase
	
func _onBossPhaseCutinEnd(bossName: String, newPhase: int):
	if bossName == "Okuu":
		okuuCaution.visible = false
	

func _onBossDied(_bossName: String):
	sfx.set_stream(bossDie)
	sfx.play()
	
	bossHP.visible = false
	bossName.visible = false
	bossSpellContainer.visible = false
	
	if _bossName == "Satori":
		lullabyTimer -= 1

# --------------------------------------

func _onGameOver():
	gameOverTimer = 120

func gameOverTransition():
	get_tree().change_scene("res://EndScreen.tscn")
