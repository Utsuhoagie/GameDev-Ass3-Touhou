extends TextureRect


var index: int = 0
onready var animSprite: AnimatedSprite  #= $AnimSprite
onready var frames: SpriteFrames = null	# $AnimSprite.frames
onready var nFrames: int = 0			# animSprite.frames.get_frame_count("SpellIcon")

func _process(delta: float) -> void:
	return
	
	
	
	rect_global_position = Vector2(100,100)
	if index == nFrames:
		index = 0
	else:
		index += 1
		
	animSprite.frame = index
