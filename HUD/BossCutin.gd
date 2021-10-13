extends TextureRect

var speed: float = 600
var reachedMidTimer: int = 60
var phaseAfterCutin		# enum Phase



func _process(delta: float) -> void:
	margin_top += speed * delta
	#print("%s | speed = %s" % [reachedMidTimer, speed])
	
	if speed > 100 and reachedMidTimer == 60:		# before reversing, slow down
		speed *= 0.98
	elif speed <= 100 or reachedMidTimer < 60:		# start reversing
		speed *= 1.03
		if reachedMidTimer > 0:
			reachedMidTimer -= 1



func _on_VisibilityNotifier2D_screen_exited() -> void:
	pass
#	Signals.emit_signal("bossPhaseCutinEnd", phaseAfterCutin)
#	print("\t Boss cutin End! Position = %s" % rect_global_position)
#
#	queue_free()


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.name == "BossDetect":
		Signals.emit_signal("bossPhaseCutinEnd", phaseAfterCutin)
		print("\t area2D boss cutin End! Position = %s" % rect_global_position)

		queue_free()
