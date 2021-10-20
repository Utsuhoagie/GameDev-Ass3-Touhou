extends KinematicBody2D


# Variables
var life: int					# taken from GlobalVar
var bomb: int					# taken from GlobalVar
var power: float = 1.0
var speed: int = 400
var focused: bool = false
var vel := Vector2.ZERO
var angleFocused: float = 2.8

enum { RED, PINK, BLUE, TURQUOISE, GREEN, YELLOW, WHITE }
enum { SDrop, P_Small, P_Big, Bomb, Life}

# Timers, delays, flag
var fireDelay: float = 0.08

var isBombing: bool = false
var bombOffset: float = 64
var bombAngle: float = 0
var playerCenter: Vector2 = Vector2(global_position.x, global_position.y)
var bombLineEnd: Vector2 = Vector2(global_position.x, global_position.y - bombOffset)
var bombMoveTimer: int = 120
var bombTimer: int = 300

var dieDelay: float = 1
var invincible: bool = false
var invincibleDelay: float = 1
var flickerTimer: int = 5
var touchHostile: bool = false


# Node refs
onready var animSprite = $AnimSprite
onready var hurtbox = $Hurtbox
onready var firePos = $FirePos
onready var bombPos = $BombPos
onready var camera = get_node("/root/MainScene/Camera2D")

# Sound effects
onready var sfxFireDie = $SfxFireDie
onready var sfxItem = $SfxItem
var playerDie = load("res://SA Assets/Usable/Sound/se_pldead00.wav")
var playerFire = load("res://SA Assets/Usable/Sound/se_plst00.wav")

# Timers
onready var timer = $FireTimer
onready var dieTimer = $DieTimer
onready var respawnTimer = $RespawnTimer

# Preload scenes for use
var plBullet1 = preload("res://Objects/Bullets/PBullet.tscn")
var plBullet2 = preload("res://Objects/Bullets/PBullet2.tscn")
var plOption = load("res://SA Assets/Usable/Player/Option.png")
var plBomb = preload("res://Objects/Bullets/PBomb.tscn")

# ============= Functions =========================================

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	Signals.connect("playerLifeSetup", self, "_setupLives")
#	Signals.connect("playerBombSetup", self, "_setupBombs")
	self.life = GlobalVar.life
	self.bomb = GlobalVar.bomb
	Signals.emit_signal("playerLivesChanged", life)
	Signals.emit_signal("playerBombsChanged", bomb)
	
	Signals.connect("playerPowerChanged", self, "changeOptions")
	
	Signals.emit_signal("playerPowerChanged", power)
	

func respawn():
	invincible = true
	animSprite.play("Respawn")
	respawnTimer.start(invincibleDelay)
	
	Signals.emit_signal("playerPowerChanged", power)
	Signals.emit_signal("playerLivesChanged", life)
	Signals.emit_signal("playerBombsChanged", bomb)


func _on_RespawnTimer_timeout() -> void:
	invincible = false

func die():
	sfxFireDie.set_stream(playerDie)
	sfxFireDie.play()
	
	life -= 1
	power -= 1.0
	power = clamp(power, 1.0, 4.0)
	
	if focused:
		hurtbox.play("Hurtbox", true)
		focused = false
	
	for option in firePos.get_children():
		if option.name != "Base1" and option.name != "Base2":
			option.queue_free()
	
	Signals.emit_signal("playerPowerChanged", power)
	Signals.emit_signal("playerLivesChanged", life)
	
	animSprite.play("Die")
	dieTimer.start(dieDelay)

