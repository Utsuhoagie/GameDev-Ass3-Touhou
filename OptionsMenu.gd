extends Control

onready var lifeNumContainer: HBoxContainer = get_node("OptionRows/LifeContainer/NCont")
onready var bombNumContainer: HBoxContainer = get_node("OptionRows/BombContainer/NCont")

var texture0_normal = load("res://SA Assets/Usable/Menu/Options/0.png")
var texture1_normal = load("res://SA Assets/Usable/Menu/Options/1.png")
var texture2_normal = load("res://SA Assets/Usable/Menu/Options/2.png")
var texture3_normal = load("res://SA Assets/Usable/Menu/Options/3.png")

var texture_normal = [texture0_normal, texture1_normal, texture2_normal, texture3_normal]


var texture0_pressed = load("res://SA Assets/Usable/Menu/Options/0Chosen.png")
var texture1_pressed = load("res://SA Assets/Usable/Menu/Options/1Chosen.png")
var texture2_pressed = load("res://SA Assets/Usable/Menu/Options/2Chosen.png")
var texture3_pressed = load("res://SA Assets/Usable/Menu/Options/3Chosen.png")

var texture_pressed = [texture0_pressed, texture1_pressed, texture2_pressed, texture3_pressed]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifeNumContainer.get_child(GlobalVar.life).texture_normal = texture_pressed[GlobalVar.life]
	bombNumContainer.get_child(GlobalVar.bomb).texture_normal = texture_pressed[GlobalVar.bomb]


func _on_Life0_pressed() -> void:
	GlobalVar.life = 0
	
	var curNum = lifeNumContainer.get_child(0)
	curNum.texture_normal = curNum.texture_pressed
	
	for i in range(0,4):
		if i != 0:
			var otherNum = lifeNumContainer.get_child(i)
			otherNum.texture_normal = texture_normal[i]


func _on_Life1_pressed() -> void:
	GlobalVar.life = 1
	
	var curNum = lifeNumContainer.get_child(1)
	curNum.texture_normal = curNum.texture_pressed
	
	for i in range(0,4):
		if i != 1:
			var otherNum = lifeNumContainer.get_child(i)
			otherNum.texture_normal = texture_normal[i]


func _on_Life2_pressed() -> void:
	GlobalVar.life = 2
	
	var curNum = lifeNumContainer.get_child(2)
	curNum.texture_normal = curNum.texture_pressed
	
	for i in range(0,4):
		if i != 2:
			var otherNum = lifeNumContainer.get_child(i)
			otherNum.texture_normal = texture_normal[i]


func _on_Life3_pressed() -> void:
	GlobalVar.life = 3

	var curNum = lifeNumContainer.get_child(3)
	curNum.texture_normal = curNum.texture_pressed
	
	for i in range(0,4):
		if i != 3:
			var otherNum = lifeNumContainer.get_child(i)
			otherNum.texture_normal = texture_normal[i]


func _on_Bomb0_pressed() -> void:
	GlobalVar.bomb = 0
	
	var curNum = bombNumContainer.get_child(0)
	curNum.texture_normal = curNum.texture_pressed
	
	for i in range(0,4):
		if i != 0:
			var otherNum = bombNumContainer.get_child(i)
			otherNum.texture_normal = texture_normal[i]


func _on_Bomb1_pressed() -> void:
	GlobalVar.bomb = 1
	
	var curNum = bombNumContainer.get_child(1)
	curNum.texture_normal = curNum.texture_pressed
	
	for i in range(0,4):
		if i != 1:
			var otherNum = bombNumContainer.get_child(i)
			otherNum.texture_normal = texture_normal[i]


func _on_Bomb2_pressed() -> void:
	GlobalVar.bomb = 2
	
	var curNum = bombNumContainer.get_child(2)
	curNum.texture_normal = curNum.texture_pressed
	
	for i in range(0,4):
		if i != 2:
			var otherNum = bombNumContainer.get_child(i)
			otherNum.texture_normal = texture_normal[i]


func _on_Bomb3_pressed() -> void:
	GlobalVar.bomb = 3
	
	var curNum = bombNumContainer.get_child(3)
	curNum.texture_normal = curNum.texture_pressed
	
	for i in range(0,4):
		if i != 3:
			var otherNum = bombNumContainer.get_child(i)
			otherNum.texture_normal = texture_normal[i]




func _on_Return_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")
