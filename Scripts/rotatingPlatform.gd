extends Node2D

@export var block1 : TileMap
@export var block2 : TileMap
@export var speed : float
@export var isLocked = false
var move = 0
var moveType = 2

func _process(_delta):
	if not isLocked:
		if moveType == 1:
			block1.position.x += speed
			block2.position.x -= speed
			move += speed
		if moveType == 2:
			block1.position.y += speed
			block2.position.y -= speed
			move += speed
		if moveType == 3:
			block1.position.x -= speed
			block2.position.x += speed
			move += speed
		if moveType == 4:
			block1.position.y -= speed
			block2.position.y += speed
			move += speed

		if move == 128 && moveType != 4:
			moveType += 1
			move = 0
		if move == 128 && moveType == 4:
			moveType = 1
			move = 0

	#print(move)
	pass



func onPauseMenuDisabled():
	isLocked = false
	pass

func onPauseMenuEnabled():
	isLocked = true
	pass
