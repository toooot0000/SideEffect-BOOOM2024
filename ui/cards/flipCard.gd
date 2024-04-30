extends Control

@export var rotRange := 0.1
@export var rotSpd := 0.8
@export var flipTime := 0.1

@export var magItem: PackedScene

@onready var mat: ShaderMaterial = material as ShaderMaterial
@onready var bulletCard: Control = $SubViewport/Bullet
@onready var enemyCard: Control = $SubViewport/Enemy
@onready var shaker: Shaker = $SubViewport/Bullet/Shaker


enum State{ IDLE, FLIP, RE_FLIP }

var state := State.IDLE :
	set(val):
		state = val
		match val:
			State.IDLE:
				print("Start IDLE")
			State.FLIP:
				print("Start FLIPPING")
			State.RE_FLIP:
				print("Start RE_FLIPPING")

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

var _idleTimer := 0.0
var _flipTimer := 0.0
var _startYRot := 0.0

func _ready():
	_idleTimer = randf_range(0, 30)

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

func _on_player_shoot_bullet(_direction:Vector2, _bulletConfig:BulletConfig):
	var curPos = position
	shaker.startWithCallable(0.1, func(_i, pos):
		position = pos + curPos
	)

func setUpUI():
	$SubViewport/Bullet/Label.text = "伤害：%d" % bulletConfig.bulletDamage
	$SubViewport/Bullet/Sprite.texture = bulletConfig.displayTexture
	if bulletConfig.magazineSize < 0:
		$SubViewport/Bullet/Inf.visible = true
	else:
		var cont = $SubViewport/Bullet/MagzineContainer
		for i in range(bulletConfig.magazineSize):
			var inst = magItem.instantiate() as MagzineItem
			cont.add_child(inst)
			G.player.shootBullet.connect(func(_dir, _conf, _ind):
				# TODO: Add bullet item logic
				pass
			)
	$SubViewport/Enemy/Sprite.texture = bulletConfig.relatedEnemy.sprite
	$SubViewport/Enemy/Label.text = "生命：%d\n分数：%d" %[bulletConfig.relatedEnemy.enemyLife, bulletConfig.relatedEnemy.point]
	