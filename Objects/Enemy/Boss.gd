extends Enemy
class_name Boss

var maxHP: int
var inited: bool = false
var dead: bool = false
export var bossName: String
onready var bDieExplosion = $BossDieExplode

# Boss phase names
enum { NonSpell_1, Spell_1, NonSpell_2, Spell_2, LastSpell }

var spellCount: int
var movingToCenter: bool = false
var currentPhase	# is an enum
var changingPhase: bool = false
onready var phases = {
	NonSpell_1: $Attacks/Non1,
	Spell_1: $Attacks/Spell1,
	NonSpell_2: $Attacks/Non2,
	Spell_2: $Attacks/Spell2,
	LastSpell: $Attacks/LastSpell
}

onready var player = get_node("/root/MainScene/Player")


func _ready():	
	# Basic boss stats
	isBoss = true
	speed = 0
	decel = 0
	
	Signals.connect("bossEntered", self, "_onBossEntered")
	
	
func init():
	inited = true

	# Signals
	Signals.emit_signal("bossHPChanged", HP, maxHP)
	Signals.emit_signal("bossSpellsChanged", bossName, spellCount)

	Signals.connect("bossPhaseCutinEnd", self,"_onBossPhaseCutinEnd")
	currentPhase = NonSpell_1
	
	#fireTimer.start(fireInterval)
	
	
func _process(delta: float) -> void:
	
	if movingToCenter:
		if bossName == "Okuu":
			position.y = self.n2OriginalY
		#moveVec.y = 0
		var moveSpeed = 2 if bossName == "Satori" else 8
		if position.x <= 188:
			position.x += moveSpeed
		elif position.x >= 196:
			position.x -= moveSpeed
			
		
		if 188 <= position.x and position.x <= 196:
			position.x = 192
			movingToCenter = false
			moveVec = Vector2.ZERO
			
	if bDieExplosion.animation == "Implode" and bDieExplosion.scale.x >= 0:
		bDieExplosion.scale -= Vector2(0.1, 0.1)
	
	
func fire(delta: float):
	pass


func reduceHP(damage: int):
	pass
	
func _onBossEntered(_bossName: String):
	if self.bossOnScreen:
		if _bossName == self.bossName and not inited:
			active = true
			self.init()
	
func _onBossPhaseCutinEnd(bossName, newPhase):
	changingPhase = false
	currentPhase = newPhase


func _on_BossDieExplode_animation_finished() -> void:
	if bDieExplosion.animation == "Implode":
		bDieExplosion.scale = Vector2(12.0, 12.0)
		bDieExplosion.play("Explode")
	elif bDieExplosion.animation == "Explode":
		self.bossOnScreen = false
		self.dead = true
		queue_free()


func _on_Boss_area_exited(area: Area2D) -> void:
	if area.name == "PlayArea" and bossName == "Okuu":		# Okuu Non2
		self.n2MoveAngle *= -1
		self.position.y = self.n2OriginalY + 20*0
