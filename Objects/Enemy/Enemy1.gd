extends Enemy



func _ready():
	HP = 30

	
	score = 20
	drops = {
		SDrop: 3,
		P_Small: 1,
		P_Big: 0,
		Bomb: 0,
		Life: 0
	}
	
	
	fireInterval = 0.9
	fireTimer.start(fireInterval)
	
func _setSpeeds():
	randomize()
	speed = rand_range(10,25)
	decel = 0
	angle = rand_range(10,30) * (1 if randi() % 2 == 0 else -1)
	

func _process(delta: float) -> void:
	pass
	


func fire():
	for gun in firePos.get_children():
		var bullet = plBullets[Round].instance()
		bullet.color = color.BLUE if randi() % 2 == 0 else color.PINK
		bullet.global_position = gun.global_position
		bullet.angle = 0
		bullet.updateSpeed(144)
		get_tree().current_scene.add_child(bullet)

func _on_FireTimer_timeout() -> void:
	if active and HP > 0:
		fire()
