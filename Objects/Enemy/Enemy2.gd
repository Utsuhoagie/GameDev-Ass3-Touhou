extends Enemy

var fireAngle: float = 0.0

func _ready():
	#animSprite.play("Default")
	HP = 60
	
	
	score = 100
	drops = {
		SDrop: 5,
		P_Small: 3,
		P_Big: 0,
		Bomb: 0,
		Life: 0
	}
	
	
	fireInterval = 0.4
	fireTimer.start(fireInterval)
	
func _setSpeeds():
	randomize()
	speed = 5
	decel = 0
	angle = rand_range(-30,30)
	

	
func _process(delta: float) -> void:
	pass
	


func fire():
	randomize()
	for gun in firePos.get_children():
		var bullet = plBullets[Leaf].instance()
		bullet.color = randi() % 9
		bullet.isNormal = true
		bullet.global_position = gun.global_position
		fireAngle = rand_range(-50,50)
		bullet.angle = fireAngle
		bullet.updateSpeed(80)
		get_tree().current_scene.add_child(bullet)

func _on_FireTimer_timeout() -> void:
	if active:
		fire()
