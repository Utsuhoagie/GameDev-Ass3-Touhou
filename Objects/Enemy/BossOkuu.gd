extends Boss


var moveFlip: bool = false

var stateWait: int = 120

onready var currentPlayArea = get_node("/root/MainScene/PlayArea")

# Non1 timers and deviations
var n1Timer: int = 0
var n1RandAngle: float
var n1Offset: float = 8.0
var n1Dev: float = 8
var n1Flip: bool = false

# Spell1 timers and deviations
var s1Timer: int = 75
var s1FirstShot: bool = true
var s1SunAngle: float
var s1RoundAngle: float
var s1RoundDev: float
var s1RoundSpdDev: float

# Non2 timers and deviations
var n2Timer: int = 240
var n2MoveAngle: float = 105
var n2OriginalY: float
var n2RoundDev: float
var n2BigDev: float = rand_range(12,25)
var n2BigOffset: float

# Spell2 timers and deviations
var s2Timer: int = 0
var s2CurrentGunIndex: int = 0
var s2StartX: float = 210
var s2StartY: float = 50
var s2Accel: float = 0
var s2AccelFlip: bool = false

# Last Spell timers and deviations
var lsTimer: int = 0
var lsCenter = Vector2(192,320)
var lsMoveToCenter: bool = false
var lsAtCenter: bool = false
var lsSunCreated: bool = false

var lsLineAngle: float = 0
var lsLineLength: float = 250
var lsLine = [lsCenter, Vector2.ZERO]

var lsOutStart: bool = false
var lsOutAngle: float = -90
var lsOutSpdDev: float

# ===============================================

func _ready() -> void:
	bossName = "Okuu"
	
	n2OriginalY = global_position.y + 96
	
	HP = 2000
	maxHP = 2000
	spellCount = 4

	score = 5000
	drops = {
		SDrop: 0,
		P_Small: 0,
		P_Big: 0,
		Bomb: 0,
		Life: 0
	}

	Signals.connect("okuuLSStartFreeing", self, "_onOkuuLSStartFreeing")
	

func _process(delta: float) -> void:
	if lsCenter != currentPlayArea.global_position:
		lsCenter = currentPlayArea.global_position
	
	if lsMoveToCenter and not lsAtCenter:
		speed = 0
		angle = 0
		if not (abs(global_position.y - lsCenter.y) <= 4):
			global_position = lerp(global_position, lsCenter, 0.04)
		else:
			lsAtCenter = true
	
	if stateWait == 0 and HP > 0:
		animSprite.animation = "Spell"
		fire(delta)
	elif active:
		animSprite.animation = "Active"
		stateWait -= 1


