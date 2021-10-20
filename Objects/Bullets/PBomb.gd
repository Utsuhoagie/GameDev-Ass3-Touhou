extends Area2D

var centerTop: Vector2 = Vector2.ZERO
var timer: int = 120

enum { RED, PINK, BLUE, TURQUOISE, GREEN, YELLOW, WHITE }
var color

onready var animSprite = $AnimSprite
onready var sfx = $Sfx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animSprite.frame = color

func _process(delta: float) -> void:
	if timer == 0:
		getCenterTop()
		if abs(global_position.y - centerTop.y) >= 10:
			global_position = lerp(global_position, centerTop, 0.06)
		else:
			explode()
	elif timer > 0:
		timer -= 1

func getCenterTop():
	randomize()
	if centerTop == Vector2.ZERO:
		centerTop = $"/root/MainScene/Camera2D".global_position
		centerTop.x -= 128
		centerTop.x += (color - 3) * 24 #rand_range(-64, 64)
		centerTop.y -= 192
		centerTop.y += rand_range(-32, 32)


func explode():
	animSprite.scale = Vector2(3,3)
	animSprite.play("Explode")
	timer = -1
	sfx.play()
	Signals.emit_signal("bombExploded")

func _on_AnimSprite_animation_finished() -> void:
	queue_free()
