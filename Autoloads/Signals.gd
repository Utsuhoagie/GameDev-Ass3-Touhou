extends Node

signal lose()


signal playerLivesChanged(lives)	# lives: int

signal playerBombsChanged(lives)	# bombs: int

signal bossPhaseCutin(newPhase)		# newPhase: enum Phase

signal playerGraze()
