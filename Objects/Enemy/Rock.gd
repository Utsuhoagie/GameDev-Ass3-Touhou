extends Enemy



func _ready():
	#animSprite.play("Default")
	HP = 150
	speed = 0
	decel = 0
	
	drops = {
		P_Small: 4,
		P_Big: 1,
		Bomb: 1,
		Points: 100
	}
	

	
func _process(delta: float) -> void:
	pass
	#print(fireTimer.wait_time)
