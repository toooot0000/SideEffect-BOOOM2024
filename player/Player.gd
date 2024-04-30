extends Node2D
class_name  Player

class BulletInfo:
	var config: BulletConfig
	var remainingCount: int

	func _init(c: BulletConfig, count: int):
		config = c
		remainingCount = count

@export var spd: float = 70

@export var kickBackTime := 0.1
@export var kickBackSpd := 120.0
@export var hpLimit := 10
@export var initBullet :BulletConfig:
	set(v):
		initBullet = v
		var info = BulletInfo.new(v, -1)
		bulletInfo.append(info)

@onready var arrow := $Pivot/Arrow
@onready var arrowPivot: Node2D = $Pivot
@onready var anim: AnimationPlayer = $AnimationPlayer

signal pointChangedFromTo(old, newPoint)
signal hpChangedFromTo(old, new)
signal shootBullet(direction: Vector2, bulletConfig: BulletConfig, indexOfMag: int)

var hp: int = hpLimit:
	set(value):
		var o = hp
		hp = value
		hpChangedFromTo.emit(o, value)

var point: int = 0:
	set(value):
		var o = point
		point = value
		pointChangedFromTo.emit(o, value)

@export var curBullet: BulletConfig:
	get:
		return bulletInfo[-1].config


var _bulletScene: PackedScene:
	get:
		if curBullet == null:
			return null
		return curBullet.bulletPackedScene

var isKickingBack := false
var kickBackDir := Vector2.ZERO
var kickBackTimer := 0.0
var kickBackTween :Tween
var _overlappingEnemies : Array[Enemy] = []
var bulletInfo: Array[BulletInfo] = []

func _input(event):
	if G.state != G.State.Idle:
		return
	if isKickingBack: return
	var shootDir: Vector2 = Vector2.ZERO

	# Rotate arrow
	if event is InputEventMouse:
		var mouseEvent := event as InputEventMouse
		var mousePosition := mouseEvent.position
		var vec = mousePosition - position
		shootDir = vec.normalized()
		var rad = Vector2.RIGHT.angle_to(vec)
		arrowPivot.rotation = rad

	#Shoot
	if event is InputEventMouseButton:
		var mouseEvn := event as InputEventMouseButton
		if mouseEvn.is_released() && mouseEvn.button_index == MOUSE_BUTTON_LEFT:
			shoot(shootDir)


func _process(delta):
	if G.state != G.State.Idle:
		return
	var vel := Vector2.ZERO
	if isKickingBack:
		vel = kickBackSpd * kickBackDir.normalized()
	else:
		var verDir := float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
		var horDir := float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
		var spdDir := Vector2(verDir, horDir)
		vel = spdDir * spd
	position += vel * delta
	global_position = G.clampInsideCircle(global_position)

	_checkKickBack()
	if isKickingBack:
		kickBackTimer += delta
	if kickBackTimer > kickBackTime:
		isKickingBack = false


func shoot(shootDir: Vector2):
	if bulletInfo[-1].remainingCount > 0:
		bulletInfo[-1].remainingCount -= 1
		if bulletInfo[-1].remainingCount == 0:
			# TODO: Add auto change bullet mach
			pass
	var bullet := _bulletScene.instantiate() as Bullet
	$"..".add_child(bullet)
	bullet.dir = shootDir
	bullet.global_position = arrow.global_position
	bullet.config = curBullet
	bullet.rotate(shootDir.angle())
	print("Generate bullet at %s" % bullet.global_position)
	anim.play("arrow_shake")
	shootBullet.emit(shootDir, curBullet, curBullet.magazineSize - bulletInfo[-1].remainingCount - 1)
	

func _checkKickBack():
	if isKickingBack || !len(_overlappingEnemies):
		return
	isKickingBack = true
	_startKickBack()


func _startKickBack():
	hp -= 1
	var enemy = _overlappingEnemies[-1]
	kickBackDir = position - enemy.position
	kickBackTimer = 0
	$Sprite.modulate = Color.RED
	if kickBackTween:
		kickBackTween.kill()
	kickBackTween = get_tree().create_tween()
	kickBackTween.tween_property($Sprite, ^"modulate", Color.WHITE, kickBackTime).set_trans(Tween.TRANS_EXPO)


func _on_area_2d_area_entered(area:Area2D):
	if !(area.get_parent() is Enemy): return 
	_overlappingEnemies.append(area.get_parent() as Enemy)
	


func _on_area_2d_area_exited(area:Area2D):
	if !(area.get_parent() is Enemy): return 
	var ind =_overlappingEnemies.find(area.get_parent() as Enemy)
	if ind >= 0 && ind < len(_overlappingEnemies):
		_overlappingEnemies.remove_at(ind)


func shiftBullet():
	pass

