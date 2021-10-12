extends Node2D

var power: float = 0.5

func _process(delta: float) -> void:
	power = clamp(power, 1.0, 4.0)
	print("%.1f" % power)
