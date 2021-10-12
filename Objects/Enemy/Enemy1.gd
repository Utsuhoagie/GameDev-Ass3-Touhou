extends Enemy


func _ready():
	#animSprite.play("Default")
	HP = 20
	speed = 0
	decel = 0
	
	drops = {
		P_Small: 4,
		P_Big: 0,
		Bomb: 0,
		Points: 10
	}
	
	print(drops)
	
	preloadBullet = preload("res://Objects/Bullets/EBullet1.tscn")
	
	fireInterval = 0.3
	fireTimer.start(fireInterval)
	
	

	
func _process(delta: float) -> void:
	pass
	#print(fireTimer.wait_time)
	


func fire():
	for gun in firePos.get_children():
		var bullet = preloadBullet.instance()
		bullet.global_position = gun.global_position
		bullet.angle = 0
		get_tree().current_scene.add_child(bullet)

func _on_FireTimer_timeout() -> void:
	if active:
		fire()
