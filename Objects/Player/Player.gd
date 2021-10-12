extends KinematicBody2D


# Variables
var life: int = 3
var bomb: int = 2
var power: float = 4.0
var speed: int = 500
var focused: bool = false
var vel := Vector2.ZERO
var angleFocused: float = 2.8

# DEBUG
var printTimer: int = 90
var preload_debugCrosshair = preload("res://DEBUGCROSSHAIR.tscn")

# Timers, delays, flag
var fireDelay: float = 0.08
var isBombing: bool = false
var dieDelay: float = 1
var invincible: bool = false
var invincibleDelay: float = 1
var flickerTimer: int = 5
var touchHostile: bool = false

# Node refs
onready var animSprite = $AnimSprite
onready var hurtbox = $Hurtbox
onready var firePos = $FirePos
onready var camera = get_node("/root/MainScene/Camera2D")

# Timers
onready var timer = $FireTimer
onready var dieTimer = $DieTimer
onready var respawnTimer = $RespawnTimer

# Preload scenes for use
var preloadBullet = preload("res://Objects/Bullets/PBullet.tscn")


# ============= Functions =========================================

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("playerPowerChanged", self, "changeOptions")
	
	Signals.emit_signal("playerPowerChanged", power)
	Signals.emit_signal("playerLivesChanged", life)
	Signals.emit_signal("playerBombsChanged", bomb)
#	animSprite.play("Respawn")
#	respawnTimer.start(invincibleDelay)


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
	life -= 1
	power -= 1
	power = clamp(power, 1.0, 4.0)
	
	if focused:
		hurtbox.play("Hurtbox", true)
		focused = false
	
	Signals.emit_signal("playerPowerChanged", power)
	Signals.emit_signal("playerLivesChanged", life)
	
	animSprite.play("Die")
	dieTimer.start(dieDelay)

func changeOptions(P: float):
	for gun in firePos.get_children():
		gun.queue_free()
		
	if (1 <= P) and (P < 2):
		var gun1 = Node2D.new()
		gun1.position = Vector2(0, 32)		# RELATIVE position to firePos
		firePos.add_child(gun1)
		
	elif (2 <= P) and (P < 3):
		var gun1 = Node2D.new()
		var gun2 = Node2D.new()
		gun1.position = Vector2(-16, 32)
		gun2.position = Vector2(16, 32)
		firePos.add_child(gun1)
		firePos.add_child(gun2)
		
	elif (3 <= P) and (P < 4):
		var gun1 = Node2D.new()
		var gun2 = Node2D.new()
		var gun3 = Node2D.new()
		gun1.position = Vector2(0, 32)
		gun2.position = Vector2(8, 24)
		gun3.position = Vector2(-8, 24)
		firePos.add_child(gun1)
		firePos.add_child(gun2)
		firePos.add_child(gun3)
	
	elif is_equal_approx(P, 4.0):
		var gun1 = Node2D.new()
		var gun2 = Node2D.new()
		var gun3 = Node2D.new()
		var gun4 = Node2D.new()
		gun1.position = Vector2(8, 32)
		gun2.position = Vector2(-8, 32)
		gun3.position = Vector2(10, 24)
		gun4.position = Vector2(-10, 24)
		firePos.add_child(gun1)
		firePos.add_child(gun2)
		firePos.add_child(gun3)
		firePos.add_child(gun4)
		
func fire():
	var optionCount: int = firePos.get_child_count()
	var options = firePos.get_children()
	
	
	for i in range(0, optionCount):				# each bullet
		var bullet = preloadBullet.instance()
		bullet.global_position = options[i].global_position
		if optionCount <= 2 or i < optionCount/2:
			bullet.angle = 0
		else:
			if i == optionCount/2:
				bullet.angle = angleFocused if focused else angleFocused*5
			else:
				bullet.angle = -angleFocused if focused else -angleFocused*5
		get_tree().current_scene.add_child(bullet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	printTimer -= 1
#	if printTimer == 0:
#		print("Ship pos = %s" % position)
#		for gun in firePos.get_children():
#			print("\t Gun pos = %s" % gun.position)
	
	#print(respawnTimer.time_left)
	#print(str(animSprite.animation) + " | " + str(invincible))
	#print(life)
	
	# Lose
	if life < 0: return		
		
	# Staying in enemy
	if touchHostile and not invincible and animSprite.animation != "Die":
		die()
		return
	
	# Normal processing
	if dieTimer.is_stopped():
		if Input.is_action_pressed("fire") and timer.is_stopped() and not invincible:
			timer.start(fireDelay)
			fire()
		
		
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
	if dieTimer.is_stopped():
		vel = Vector2.ZERO	
		var currentSpeed = speed
		
		if focused:
			currentSpeed /= 2
		
		if Input.is_action_pressed("moveL"):
			vel.x -= currentSpeed
		if Input.is_action_pressed("moveR"):
			vel.x += currentSpeed	
		if Input.is_action_pressed("moveU"):
			vel.y -= currentSpeed
		if Input.is_action_pressed("moveD"):
			vel.y += currentSpeed

		vel = move_and_slide(vel)
		
		# Clamp in current camera's position
		position.x = clamp(position.x, 32, 352)
		position.y = clamp(position.y, camera.position.y - 288, camera.position.y + 288)


# -------- Signals -------------------------------------------

func _on_HitColArea_area_entered(area: Area2D) -> void:
	if animSprite.animation == "Die":
		return
		
	if area.is_in_group("damageable") or area.is_in_group("eBullet"):
		touchHostile = true

func _on_HitColArea_area_exited(area: Area2D) -> void:
	touchHostile = false

func _on_DieTimer_timeout() -> void:
	if life >= 0:
		respawn()
	else:
		Signals.emit_signal("lose")
		


func _on_GrazeArea_area_entered(area: Area2D) -> void:
	if !dieTimer.is_stopped():
		return
	if (area is Enemy) or (area.is_in_group("eBullet")):
		Signals.emit_signal("playerGraze")
	
