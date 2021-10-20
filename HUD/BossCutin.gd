extends TextureRect

var speed: float = 900
var reachedMidTimer: int = 60
var phaseAfterCutin		# enum Phase
var bossName: String

var plSatoriCutin = load("res://SA Assets/Usable/Bosses/satoriCutin.png")
var plOkuuCutin = load("res://SA Assets/Usable/Bosses/okuuCutin.png")

func init(bossName: String):
	if bossName == "Satori":
		self.bossName = bossName
		texture = plSatoriCutin
	elif bossName == "Okuu":
		self.bossName = bossName
		texture = plOkuuCutin


func _process(delta: float) -> void:
	margin_top += speed * delta
	
	if speed > 90 and reachedMidTimer == 60:		# before reversing, slow down
		speed *= 0.965
	elif speed <= 90 or reachedMidTimer < 60:		# start reversing
		speed *= 1.03
		if reachedMidTimer > 0:
			reachedMidTimer -= 1



func _on_VisibilityNotifier2D_screen_exited() -> void:
	pass


func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.name == "BossDetect":
		Signals.emit_signal("bossPhaseCutinEnd", bossName, phaseAfterCutin)
		queue_free()
