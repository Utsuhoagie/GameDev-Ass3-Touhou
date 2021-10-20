extends Area2D
class_name Item

enum { SDrop, P_Small, P_Big, Bomb, Life}
var type
var inited: bool = false
var value: Dictionary = {
	SDrop: 0,
	P_Small: 0,
	P_Big: 0,
	Bomb: 0,
	Life: 0
}

var speed: float = 0

onready var animSprite = $AnimSprite


func _ready() -> void:
	animSprite = $AnimSprite

func init(itemType):
	type = itemType
	animSprite = $AnimSprite
	match type:
		SDrop:
			value[SDrop] = 50
			animSprite.frame = 0
		P_Small:
			value[P_Small] = 0.1
			animSprite.frame = 1
		P_Big:
			value[P_Big] = 0.5
			animSprite.frame = 2
		Bomb:
			value[Bomb] = 1
			animSprite.frame = 3
			animSprite.scale *= 1.5
		Life:
			value[Life] = 1
			animSprite.frame = 4
			animSprite.scale *= 1.5


func _process(delta: float) -> void:
	if speed <= 40:
		speed += 0.8
	
	position.y += speed*delta
