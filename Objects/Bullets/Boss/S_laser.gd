extends Bullet

# For enemy bullets
enum { BLACK, RED, PURPLE, PINK, BLUE, LIGHTBLUE, GREEN, YELLOW, ORANGE }
var color

onready var sfxPlayer = $Sound
var laserSfx = preload("res://SA Assets/Usable/Sound/se_lazer00.wav")


func _ready():
	type = "laser"
	
	ySpeed = 270
	
	# angle set from Enemy
	
	vel = Vector2(0, ySpeed)
	vel = vel.rotated(deg2rad(angle))

	add_to_group("eBullet")
	
	sfxPlayer.set_stream(laserSfx)
	sfxPlayer.play()
	
	
func _process(delta: float) -> void:
	if color != null:
		animSprite.frame = color
	if animSprite.scale.y < 8:
		animSprite.scale.y += 0.4

func _physics_process(delta: float) -> void:
	position += vel * delta
