extends Boss


var moveFlip: bool = false


var stateWait: int = 120


# Non1 timers and deviations
var n1Timer: int = 0
var n1Dev: float = 9
var n1Flip: bool = false

# Spell1 timers and deviations
var s1Timer: int = 0


# Spell2 timers and deviations
var s2Timer: int = 0
var s2Dev: float = 0
var s2Accel: float = 0
var s2AccelFlip: bool = false

# =========================================

func _ready() -> void:

	bossName = "Satori"
	
	HP = 1000	
	maxHP = 1000
	spellCount = 2

	score = 2500
	drops = {
		SDrop: 10,
		P_Small: 0,
		P_Big: 1,
		Bomb: 1,
		Life: 1
	}
	

func _process(delta: float) -> void:
	if stateWait == 0:
		if active and not changingPhase and HP > 0:
			if currentPhase == NonSpell_1:
				if !moveFlip:
					position.x += 0.3
				else:
					position.x -= 0.3
					
				if position.x <= 128 or position.x >= 256:
					moveFlip = !moveFlip
				position.x = clamp(position.x, 96, 288)
			fire(delta)
	elif active:
		stateWait -= 1


func fire(delta: float):
	#currentPhase.patternFire()
	if not active or changingPhase: return
		
	randomize()
	
	# currentPhase = NonSpell_1 or something...
	# phases[currentPhase] = Non1 (Node2D)
	#for gun in phases[currentPhase].get_children():		# get firing positions
	var gunList = phases[currentPhase].get_children()
	if currentPhase == NonSpell_1:
		# Big + Leaf
		
		if n1Timer == 0:
			for gun in gunList:
				var bullet = plBullets[Big].instance()
				bullet.color = bigColor.BLUE if randi() % 2 == 0 else bigColor.RED
				bullet.global_position = gun.global_position
				bullet.angle = gun.rotation_degrees
				get_tree().current_scene.add_child(bullet)
		
			# reset timers, deviations		
			n1Timer = 90
			n1Dev = -8
			n1Flip = false
		elif n1Timer >= 75 and n1Timer % 1 == 0:
			if n1Dev >= 76:
				n1Flip = true
			if n1Flip:
				n1Dev -= 9
			else:
				n1Dev += 9
				
			for gun in gunList:
				var bullet = plBullets[Leaf].instance()
				bullet.color = color.BLUE if randi() % 2 == 0 else color.RED
				bullet.global_position = gun.global_position
				bullet.angle = gun.rotation_degrees + n1Dev
				get_tree().current_scene.add_child(bullet)
		
		n1Timer -= 1
	
	
	
	elif currentPhase == Spell_1:
		# Lasers + homing Rounds
		
		if s1Timer == 0:
			for i in range(0,6):
				var bullet = plBullets[Round].instance()
				bullet.satoriS1 = true
				bullet.color = color.PINK
				bullet.global_position = gunList[0].global_position
				bullet.angle = i*60
				get_tree().current_scene.add_child(bullet)
				bullet.updateSpeed(45)
			
			s1Timer = 151
			
		elif s1Timer % 15 == 0:
			var laserIndex = s1Timer / 15
			
			var bullet = plBullets[Laser].instance()
			bullet.color = color.PINK
			bullet.global_position = gunList[laserIndex].global_position
			bullet.angle = 0
			get_tree().current_scene.add_child(bullet)

		if s1Timer == 15:
			var playerPos: Vector2 = get_node("/root/MainScene/Player").global_position
			Signals.emit_signal("satoriS1Homing", playerPos, delta)
			
		s1Timer -= 1
		
		
		
	elif currentPhase == Spell_2:
		# spiral Leaf stream + micrododge
		
		var bullet = plBullets[Leaf].instance()
		bullet.global_position = gunList[0].global_position
		bullet.color = color.PINK
		bullet.angle = s2Dev
		s2Dev += s2Accel
		if s2AccelFlip:
			s2Accel -= 0.1
		else:
			s2Accel += 0.1
		if s2Accel >= 30:
			s2Accel = -30
			
		if abs(s2Accel) < 8:
			if s2Accel < 8 and s2Accel > 0:
				s2Accel = 8
				s2AccelFlip = false
			elif s2Accel > -8 and s2Accel < 0:
				s2Accel = -8
				s2AccelFlip = true
		get_tree().current_scene.add_child(bullet)

func reduceHP(damage: int):
	if active and not changingPhase:
		if HP <= 0:
			return
	
		HP -= damage
		Signals.emit_signal("bossHPChanged", HP, maxHP)
		
		# ------ Phase transition --------------------
		if HP <= 0:
			HP = 0
			Signals.emit_signal("enemyDie", score)
			Signals.emit_signal("bossDied", bossName)
			bDieExplosion.play("Implode")
			drop_items()
			dead = true
			#queue_free()
			
		elif HP <= maxHP/3 and currentPhase == Spell_1:
			movingToCenter = true
			spellCount -= 1
			changingPhase = true
			stateWait = 90
			
			Signals.emit_signal("bossSpellsChanged", bossName, spellCount)
			Signals.emit_signal("bossPhaseCutin", bossName, Spell_2)
				
		elif HP <= maxHP*2/3 and currentPhase == NonSpell_1:
			
			movingToCenter = true
			spellCount -= 1
			changingPhase = true
			stateWait = 90
			
			Signals.emit_signal("bossSpellsChanged", bossName, spellCount)
			Signals.emit_signal("bossPhaseCutin", bossName, Spell_1)
