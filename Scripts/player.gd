extends CharacterBody2D

@export var speed : float
@export var birdSpeed : float
@export var JumpVelocity : float
@export var dashWayMax : float
@export var particlesSpeed : float
@export var sprite : Sprite2D
@export var particles : CPUParticles2D
@export var trail : CPUParticles2D
@export var tileBlocks : TileMap
@export var crashPrtc : CPUParticles2D
@export var bodyShape : CollisionShape2D
const WHITE = Color(255,255,255)
var isNormalMode = true
var dashDir = -1
var dashY = 1
var isDashDirSwitched = false
var dashWay = 0
var isFlooredLastDash = false # Бул для проверки, был ли игрок на земле перед последним дешем
var checkPoint = Vector2(0,0)
var isControlsDisabled = false
var isCrashed = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	#position = Vector2(3450, -80) # Used for dev
	#checkPoint = position
	pass

func _physics_process(delta):

##								Нормальный режим
	if isNormalMode and not isControlsDisabled:
		if not is_on_floor():
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JumpVelocity

		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
			particles.gravity.x = direction * particlesSpeed
			trail.emitting = true
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			trail.emitting = false
		
		sprite.skew = direction * abs(velocity.x) * -0.1

		dashDir = direction

		if (Input.is_action_just_pressed("down") and dashDir != 0 and isFlooredLastDash):
			if is_on_floor():
				dashY = 1
			else:
				dashY = -1
			changeMode(false)

		if velocity.y < 0:
			sprite.scale.x = 1.25 + velocity.y * 0.001
		else:
			sprite.scale.x = 1.25

		if is_on_floor() and not isFlooredLastDash and isNormalMode:
			isFlooredLastDash = true

##								Режим волны
	if not isNormalMode and not isControlsDisabled:
		velocity.x = birdSpeed * dashDir * 2
		velocity.y = birdSpeed * (-1) * dashY
		if Input.is_action_just_released("down") and not isDashDirSwitched:
			dashDir = dashDir * -1
			isDashDirSwitched = true
		dashWay = dashWay + 1

##								Любые режимы
#						Проверки
	if dashWay >= dashWayMax:
		changeMode(true)

	for i in get_slide_collision_count(): # Столкновения
		var collision = get_slide_collision(i)
		var collider = collision.get_collider() as TileMap
		var cellPos = collider.local_to_map(collision.get_position())
		var tileIdx = collider.get_cell_atlas_coords(0, cellPos)
		var spikes = [Vector2i(0,6), Vector2i(1,6), Vector2i(0,7), Vector2i(1,7)]
		var _spTimer : RichTextLabel = get_node("../CanvasLayer/timerText")

		#print("Id on tilemap: ", tileIdx, "Id in-game: ", cellPos)

		if not isNormalMode:
			if dashWay > 3:
				changeMode(true)
		if tileIdx == Vector2i(0, 5):
			checkPoint.x = collision.get_position().x
			checkPoint.y = collision.get_position().y - 20
			#print("Check pointoo! Check loct: ", checkPoint, ". Check time = ", _spTimer.text)
		if spikes.find(tileIdx) != -1:
			respawn()

	if position.y > 200 or position.y < -220:
		respawn()


#						Остальное
	move_and_slide()

##								Обычный процесс
func _process(delta):
	#						Дополнительные кнопки
	if Input.is_action_just_pressed("respawn"):
		respawn()
	pass

##								Вызывваемые методы
func changeMode(isToNormal):
	if isToNormal:
		isNormalMode = true
		scale = Vector2(1, 1)
		velocity.y = 0
		dashWay = 0
		dashDir = 0
		isDashDirSwitched = false
		dashY = 1

	if not isToNormal:
		isNormalMode = false
		scale = Vector2(0.8, 0.8)
		isFlooredLastDash = false

func respawn():
	if not isCrashed:
		pausePlayer(true)
		isCrashed = true
		bodyShape.disabled = true
		sprite.hide()
		velocity = Vector2(0,0)
		changeMode(true)
		crashPrtc.emitting = true

		#Timer
		await get_tree().create_timer(1).timeout

		#Timeout
		position = checkPoint
		sprite.show()
		bodyShape.disabled = false
		isCrashed = false
		pausePlayer(false)

func onPauseMenuEnabled():
	pausePlayer(true)
	pass

func onPauseMenuDisabled():
	pausePlayer(false)
	pass

func pausePlayer(isEnable):
	if isEnable:
		isControlsDisabled = true
		set_physics_process(false)
		trail.emitting = false
	if not isEnable:
		isControlsDisabled = false
		set_physics_process(true)
		trail.emitting = true
