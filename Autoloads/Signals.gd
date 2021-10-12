extends Node

signal lose()

# Player stats

signal playerPowerChanged(power)	# power: float

signal playerLivesChanged(lives)	# lives: int

signal playerBombsChanged(bombs)	# bombs: int

signal playerGraze()

signal enemyDie(points)				# points: int


# Gameplay

signal bossPhaseCutin(newPhase)		# newPhase: enum Phase
