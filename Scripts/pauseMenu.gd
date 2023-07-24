extends Control

@export var particles : CPUParticles2D
@export var mainCamera : Camera2D
@export var musicPlayer : AudioStreamPlayer

@export var pauseName : Label

signal menuEnabled()
signal menuDisabled()

func _process(_delta):
	if Input.is_action_just_pressed("pauseMenuBtn"):
		toggleMenu()
	if visible:
		var screenSize = get_viewport().get_visible_rect().size

		position = Vector2(screenSize.x / 1.8, screenSize.y / 1.8)
		scale = Vector2(screenSize.x / 1300, screenSize.x / 1300)
	pass

func toggleMenu():
	if visible:
		visible = false
		emit_signal("menuDisabled")
		mainCamera.position_smoothing_speed = 4
	else:
		visible = true
		emit_signal("menuEnabled")
		mainCamera.position_smoothing_speed = 15
	pass


func onDecoCheckToggled(isEnabled):
	if isEnabled:
		particles.visible = true
	else:
		particles.visible = false
	pass

func onMusicSliderChanged(change):
	if change > -15:
		musicPlayer.volume_db = change
	else:
		musicPlayer.volume_db = -80
	pass

func onResetButtonPressed():
	get_tree().reload_current_scene()
	pass
