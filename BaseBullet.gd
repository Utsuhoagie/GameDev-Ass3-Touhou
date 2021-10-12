extends Area2D
class_name Bullet

# Variables
var ySpeed: int
var vel: Vector2
var angle: float

# Node refs
onready var animSprite = $AnimSprite
onready var visiNoti = $VisiNoti

# ========== Functions ============================

func _ready():
	#animSprite.play("Active")
	visiNoti.connect("screen_exited", self, "_on_VisiNoti_screen_exited")

func _physics_process(delta: float) -> void:
	#position += vel * delta
	pass

# Exit screen
func _on_VisiNoti_screen_exited() -> void:
	queue_free()
