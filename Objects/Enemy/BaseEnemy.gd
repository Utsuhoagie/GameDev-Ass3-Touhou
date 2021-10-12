extends Area2D
class_name Enemy

# Variables
var HP: int
var speed: float
var decel: float
var isDamaged: bool = false
var isDamagedTimer: int = 20

enum { P_Small, P_Big, Bomb, Points }
var drops: Dictionary = {
	P_Small: 0,
	P_Big: 0,
	Bomb: 0,
	Points: 0
}

# Node refs & timers
onready var animSprite = $AnimSprite
onready var firePos = $FirePos
onready var fireTimer = $FireTimer
var fireInterval: float

# Preloads
var preloadBullet



# ============ Functions ======================================

func _ready() -> void:
	add_to_group("damageable")
	animSprite.play("Active")

func _process(delta: float) -> void:
	if isDamaged and isDamagedTimer > 0:
		isDamagedTimer -= 1
	else:
		isDamaged = false
		isDamagedTimer = 20
		animSprite.animation = "Active"
		


func _physics_process(delta: float) -> void:
	position.y += speed * delta
	speed -= decel
	if speed < decel:
		speed = 0
		return

func reduceHP(damage: int):
	isDamaged = true
	animSprite.animation = "Damaged"
	HP -= damage
	if HP <= 0:
		HP = 0
		queue_free()


func _on_VisiNoti_screen_exited() -> void:
	queue_free()
