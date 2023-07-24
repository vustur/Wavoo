extends Camera2D

@export var player : CharacterBody2D
@export var borderBtm : Sprite2D
var isLocked = true

func _process(_delta):
	if isLocked:
		position = Vector2(player.position.x, 0)
	else:
		position = Vector2(player.position.x, player.position.y)

	if Input.is_action_just_pressed("zoomIn"):
		zoom = Vector2((zoom.x * 0.8), (zoom.y * 0.8))
	if Input.is_action_just_pressed("zoomOut"):
		zoom = Vector2((zoom.x / 0.8), (zoom.y / 0.8))

# Position unlock after tutorial UPD: Disabled because yes
#	if player.position.x > 1600:
#		isLocked = false
#	if player.position.x < 1600:
#		isLocked = true
#	print(borderBtm.position.y)
	pass

