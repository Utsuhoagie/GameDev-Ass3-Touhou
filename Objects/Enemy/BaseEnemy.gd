extends Area2D
class_name Enemy

# Variables
var active: bool = false
var isBoss: bool = false
var bossOnScreen: bool = false
var isRock: bool = false
var HP: int

var moveVec: Vector2 = Vector2.ZERO
export var speed: float = 0.0
export var decel: float = 0.0
export var angle: float = 0.0


enum { SDrop, P_Small, P_Big, Bomb, Life}
var score: int = 0
var drops: Dictionary = {
	SDrop: 0,
	P_Small: 0,
	P_Big: 0,
	Bomb: 0,
	Life: 0
}
var plItem = preload("res://Objects/Enemy/Item.tscn")

# Node refs & timers
onready var animSprite = $AnimSprite
onready var firePos = $FirePos
onready var fireTimer = $FireTimer
var fireInterval: float

# Preloads
enum {Big, Round, RoundCl, Leaf, Laser}
var plBullets: Dictionary = {
	Big: preload("res://Objects/Bullets/Boss/S_big.tscn"),
	Round: preload("res://Objects/Bullets/Boss/S_round.tscn"),
	RoundCl: preload("res://Objects/Bullets/Boss/S_roundCl.tscn"),
	Leaf: preload("res://Objects/Bullets/Boss/S_leaf.tscn"),
	Laser: preload("res://Objects/Bullets/Boss/S_laser.tscn")
}

enum bigColor { RED, BLUE, GREEN, YELLOW }
enum clColor { BLACK, RED, BLUE, GREEN, YELLOW }
enum color { BLACK, RED, PURPLE, PINK, BLUE, LIGHTBLUE, GREEN, YELLOW, ORANGE }

# ============ Functions ======================================

func _ready() -> void:
	add_to_group("damageable")
	animSprite.play()
	
	Signals.connect("cameraStopped", self, "_addCameraSpeed")
	Signals.connect("bombExploded", self, "_onBombExplode")

func _setSpeeds():
	pass
	
func _addCameraSpeed(camSpeed: float):
	if active and not isBoss:
		speed = abs(speed) + 5
		speed -= camSpeed*10
	
	
func _process(delta: float) -> void:
	pass
			

func _physics_process(delta: float) -> void:
	if speed == 0:
		return
	elif 0 < speed and speed < decel*4:
		speed = 0
		return
	#print("Speed of %s = %f" % [self.name, speed])
	moveVec = Vector2(0,speed).rotated(deg2rad(angle))
	position += moveVec * delta
	#position.y += speed * delta
	speed -= decel
	

func reduceHP(damage: int):	# only works for base enemies!!!
	if active:
		if HP <= 0:			# already dead, prevent double bullets!
			return
		
		HP -= damage
		if HP <= 0:
			die()
		
func _onBombExplode():
	if not isBoss:
		die()
	else:
		self.reduceHP(20)		
	
func die():
	if not active: return
	
	Signals.emit_signal("enemyDie", score)
	if isRock:
		animSprite.scale = Vector2(4.0, 4.0)
	animSprite.play("Die")
	active = false
	drop_items()

func drop_items():
	var drop_area: Rect2 = Rect2(position - Vector2(32,32), Vector2(64,64))

	for itemType in drops:
		for i in drops[itemType]:
			var item = plItem.instance()
			item.init(itemType)
			get_tree().current_scene.call_deferred("add_child",item)
			item.global_position = Vector2(
								drop_area.position.x + randi() % 64, 
								drop_area.position.y + randi() % 64)
			

func _on_VisiNoti_screen_entered() -> void:
	pass

func _on_VisiNoti_screen_exited() -> void:
	if not isBoss:
		queue_free()


func _on_BaseEnemy_area_entered(area: Area2D) -> void:
	# activate when enter Camera2D
	if area.name == "MoveDetect":	# start moving enemies, activate NORMAL enemies
		if isBoss:		# boss speed
			speed = 400
			decel = 15
			self.bossOnScreen = true
		else:			# normal speed, also activate
			active = true
			_setSpeeds()
		
	elif area.name == "BossDetect":	# stop camera scroll, activate boss
		if isBoss and self.bossOnScreen:
			#print("%s entered BossDetect | Position: %s" % [self.name, position])
			#active = true
			
			#self.init()
			#print("in Base, bossName = %s" % self.bossName)
#			var signalBossName: String
#			if self.bossName == "BossSatori":
#				signalBossName = "Satori"
#			else:
#				signalBossName = "Okuu"
			Signals.emit_signal("bossEntered", self.bossName)
			#bossOnScreen = true
			
			var mainScene = get_node("/root/MainScene")
			Signals.emit_signal("cameraStopped", mainScene.cameraScrollSpeed)
			mainScene.cameraScrollSpeed = 0
			self.speed = 0
			self.decel = 0
			

func _on_AnimSprite_animation_finished() -> void:
	if animSprite.animation == "Die":
		queue_free()
