extends Bullet

# For enemy bullets
enum { BLACK, RED, BLUE, GREEN, YELLOW }
enum roundColor { BLACK, RED, PURPLE, PINK, BLUE, LIGHTBLUE, GREEN, YELLOW, ORANGE }
var color

var isScaling: bool = false
var scaledX: float
var scaledVec: Vector2

var okuuN2: bool = false
var okuuN2LerpFactor: float

var okuuS2: bool = false
var okuuS2L: bool = false
var okuuS2Fused: bool = false
var okuuS2LerpFactor: float
var plElectron = preload("res://Objects/Bullets/Boss/S_round.tscn")
var colShape

var okuuLS: bool = false

onready var sfxPlayer = $Sound
var normalSfx = preload("res://SA Assets/Usable/Sound/se_tan00.wav")

func _ready():
	type = "roundCl"
	
	ySpeed = 36
	$ColShape.shape = $ColShape.shape.duplicate()
	colShape = $ColShape
	animSprite = $AnimSprite
	
	# angle set from Enemy

	add_to_group("eBullet")
	
	sfxPlayer.set_stream(normalSfx)
	if okuuN2:
		sfxPlayer.volume_db -= 15
	elif okuuS2:
		sfxPlayer.volume_db -= 12
	sfxPlayer.play()
	
	
func _process(delta: float) -> void:
	vel = Vector2(0, ySpeed)
	vel = vel.rotated(deg2rad(angle))
		
	if okuuS2Fused and not okuuS2L:
		color = BLACK
	
	if okuuN2:
		if ySpeed <= 680:
			ySpeed = lerp(ySpeed, 680, okuuN2LerpFactor)
			updateSpeed(ySpeed)
	elif okuuS2 and not okuuS2Fused:
		angle = -60 if okuuS2L else 60
		ySpeed = lerp(ySpeed, 720, okuuS2LerpFactor)
		updateSpeed(ySpeed)
	
	if color != null:
		animSprite.frame = color
	if isScaling:
		animSprite.scale = lerp(animSprite.scale, scaledVec, 0.03)
		colShape.shape.radius = lerp(colShape.shape.radius, scaledX * 0.75/2 , 0.03)
		
		if abs(animSprite.scale.x - scaledVec.x) <= 0.05 and abs(colShape.shape.radius - scaledX * 0.75/2) <= 0.05:
			isScaling = false
			

func scaleTo(scale: Vector2):
	isScaling = true
	scaledVec = scale
	scaledX = $AnimSprite.get_sprite_frames().get_frame("Default",1).get_size().x * scale.x


func _physics_process(delta: float) -> void:
	position += vel * delta


func _on_S_roundCl_area_entered(area: Area2D) -> void:
	if not area.is_in_group("eBullet") or (area.type != "roundCl" and area.type != "round"):
		return
	
	if area.type == "roundCl":
		if okuuS2 and area.okuuS2 and not okuuS2Fused and not area.okuuS2Fused:
			okuuS2Fused = true
			angle = 0
			updateSpeed(ySpeed*0.3)
			area.okuuS2Fused = true
			area.angle = 0
			area.updateSpeed(area.ySpeed*0.3)
			
			var electron = plElectron.instance()
			electron.color = roundColor.YELLOW
			electron.position = Vector2((global_position.x + area.global_position.x)/2, global_position.y + 20)
			get_tree().current_scene.call_deferred("add_child", electron)
			electron.updateSpeed(510)
			
	elif area.type == "round" and okuuLS and area.okuuLSIn and not area.okuuLSOut:
		area.freeAfterDelay()
