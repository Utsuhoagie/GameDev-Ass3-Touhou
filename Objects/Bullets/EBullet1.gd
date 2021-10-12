extends Bullet


func _ready():
	add_to_group("eBullet")
	
	ySpeed = 600
	
	# angle set from Enemy
	
	vel = Vector2(0, ySpeed)
	vel = vel.rotated(deg2rad(angle))

func _physics_process(delta: float) -> void:
	position += vel * delta
