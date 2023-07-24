extends RichTextLabel

var textOrig : String
var isShowing = false
@export var HitboxPos : Vector2
@export var showSpeed : float

func _ready():
	var hitbox = get_node("Area2D")

	if HitboxPos != null:
		hitbox.position = HitboxPos 
	if showSpeed == 0:
		showSpeed = 1
	textOrig = text
	text = " [center]?"
	
	print(HitboxPos)
	pass

func _process(_delta):
	if isShowing && visible_ratio != 1:
		visible_ratio = visible_ratio + 0.025 * showSpeed
	pass

func onLabelAreaBodyEntered(_body:Node2D):
	if not isShowing:
		text = textOrig
		visible_ratio = 0
		isShowing = true
	pass
