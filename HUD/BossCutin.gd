extends TextureRect

var speed: float = 600
var reachedMidTimer: int = 60

func _process(delta: float) -> void:
	margin_top += speed * delta
	#print("%s | speed = %s" % [reachedMidTimer, speed])
	
	if speed > 100 and reachedMidTimer == 60:		# before reversing, slow down
		speed *= 0.98
	elif speed <= 100 or reachedMidTimer < 60:		# start reversing
		speed *= 1.02
		if reachedMidTimer > 0:
			reachedMidTimer -= 1



func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