func changeOptions(P: float):
	for gun in firePos.get_children():
		if gun.name != "Base1" and gun.name != "Base2":
			gun.queue_free()
		
	if life < 0:
		return
		
	if (1 <= P) and (P < 2):
		var gun1 = Sprite.new()
		gun1.position = Vector2(0, -44)		# RELATIVE position to firePos
		gun1.texture = plOption
		firePos.add_child(gun1)
		
	elif (2 <= P) and (P < 3):
		var gun1 = Sprite.new()
		var gun2 = Sprite.new()
		gun1.position = Vector2(12, -44)
		gun2.position = Vector2(-12, -44)
		gun1.texture = plOption
		gun2.texture = plOption
		firePos.add_child(gun1)
		firePos.add_child(gun2)
		
	elif (3 <= P) and (P < 4):
		var gun1 = Sprite.new()
		var gun2 = Sprite.new()
		var gun3 = Sprite.new()
		gun1.position = Vector2(0, -44)
		gun2.position = Vector2(28, 0)
		gun3.position = Vector2(-28, 0)
		gun1.texture = plOption
		gun2.texture = plOption
		gun3.texture = plOption
		firePos.add_child(gun1)
		firePos.add_child(gun2)
		firePos.add_child(gun3)
	
	elif is_equal_approx(P, 4.0):
		var gun1 = Sprite.new()
		var gun2 = Sprite.new()
		var gun3 = Sprite.new()
		var gun4 = Sprite.new()
		gun1.position = Vector2(12, -44)
		gun2.position = Vector2(-12, -44)
		gun3.position = Vector2(32, 0)
		gun4.position = Vector2(-32, 0)
		gun1.texture = plOption
		gun2.texture = plOption
		gun3.texture = plOption
		gun4.texture = plOption
		firePos.add_child(gun1)
		firePos.add_child(gun2)
		firePos.add_child(gun3)
		firePos.add_child(gun4)
		
func fire():
	
	var optionCount: int = firePos.get_child_count()
	var options = firePos.get_children()
	
	for i in range(0,2):
		var bullet = plBullet1.instance()
		bullet.global_position = options[i].global_position
		bullet.angle = 0
		get_tree().current_scene.add_child(bullet)
	
	for i in range(2, optionCount):				# each bullet
		var bullet = plBullet2.instance()
		bullet.global_position = options[i].global_position
		
		if optionCount == 3:		# 1 extra option
			bullet.angle = 0
		elif optionCount == 4:		# 2 extra options, 2 diagonal
			if i == 2:
				bullet.angle = 0.3 if focused else angleFocused*5
			elif i == 3:
				bullet.angle = -0.3 if focused else -angleFocused*5
		elif optionCount == 5:
			if i == 2:
				bullet.angle = 0
			elif i == 3:
				bullet.angle = 0.05 if focused else angleFocused*5
			elif i == 4:
				bullet.angle = -0.05 if focused else -angleFocused*5
		elif optionCount == 6:
			if i == 2 or i == 3:
				bullet.angle = 0
			elif i == 4:
				bullet.angle = 0 if focused else angleFocused*5
			elif i == 5:
				bullet.angle = 0 if focused else -angleFocused*5

		get_tree().current_scene.add_child(bullet)


