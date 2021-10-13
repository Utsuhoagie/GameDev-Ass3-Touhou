extends Node

signal lose()

# Player stats

signal playerPowerChanged(power)	# power: float

signal playerLivesChanged(lives)	# lives: int

signal playerBombsChanged(bombs)	# bombs: int

signal playerGraze()

signal enemyDie(points)				# points: int


# Gameplay

signal bossEntered(bossName)		# bossName: str 

signal bossHPChanged(HP, maxHP)		# HP, maxHP: int

signal bossSpellsChanged(newSpells) # newSpells: int

signal bossPhaseCutin(newPhase)		# newPhase: enum Phase

signal bossPhaseCutinEnd(newPhase)	# newPhase: enum Phase

signal bossDied(points)				# points: int
