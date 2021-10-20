extends Bullet

# For enemy bullets
enum { BLACK, RED, PURPLE, PINK, BLUE, LIGHTBLUE, GREEN, YELLOW, ORANGE }
var color

var satoriS1HomeAlready: bool = false
var satoriS1: bool = false

var okuuLSIn: bool = false
var okuuLSFreeTimer: int = -1
var okuuLSOut: bool = false

onready var sfxPlayer = $Sound
var normalSfx = preload("res://SA Assets/Usable/Sound/se_tan00.wav")
var scatterSfx = preload("res://SA Assets/Usable/Sound/se_kira00.wav")

func _ready():
	type = "round"
	
	ySpeed = 300
	
	# angle set from Enemy

	add_to_group("eBullet")
	
	Signals.connect("satoriS1Homing", self, "_onSatoriS1Homing")
	
	sfxPlayer.set_stream(normalSfx)
	sfxPlayer.play()
	
	
func _process(delta: float) -> void:
	
#	if not homeAlready:
#		vel = Vector2(0, ySpeed)
#		vel = vel.rotated(deg2rad(angle))
	
	if okuuLSFreeTimer > 0:
		okuuLSFreeTimer -= 1
	elif okuuLSFreeTimer == 0:
		Signals.emit_signal("okuuLSStartFreeing")
		call_deferred("queue_free")
	
	if color != null:
		animSprite.frame = color

func _physics_process(delta: float) -> void:
	position += vel * delta


func _onSatoriS1Homing(playerPos: Vector2, delta: float):
	if satoriS1HomeAlready or not satoriS1: return
	
	satoriS1HomeAlready = true
	vel = vel*9
	var dir: Vector2 = playerPos - global_position
	vel = vel.rotated(vel.angle_to(dir.normalized()))
	
	sfxPlayer.set_stream(scatterSfx)
	sfxPlayer.play()

func freeAfterDelay():
	okuuLSFreeTimer = 60
