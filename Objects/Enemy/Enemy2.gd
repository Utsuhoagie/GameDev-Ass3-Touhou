extends Enemy

var angle: float = 0.0

func _ready():
	#animSprite.play("Default")
	HP = 40
	speed = 540
	decel = 18
	
	preloadBullet = preload("res://Objects/Bullets/EBullet1.tscn")
	
	fireInterval = 0.3
	fireTimer.start(fireInterval)
	
	

	
func _process(delta: float) -> void:
	pass
	#print(fireTimer.wait_time)
	


func fire():
	randomize()
	for gun in firePos.get_children():
		var bullet = preloadBullet.instance()
		bullet.global_position = gun.global_position
		bullet.angle = angle
		angle += 0
		get_tree().current_scene.add_child(bullet)

func _on_FireTimer_timeout() -> void:
	if active:
		fire()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	pass # Replace with function body.
