extends Bullet


func _ready():
	ySpeed = -1000
	
	# Angle set from Player
	
	vel = Vector2(0, ySpeed)
	vel = vel.rotated(deg2rad(angle))
	animSprite.rotate(deg2rad(angle))

func _physics_process(delta: float) -> void:
	position += vel * delta


func _on_Bullet_area_entered(area: Area2D) -> void:
	if area.is_in_group("damageable"):
		area.reduceHP(1)
		queue_free()
