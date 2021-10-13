extends Enemy

var maxHP: int

export var bossName: String
enum Phase { NonSpell_1, Spell_1, NonSpell_2, Spell_2, Spell_3 }
var spellCount: int
var currentPhase
var changingPhase: bool = false

var angle: float = 0.0

func _ready():
	init(bossName)
	
func init(_bossName: String):
	
	# Basic boss stats
	isBoss = true
	speed = 0
	decel = 0
	
	# Boss' bullets
	preloadBullet = preload("res://Objects/Bullets/EBullet1.tscn")
	
	# Boss-specific stats
	bossName = _bossName
	
	if bossName == "Satori":
		HP = 10
		maxHP = 10
		spellCount = 2
		fireInterval = 0.3
		
		drops = {
			P_Small: 0,
			P_Big: 1,
			Bomb: 1,
			Points: 2500
		}
		
	elif bossName == "Okuu":
		HP = 150
		maxHP = 150
		spellCount = 3
		fireInterval = 0.2
		
		drops = {
			P_Small: 0,
			P_Big: 0,
			Bomb: 0,
			Points: 5000
		}
	
	
	# Signals
	Signals.emit_signal("bossHPChanged", HP, maxHP)
	Signals.emit_signal("bossSpellsChanged", spellCount)
	Signals.connect("bossPhaseCutinEnd", self,"_onBossPhaseCutinEnd")
	currentPhase = Phase.NonSpell_1
	
	fireTimer.start(fireInterval)
	
func _process(delta: float) -> void:
	pass



func fire():
	if active and not changingPhase:
		randomize()
		
		if bossName == "Satori":
			for gun in firePos.get_children():
				if currentPhase == Phase.NonSpell_1:
					var bullet = preloadBullet.instance()
					bullet.global_position = gun.global_position
					bullet.angle = 0
					get_tree().current_scene.add_child(bullet)
					
				elif currentPhase == Phase.Spell_1:
					var bullet = preloadBullet.instance()
					bullet.global_position = gun.global_position
					bullet.angle = angle
					angle += 185
					fireInterval = 0.016
					fireTimer.start(fireInterval)
					get_tree().current_scene.add_child(bullet)

func reduceHP(damage: int):
	if active and not changingPhase:
		isDamaged = true
		animSprite.animation = "Damaged"
	
		if HP <= 0:
			return
	
		HP -= damage
		Signals.emit_signal("bossHPChanged", HP, maxHP)
		
		# ------ Phase transition --------------------
		if HP <= 0:
			HP = 0
			Signals.emit_signal("enemyDie", drops[Points])
			Signals.emit_signal("bossDied", bossName)
			drop_items()
			queue_free()
		elif HP <= maxHP/2 and currentPhase == Phase.NonSpell_1:
			#currentPhase = Phase.Spell_1
			spellCount -= 1
			changingPhase = true
			Signals.emit_signal("bossSpellsChanged", spellCount)
			Signals.emit_signal("bossPhaseCutin", Phase.Spell_1)
	
func _onBossPhaseCutinEnd(newPhase):
	changingPhase = false
	currentPhase = newPhase

func _on_FireTimer_timeout() -> void:
	fire()
