extends Enemy


func _ready():
	#animSprite.play("Default")
	HP = 40
	speed = 540
	decel = 18
	
	preloadBullet = preload("res://Objects/Bullets/EBullet1.tscn")
	
	fireInterval = 0.1
	fireTimer.start(fireInterval)
	
	

	
func _process(delta: float) -> void:
	pass
	#print(fireTimer.wait_time)
	


func fire():
	randomize()
	for gun in firePos.get_children():
		var bullet = preloadBullet.instance()
		bullet.global_position = gun.global_position
		bullet.angle = rand_range(-45.0, 45.0)
		get_tree().current_scene.add_child(bullet)

func _on_FireTimer_timeout() -> void:
	fire()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	pass # Replace with function body.
