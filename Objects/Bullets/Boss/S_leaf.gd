extends Bullet

# For enemy bullets
enum { BLACK, RED, PURPLE, PINK, BLUE, LIGHTBLUE, GREEN, YELLOW, ORANGE }
var color

var isNormal: bool = false

onready var sfxPlayer = $Sound
var scatterSfx = preload("res://SA Assets/Usable/Sound/se_kira00.wav")


func _ready():
	type = "leaf"
	
	ySpeed = 270
	
	# angle set from Enemy
	
	vel = Vector2(0, ySpeed)
	vel = vel.rotated(deg2rad(angle))
	rotate(deg2rad(angle))

	add_to_group("eBullet")
	
	sfxPlayer.set_stream(scatterSfx)
	if isNormal:
		sfxPlayer.volume_db += 12
	sfxPlayer.play()
	
	
func _process(delta: float) -> void:
	if color != null:
		animSprite.frame = color

func _physics_process(delta: float) -> void:
	position += vel * delta
