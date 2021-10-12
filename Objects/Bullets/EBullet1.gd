extends Bullet


func _ready():
	ySpeed = 600
	
	# angle set from Enemy
	
	vel = Vector2(0, ySpeed)
	vel = vel.rotated(deg2rad(angle))

	add_to_group("eBullet")
	

func _physics_process(delta: float) -> void:
	position += vel * delta