func fire(delta: float):
	if not active or changingPhase: return
		
	randomize()
	
	# currentPhase = NonSpell_1 or something...
	# phases[currentPhase] = Non1 (Node2D)
	
	var gunList = phases[currentPhase].get_children()		# get firing positions
	
	
	if currentPhase == NonSpell_1:
		# 24 straight, delayed Bigs

		if n1Timer > 60 and n1Timer % 4 == 0:
			for gun in gunList:
				# create 2 or 3 Bigs
				var maxBullets: int = 3 if int(gun.name[3]) <= 2 else 2
				
				for i in range(0,maxBullets):
					var bullet = plBullets[Big].instance()
					bullet.okuuN1 = true
					bullet.updateSpeed(32)
					bullet.color = bigColor.YELLOW
					match i:
						0: bullet.angle = gun.rotation_degrees - n1RandAngle + n1Offset
						1: bullet.angle = gun.rotation_degrees + n1RandAngle + n1Offset
						2: bullet.angle = gun.rotation_degrees + n1Offset
							
					bullet.global_position = gun.global_position
					get_tree().current_scene.add_child(bullet)
					
		elif n1Timer == 0:
			n1RandAngle = rand_range(7, 20)
			n1Timer = 120
			
		n1Timer -= 1
			
			
	
	elif currentPhase == Spell_1:
		# 4 suns (big Rounds) + slightly off-speed Rounds
		
		if s1Timer == 0:
			if s1FirstShot:
				s1FirstShot = false
			
			s1SunAngle = rand_range(-30, 30)
			for i in range(0,4):
				var bullet = plBullets[RoundCl].instance()
				get_tree().current_scene.add_child(bullet)
				bullet.color = color.RED
				bullet.scaleTo(Vector2(3.5, 3.5))
				bullet.global_position = gunList[i].global_position
				bullet.angle = gunList[i].rotation_degrees + s1SunAngle
				bullet.updateSpeed(64)
		
			# reset timers, deviations		
			s1Timer = 210
			
		elif s1Timer > 30 and s1Timer < 195 and s1Timer % 3 == 0 and not s1FirstShot:
			s1RoundDev = rand_range(-5, 5)
			s1RoundSpdDev = rand_range(30, 100)
			
			var bullet = plBullets[Round].instance()
			get_tree().current_scene.add_child(bullet)
			bullet.color = color.BLUE
			bullet.global_position = gunList[4].global_position
			bullet.angle = s1RoundAngle + s1RoundDev
			bullet.updateSpeed(s1RoundSpdDev)
			
			
			s1RoundAngle += 9
		
		s1Timer -= 1
	
	
	
	elif currentPhase == NonSpell_2:
		# move sideways + straight RoundCls
		# when timer = 0, stay center and shoot Bigs
		# else, move diagonally up, going left first then alternate every time off-screen
		
		# stop
		if n2Timer == 0:
			speed = 0
			angle = 0
			global_position = Vector2(192, n2OriginalY)
			
			n2BigOffset = rand_range(0,25)
			n2Timer = 360
			
		# shoot at center
		elif n2Timer > 240 and n2Timer % 10 == 0:
			n2BigDev = rand_range(12,25)
			for gunIndex in range(2,len(gunList)):
				#for i in range(0,2):
					var bullet1 = plBullets[Big].instance()
					var bullet2 = plBullets[Big].instance()
					bullet1.okuuN2 = true
					bullet2.okuuN2 = true
					bullet1.color = bigColor.YELLOW
					bullet2.color = bigColor.YELLOW
					get_tree().current_scene.add_child(bullet1)
					get_tree().current_scene.add_child(bullet2)
					bullet1.global_position = gunList[gunIndex].global_position
					bullet2.global_position = gunList[gunIndex].global_position
					bullet1.angle = gunList[gunIndex].rotation_degrees - n2BigDev + n2BigOffset
					bullet2.angle = gunList[gunIndex].rotation_degrees + n2BigDev + n2BigOffset
					bullet1.updateSpeed(400)
					bullet2.updateSpeed(400)
		
		# shoot straight RoundCls
		elif n2Timer > 30 and n2Timer <= 200:
			n2RoundDev = rand_range(-5, 5)
#
			speed = 500
			angle = n2MoveAngle
