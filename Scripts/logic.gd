extends Node2D

var isAlreadyAtEnd = false

func _ready():
	#ProjectSettings.set_setting("rendering/environment/defaults/default_clear_color", Color(0,0,0))
	#RenderingServer.set_default_clear_color(Color(0,0,0))
	pass 

func _process(_delta):
	var player = get_node("Player")

	if player.position.x > 3799:
		gameEnd()
	pass

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func gameEnd():
	var spTimer : Timer = get_node("CanvasLayer/timerText/MsTimer")

	spTimer.paused = true

func onCreditsLabelMetaClicked(meta):
	OS.shell_open(str(meta))
	pass
