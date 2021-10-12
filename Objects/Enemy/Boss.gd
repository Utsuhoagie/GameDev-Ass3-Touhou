extends Enemy

var maxHP: int

enum Phase { NonSpell_1, Spell_1, NonSpell_2, Spell_2 }
var currentPhase

func _ready():
	#animSprite.play("Default")
	HP = 80
	maxHP = 80
	speed = 300
	decel = 5
	
	preloadBullet = preload("res://Objects/Bullets/EBullet1.tscn")
	
	fireInterval = 0.4
	fireTimer.start(fireInterval)
	
	currentPhase = Phase.NonSpell_1
	

	
func _process(delta: float) -> void:
	if HP <= maxHP/2:
		currentPhase = Phase.Spell_1



func fire():
	randomize()
	for gun in firePos.get_children():
		if currentPhase == Phase.NonSpell_1:
			var bullet = preloadBullet.instance()
			bullet.global_position = gun.global_position
			bullet.angle = 0
			get_tree().current_scene.add_child(bullet)
			
		elif currentPhase == Phase.Spell_1:
			var bullet = preloadBullet.instance()
			bullet.global_position = gun.global_position
			bullet.angle = rand_range(-45.0, 45.0)
			fireInterval = 0.00001
			fireTimer.start(fireInterval)
			get_tree().current_scene.add_child(bullet)

func reduceHP(damage: int):
	isDamaged = true
	animSprite.animation = "Damaged"
	
	HP -= damage
	if HP <= 0:
		HP = 0
		queue_free()
	elif HP <= 70 and currentPhase == Phase.NonSpell_1:
		currentPhase = Phase.Spell_1
		Signals.emit_signal("bossPhaseCutin", currentPhase)
	

func _on_FireTimer_timeout() -> void:
	fire()
