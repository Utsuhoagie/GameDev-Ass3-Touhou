extends Area2D
class_name Enemy

# Variables
var active: bool = false
var isBoss: bool = false
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
	
	# Delay damage taken
	if isDamaged and isDamagedTimer > 0:
		isDamagedTimer -= 1
	else:
		isDamaged = false
		isDamagedTimer = 20
		animSprite.animation = "Active"
		


func _physics_process(delta: float) -> void:
	if speed == 0:
		return
	elif speed < decel*4:
		speed = 0
		return
		
	position.y += speed * delta
	speed -= decel
	

func reduceHP(damage: int):	# only works for base enemies!!!
	if active:
		if HP <= 0:			# already dead, prevent double bullets!
			return
		
		isDamaged = true
		animSprite.animation = "Damaged"
		
		HP -= damage
		if HP <= 0:
			HP = 0
			Signals.emit_signal("enemyDie", drops[Points])
			drop_items()
			queue_free()

func drop_items():
	pass

func _on_VisiNoti_screen_entered() -> void:
	pass

func _on_VisiNoti_screen_exited() -> void:
	queue_free()


func _on_BaseEnemy_area_entered(area: Area2D) -> void:
	# activate when enter Camera2D
	if area.name == "MoveDetect":	# start moving enemies, activate NORMAL enemies
		if isBoss:		# boss speed
			speed = 400
			decel = 15
		else:			# normal speed, also activate
			active = true
			speed = 0
			decel = 0
		
	elif area.name == "BossDetect":	# stop camera scroll, activate boss
		if isBoss:
			print("%s entered BossDetect | Position: %s" % [self.name, position])
			active = true
		
			Signals.emit_signal("bossEntered", self.bossName)
			
			var mainScene = get_node("/root/MainScene")
			mainScene.cameraScrollSpeed = 0
			self.speed = 0
			self.decel = 0
