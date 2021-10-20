extends Area2D
class_name Bullet

# Variables
var ySpeed: int = 0
var vel: Vector2
var angle: float

var type: String

# Node refs
onready var animSprite = $AnimSprite
onready var visiNoti = $VisiNoti



# Enemy bullet sound


#var scatterSfx = preload("res://SA Assets/Usable/Sound/se_kira00.wav")
#var laserSfx = preload("res://SA Assets/Usable/Sound/se_lazer00.wav")

# ========== Functions ============================

func _ready():
	#animSprite.play("Active")
	self.connect("area_exited", self, "_on_BaseBullet_area_exited")
	
	if !visiNoti.is_connected("screen_exited", self, "_on_VisiNoti_screen_exited"):
		visiNoti.connect("screen_exited", self, "_on_VisiNoti_screen_exited")



func _process(delta: float):
	pass
	
func updateSpeed(_ySpeed: float):
	ySpeed = _ySpeed
	vel = Vector2(0, ySpeed)
	vel = vel.rotated(deg2rad(angle))

func _physics_process(delta: float) -> void:
	#position += vel * delta
	pass

# Exit screen
func _on_VisiNoti_screen_exited() -> void:
	queue_free()


func _on_BaseBullet_area_exited(area: Area2D) -> void:
	if area.name == "PlayArea":
		queue_free()
