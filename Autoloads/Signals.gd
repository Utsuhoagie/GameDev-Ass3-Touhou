extends Node

signal gameOver()

# Options menu

#signal playerLifeSetup(lives)		# lives: int
#signal playerBombSetup(bombs)		# bombs: int

# Player stats

signal playerPointsChanged(points)	# points: int		ADDITION
signal enemyDie(points)				# points: int		ADDITION

signal playerPowerChanged(power)	# power: float		CURRENT

signal playerLivesChanged(lives)	# lives: int		CURRENT

signal playerBombsChanged(bombs)	# bombs: int		CURRENT

signal playerGraze()				#					ADDITION

signal bombExploded()

# Gameplay

signal cameraStopped(camSpeed)		# camSpeed: float	CURRENT

signal bossEntered(bossName)		# bossName: str 

signal bossHPChanged(HP, maxHP)		# HP, maxHP: int

signal bossSpellsChanged(bossName, newSpells) 	# bossName: String; newSpells: int

signal bossPhaseCutin(bossName, newPhase)		# bossName: String; newPhase: enum Phase

signal bossPhaseCutinEnd(bossName, newPhase)	# bossName: String; newPhase: enum Phase

signal bossDied(bossName)			# bossName: String

# Satori

signal satoriS1Homing(playerPos)	# playerPos: Vector2

# Okuu

signal okuuLSStartFreeing()