func bomb():
	bomb -= 1
	Signals.emit_signal("playerBombsChanged", bomb)
	isBombing = true
	
	var bombSpawner = bombPos.get_children()
	
	for i in range(0,7):
		var bomb = plBomb.instance()
		bomb.color = i
		bombPos.add_child(bomb)
		bomb.global_position = bombSpawner[i].global_position
	
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Lose, don't process anything else
	if life < 0: 
		changeOptions(power)
		return		
	
	if isBombing:
		bombTimer -= 1
		
		if bombTimer == 0:
			isBombing = false
			bombTimer = 300

		elif bombTimer > 180:
			bombPos.rotation_degrees += 2
		
		elif bombTimer == 180:
			var bombs = bombPos.get_children()
			
			for i in range(7,14):
				var externalBomb = bombPos.get_child(i).duplicate()
				externalBomb.color = bombPos.get_child(i).color
				externalBomb.global_position = bombPos.get_child(i).global_position
				externalBomb.centerTop = bombPos.get_child(i).centerTop
				externalBomb.timer = bombPos.get_child(i).timer
				get_tree().current_scene.add_child(externalBomb)
			
			while bombPos.get_child_count() > 7:
				bombPos.remove_child(bombPos.get_child(7))
	
	
	# Staying in enemy
	if touchHostile and not invincible and animSprite.animation != "Die":
		die()
		return
	
	# Normal processing
	if not dieTimer.is_stopped():
		for option in firePos.get_children():
			option.visible = false
	else:
		for option in firePos.get_children():
			option.visible = true
			option.rotate(deg2rad(4))
		
		if Input.is_action_pressed("fire") and timer.is_stopped() and not invincible:
			sfxFireDie.set_stream(playerFire)
			sfxFireDie.play()
			timer.start(fireDelay)
			fire()
		
		if Input.is_action_just_pressed("bomb") and (life >= 0 and bomb > 0
												and !invincible and !isBombing):
			bomb()
		
		if Input.is_action_pressed("focus"):
			hurtbox.play("Hurtbox")
			focused = true				
		if Input.is_action_just_released("focus"):
			hurtbox.play("Hurtbox", true)
			focused = false
		

		if vel.x < 0:
			animSprite.play("Left")
		if vel.x > 0:
			animSprite.play("Right")
		if vel.x == 0:
			animSprite.play("Straight")
		if invincible:
			flickerTimer -= 1
			if flickerTimer == 0:
				animSprite.visible = !animSprite.visible
				flickerTimer = 5
		else:
			animSprite.visible = true
			flickerTimer = 5
		
		
func _physics_process(delta: float) -> void:
	if dieTimer.is_stopped() and life >= 0:
		vel = Vector2.ZERO
		var dir = Vector2.ZERO
		var currentSpeed = speed
		
		if focused:
			currentSpeed *= 0.4
		
		if Input.is_action_pressed("moveL"):
			dir.x = -1
		if Input.is_action_pressed("moveR"):
			dir.x = 1
		if Input.is_action_pressed("moveU"):
			dir.y = -1
		if Input.is_action_pressed("moveD"):
			dir.y = 1

		vel = dir.normalized() * currentSpeed
		vel = move_and_slide(vel)
		
		# Clamp in current camera's position
		position.x = clamp(position.x, 32, 352)
		position.y = clamp(position.y, camera.position.y - 288, camera.position.y + 288)


# -------- Signals -------------------------------------------

func _on_HitColArea_area_entered(area: Area2D) -> void:
	if animSprite.animation == "Die":
		return
		
	if area.is_in_group("damageable") or area.is_in_group("eBullet"):
		if not isBombing:
			touchHostile = true

func _on_HitColArea_area_exited(area: Area2D) -> void:
	touchHostile = false

func _on_DieTimer_timeout() -> void:
	if life >= 0:
		respawn()
	else:
		Signals.emit_signal("gameOver")
		


func _on_GrazeArea_area_entered(area: Area2D) -> void:
	if !dieTimer.is_stopped() or life < 0:
		return
	if (area is Enemy) or (area.is_in_group("eBullet")):
		Signals.emit_signal("playerPointsChanged", 10)
		Signals.emit_signal("playerGraze")
	elif area is Item:
		match area.type:
			SDrop:
				Signals.emit_signal("playerPointsChanged", area.value[SDrop])
			P_Small:
				power += area.value[P_Small]
				power = clamp(power, 1.0, 4.0)
				Signals.emit_signal("playerPowerChanged", power)
			P_Big:
				power += area.value[P_Big]
				power = clamp(power, 1.0, 4.0)
				Signals.emit_signal("playerPowerChanged", power)				
			Bomb:
				bomb += area.value[Bomb]
				bomb = clamp(bomb, 1, 5)
				Signals.emit_signal("playerBombsChanged", bomb)
			Life:
				life += area.value[Life]
				life = clamp(life, 1, 5)
				Signals.emit_signal("playerLivesChanged", life)
		
		sfxItem.play()
		area.queue_free()