#
			if n2Timer % 16 == 0:
				for gunIndex in range(0,2):
					for i in range(0,5):
						var bullet = plBullets[RoundCl].instance()
						bullet.okuuN2 = true
						bullet.okuuN2LerpFactor = 0.03 + (i+1)*0.012
						get_tree().current_scene.add_child(bullet)
						bullet.color = clColor.YELLOW
						bullet.global_position = gunList[gunIndex].global_position
						bullet.global_position.y += i*16
						bullet.angle = n2RoundDev

		elif n2Timer <= 30:
			movingToCenter = true
		n2Timer -= 1
		
		
	elif currentPhase == Spell_2:
		# Nuclear Fusion
		
		if s2Timer == 0:
			# reset current gun index
			s2Timer = 400
			s2CurrentGunIndex = 0
			
		elif s2Timer % 65 == 0:
			for i in range(0,2):
				var curGun = gunList[(s2CurrentGunIndex + i) % 10]
				# randomize gun's position
				var newGunX = rand_range(-120, 120) + curGun.global_position.x
				var newGunY = rand_range(-80, 140) + curGun.global_position.y
				curGun.global_position = Vector2(newGunX, newGunY)
				curGun.global_position.x = \
					clamp(curGun.global_position.x, 96, 352)
				curGun.global_position.y = \
					clamp(
						curGun.global_position.y, 
						global_position.y, 
						global_position.y + 64
					)
				
				# gun spawns 2 bullets at s2StartXL = position.x - 32,....
				var bullet1 = plBullets[RoundCl].instance()
				var bullet2 = plBullets[RoundCl].instance()
				bullet1.okuuS2L = true
				bullet1.okuuS2 = true
				bullet2.okuuS2 = true
				bullet1.okuuS2LerpFactor = 0.14
				bullet2.okuuS2LerpFactor = 0.14
				get_tree().current_scene.add_child(bullet1)
				get_tree().current_scene.add_child(bullet2)
				bullet1.color = clColor.RED
				bullet2.color = clColor.RED
				bullet1.global_position = curGun.global_position
				bullet1.global_position.x -= s2StartX
				bullet1.global_position.y -= s2StartY
				bullet2.global_position = curGun.global_position
				bullet2.global_position.x += s2StartX
				bullet2.global_position.y -= s2StartY
			
			s2CurrentGunIndex += 1
			
		s2Timer -= 1
	
	
	elif currentPhase == LastSpell:
		# Last Spell
		
		# moves to center of screen
		if lsTimer == 0:
			lsTimer = 160
		
		if not lsAtCenter and not lsMoveToCenter:
			lsMoveToCenter = true
			
		# Initial Sun, only once
		elif lsAtCenter and not lsSunCreated:
			var bullet = plBullets[RoundCl].instance()
			get_tree().current_scene.add_child(bullet)
			bullet.okuuLS = true
			bullet.z_index = -5
			bullet.global_position = lsCenter
			bullet.color = color.RED
			bullet.scaleTo(Vector2(4, 4))
			bullet.updateSpeed(0)
			lsSunCreated = true
		
		# Ring of Rounds going in
		# disappear if they touch center
		elif lsAtCenter and lsSunCreated:
			if lsTimer % 12 == 0:
				var bullet = plBullets[Round].instance()
				get_tree().current_scene.add_child(bullet)
				bullet.okuuLSIn = true
				bullet.okuuLSOut = false
				bullet.z_index = -6
				bullet.global_position = lsLine[1]
				bullet.angle = rad2deg(Vector2.UP.angle_to(lsLine[1] - lsCenter))
				bullet.color = color.RED
				bullet.updateSpeed(24)
			
			# Ring of small Rounds going out
			elif lsTimer % 9 == 0 and lsOutStart:
				var bullet = plBullets[Round].instance()
				get_tree().current_scene.add_child(bullet)
				bullet.okuuLSOut = true
				bullet.okuuLSIn = false
				bullet.z_index = 1
				bullet.global_position = lsCenter
				bullet.angle = lsOutAngle
				bullet.color = color.YELLOW
				bullet.updateSpeed(lsOutSpdDev)
				lsOutAngle += 8
				lsOutSpdDev = rand_range(24,42)
			
			var lineEnd: Vector2 = Vector2(lsCenter.x, lsLineLength).rotated(deg2rad(lsLineAngle))
			lsLine[1] = lineEnd + lsCenter
			lsLineAngle -= 2
		
		lsTimer -= 1
		
func _onOkuuLSStartFreeing():
	lsOutStart = true


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
			dead = true
			drop_items()
			
			#queue_free()
			
			
		elif HP <= maxHP*2/6 and currentPhase == Spell_2:
			#currentPhase = Phase.Spell_1
			movingToCenter = true
			spellCount -= 1
			changingPhase = true
			stateWait = 120
			
			get_tree().current_scene.clearAllBullets()
			
			Signals.emit_signal("bossSpellsChanged", bossName, spellCount)
			Signals.emit_signal("bossPhaseCutin", bossName, LastSpell)
			
		elif HP <= maxHP*3/6 and currentPhase == NonSpell_2:
			#currentPhase = Phase.Spell_1
			movingToCenter = true
			global_position.x = 192
			global_position.y = n2OriginalY
			speed = 0
			angle = 0
			spellCount -= 1
			changingPhase = true
			stateWait = 120
			
			Signals.emit_signal("bossSpellsChanged", bossName, spellCount)
			Signals.emit_signal("bossPhaseCutin", bossName, Spell_2)

		elif HP <= maxHP*4/6 and currentPhase == Spell_1:
			#currentPhase = Phase.Spell_1
			movingToCenter = true
			spellCount -= 1
			changingPhase = true
			stateWait = 120
			
			Signals.emit_signal("bossSpellsChanged", bossName, spellCount)
			Signals.emit_signal("bossPhaseCutin", bossName, NonSpell_2)

		elif HP <= maxHP*5/6 and currentPhase == NonSpell_1:
			#currentPhase = Phase.Spell_1
			movingToCenter = true
			spellCount -= 1
			changingPhase = true
			stateWait = 120
			
			Signals.emit_signal("bossSpellsChanged", bossName, spellCount)
			Signals.emit_signal("bossPhaseCutin", bossName, Spell_1)
