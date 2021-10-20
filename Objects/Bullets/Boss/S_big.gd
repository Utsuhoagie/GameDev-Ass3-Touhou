extends Bullet

onready var sfxPlayer = $Sound
onready var sfxPlayer2 = $Sound2
var normalSfx = preload("res://SA Assets/Usable/Sound/se_tan00.wav")
var scatterSfx = preload("res://SA Assets/Usable/Sound/se_kira00.wav")

# For enemy bullets
enum { RED, BLUE, GREEN, YELLOW }
var color


# Boss bullets
var okuuN1: bool = false
var okuuN1Timer: int = 60

var okuuN2: bool = false

func _ready():
	type = "big"
	
	ySpeed = 180
	
	# angle set from Enemy
	
	vel = Vector2(0, ySpeed)
	vel = vel.rotated(deg2rad(angle))

	add_to_group("eBullet")
	
	if okuuN2:
		sfxPlayer2.set_stream(normalSfx)
		sfxPlayer2.play()
	else:
		sfxPlayer.set_stream(normalSfx)
		sfxPlayer.play()
	
	

func _process(delta: float) -> void:
	if color != null:
		animSprite.frame = color
		
	if okuuN1:
		if okuuN1Timer == 0:
			updateSpeed(480)
			okuuN1 = false
			sfxPlayer.set_stream(scatterSfx)
			sfxPlayer.play()
		else:
			okuuN1Timer -= 1
			

func _physics_process(delta: float) -> void:
	position += vel * delta
