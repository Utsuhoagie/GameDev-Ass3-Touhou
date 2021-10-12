extends KinematicBody2D


# Variables
var life: int = 3
var bomb: int = 2
var power: float = 1.0
var speed: int = 500
var focused: bool = false
var vel := Vector2.ZERO

# Timers, delays, flag
var fireDelay: float = 0.08
var isBombing: bool = false
var dieDelay: float = 1
var invincible: bool = true
var invincibleDelay: float = 1
var flickerTimer: int = 5
var touchHostile: bool = false

# Node refs
onready var animSprite = $AnimSprite
onready var hurtbox = $Hurtbox
onready var firePos = $FirePos

# Timers
onready var timer = $FireTimer
onready var dieTimer = $DieTimer
onready var respawnTimer = $RespawnTimer

# Preload scenes for use
var preloadBullet = preload("res://Objects/Bullets/PBullet.tscn")


# ============= Functions =========================================

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	respawn()
#	animSprite.play("Respawn")
#	respawnTimer.start(invincibleDelay)

func respawn():
	invincible = true
	global_position = Vector2(256,576)
	animSprite.play("Respawn")
	respawnTimer.start(invincibleDelay)
	Signals.emit_signal("playerLivesChanged", life)
	Signals.emit_signal("playerBombsChanged", bomb)

func _on_RespawnTimer_timeout() -> void:
	invincible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(respawnTimer.time_left)
	#print(str(animSprite.animation) + " | " + str(invincible))
	#print(life)
	
	
	
	# Lose
	if life < 0: return		
		
	# Staying in enemy
	if touchHostile and not invincible:
		die()
		touchHostile = false
		return
	
	# Normal processing
	# if not invincible:
	if dieTimer.is_stopped():
		if Input.is_action_pressed("fire") and timer.is_stopped() and not invincible:
			timer.start(fireDelay)
			for gun in firePos.get_children():
				var bullet = preloadBullet.instance()
				bullet.global_position = gun.global_position
				get_tree().current_scene.add_child(bullet)
		
		
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
		
		position.x = clamp(position.x, 32, 352)
		position.y = clamp(position.y, 32, 608)


func _on_HitColArea_area_entered(area: Area2D) -> void:
	if animSprite.animation == "Die":
		return
		
	if area.is_in_group("damageable") or area.is_in_group("eBullet"):
		touchHostile = true

func _on_HitColArea_area_exited(area: Area2D) -> void:
	touchHostile = false


func die():
	life -= 1
	
	if focused:
		hurtbox.play("Hurtbox", true)
		focused = false
	
	Signals.emit_signal("playerLivesChanged", life)
	animSprite.play("Die")
	dieTimer.start(dieDelay)

func _on_DieTimer_timeout() -> void:
	if life >= 0:
		respawn()
	else:
		Signals.emit_signal("lose")
		queue_free()


func _on_GrazeArea_area_entered(area: Area2D) -> void:
	if !dieTimer.is_stopped():
		return
	if (area is Enemy) or (area.is_in_group("eBullet")):
		Signals.emit_signal("playerGraze")
	
