extends Area2D
class_name Bullet

# Variables
var ySpeed: int = 0
var vel: Vector2
var angle: float

# Node refs
onready var animSprite = $AnimSprite
onready var visiNoti = $VisiNoti

# ========== Functions ============================

func _ready():
	#animSprite.play("Active")
	if !visiNoti.is_connected("screen_exited", self, "_on_VisiNoti_screen_exited"):
		visiNoti.connect("screen_exited", self, "_on_VisiNoti_screen_exited")

func _physics_process(delta: float) -> void:
	#position += vel * delta
	pass

# Exit screen
func _on_VisiNoti_screen_exited() -> void:
	queue_free()
