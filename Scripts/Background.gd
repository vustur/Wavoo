extends TileMap

var skewSmooth
var incrNum = 1
@export var changeSpeed : float

func _ready():
	changeSpeed = changeSpeed * 0.01
	modulate = Color("54504e1a")
	pass

func _process(_delta):
	if skew <= 0.2:
		incrNum = 1
	if skew >= 0.4:
		incrNum = -1
	skew = skew + changeSpeed * incrNum
	pass
