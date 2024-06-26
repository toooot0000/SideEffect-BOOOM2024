extends Control
class_name FlipCard

@export var rotRange := 0.1
@export var rotSpd := 0.8
@export var flipTime := 0.1
@export var magItem: PackedScene
@export var anim :AnimationPlayer

@onready var mat: ShaderMaterial = material as ShaderMaterial
@onready var bulletCard: Control = $SubViewport/Bullet
@onready var enemyCard: Control = $SubViewport/Enemy
@onready var shaker: Shaker = $SubViewport/Bullet/Shaker
@onready var move: EaseMove = $EaseMove

signal willShiftBack

enum State{ IDLE, FLIP, RE_FLIP }

var state := State.IDLE :
	set(val):
		state = val
		match val:
			State.IDLE:
				# print("Start IDLE")
				pass
			State.FLIP:
				# print("Start FLIPPING")
				pass
			State.RE_FLIP:
				# print("Start RE_FLIPPING")
				pass

var xRot := 0.0:
	set(val):
		xRot = val
		mat.set_shader_parameter("x_rot", xRot)

var yRot := 0.0:
	set(val):
		yRot = val
		mat.set_shader_parameter("y_rot", yRot)

var bulletConfig: BulletConfig:
	set(val):
		bulletConfig = val
		setUpUI()

var targetPosition: Vector2:
	set(val):
		$EaseMove.targetPosition = val

var _idleTimer := 0.0
var _flipTimer := 0.0
var _startYRot := 0.0
var _magItem :Array[MagzineItem] = []

func _ready():
	_idleTimer = randf_range(0, 30)
	move.positionGetter = func():
		return position
	move.positionSetter = func(p):
		position = p
	


func _process(delta):
	_idleTimer += delta
	if _idleTimer > 3600:
		_idleTimer = 0
	xRot = rad_to_deg(cos(_idleTimer * PI * rotSpd) * rotRange)

	match state:
		State.IDLE:
			yRot = rad_to_deg(sin(_idleTimer * PI * rotSpd) * rotRange)
		State.FLIP:
			_flipTimer += delta
			_setFlipYRot(true)
			if _flipTimer > flipTime:
				state = State.IDLE

			pass
		State.RE_FLIP:
			_flipTimer -= delta
			_setFlipYRot(false)
			if _flipTimer < 0:
				state = State.IDLE
			pass
	

func _on_bullet_mouse_entered():
	state = State.FLIP
	_startYRot = yRot
	pass

func _on_bullet_mouse_exited():
	state = State.RE_FLIP
	_startYRot = yRot
	pass

func _setFlipYRot(forward: bool):
	var i = clamp(_flipTimer / flipTime, 0, 1)
	if i < 0.5:
		yRot = lerp((_startYRot if forward else 0.0), 180.0, i)
		bulletCard.modulate.a = 1
		enemyCard.visible = false
	else:
		yRot = lerp(-180.0, (_startYRot if !forward else 0.0), i)
		bulletCard.modulate.a = 0
		enemyCard.visible = true

func _on_player_shoot_bullet(_direction:Vector2, _bulletConfig:BulletConfig, ind: int):
	var curPos = position
	shaker.startWithCallable(0.1, func(_i, pos):
		position = pos + curPos
	)
	if ind >= 0:
		_magItem[ind].used()

func setUpUI():
	for item in _magItem:
		item.queue_free()
	_magItem.clear()
	$SubViewport/Bullet/Label.text = "伤害：%d" % bulletConfig.bulletDamage
	$SubViewport/Bullet/Sprite.texture = bulletConfig.displayTexture
	if bulletConfig.magazineSize < 0:
		$SubViewport/Bullet/Inf.visible = true
		$SubViewport/Bullet/ReloadLabel.visible = false
	else:
		$SubViewport/Bullet/Inf.visible = false
		$SubViewport/Bullet/ReloadLabel.visible = true
		$SubViewport/Bullet/ReloadLabel.text = "装弹：%2.1f" % bulletConfig.reloadTime
		var cont = $SubViewport/Bullet/MagzineContainer
		for i in range(bulletConfig.magazineSize):
			var inst = magItem.instantiate() as MagzineItem
			cont.add_child(inst)
			_magItem.append(inst)

	$SubViewport/Enemy/Sprite.texture = bulletConfig.relatedEnemy.sprite
	$SubViewport/Enemy/Label.text = "生命：%d\n分数：%d" %[bulletConfig.relatedEnemy.enemyLife, bulletConfig.relatedEnemy.point]


func _on_player_start_reload(time:float):
	var reloadAnim = $SubViewport/Bullet/Line/AnimationPlayer as AnimationPlayer
	reloadAnim.speed_scale = 1.0 / time
	reloadAnim.play("reload")
	await reloadAnim.animation_finished
	setUpUI()


func _on_player_shoot_in_reload():
	if !shaker.is_stopped():
		return
	var curPos = position
	shaker.startWithCallable(0.1, func(_i, pos):
		position = pos + curPos
	)


func shiftBack(_targetPosition: Vector2):
	$EaseMove.enable = false
	var shiftAnim := anim.get_animation("shifted")
	var trackIdx := shiftAnim.find_track(".:position", Animation.TYPE_VALUE)
	var keyCount = shiftAnim.track_get_key_count(trackIdx)
	shiftAnim.track_set_key_value(trackIdx, 0, position)
	shiftAnim.track_set_key_value(trackIdx, 1, position + Vector2.RIGHT * 120)
	shiftAnim.track_set_key_value(trackIdx, keyCount-1, _targetPosition)
	anim.play("shifted")
	await anim.animation_finished
	$EaseMove.enable = true


func newlyAdded(_targetPosition: Vector2):
	$EaseMove.enable = false
	var shiftAnim := anim.get_animation("added")
	var trackIdx := shiftAnim.find_track(".:position", Animation.TYPE_VALUE)
	var keyCount = shiftAnim.track_get_key_count(trackIdx)
	shiftAnim.track_set_key_value(trackIdx, keyCount-1, _targetPosition)
	anim.play("added")
	await anim.animation_finished
	$EaseMove.enable = true

func moveToBack():
	var p = get_parent()
	p.move_child(self, 0)
	willShiftBack.emit()