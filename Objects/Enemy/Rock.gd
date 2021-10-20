extends Enemy


func _ready():
	HP = 100
	isRock = true

	score = 100
	drops = {
		SDrop: 5,
		P_Small: 0,
		P_Big: 1,
		Bomb: 1,
		Life: 0
	}
	
func _setSpeeds():
	speed = 0
	decel = 0
	
func _process(delta: float) -> void:
	rotate(deg2rad(0.6))
