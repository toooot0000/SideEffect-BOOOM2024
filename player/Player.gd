extends Node2D
class_name  Player

@export var spd: float = 70

@export_file("*.tscn") var bulletScenePath
@export var kickBackTime := 0.1
@export var kickBackSpd := 120.0

@onready var bulletScene := load(bulletScenePath) as PackedScene
@onready var arrow := $Pivot/Arrow
@onready var arrowPivot: Node2D = $Pivot
@onready var anim: AnimationPlayer = $AnimationPlayer

signal point_changed(newPoint)
signal hpChangedFromTo(old, new)

var hp: int = 5:
	set(value):
		var o = hp
		hp = value
		hpChangedFromTo.emit(o, value)

var point: int = 0:
	set(value):
		point = value
		point_changed.emit(value)

var isKickingBack := false
var kickBackDir := Vector2.ZERO
var kickBackTimer := 0.0
var kickBackTween :Tween
var _overlappingEnemies : Array[Enemy] = []

func _input(event):
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
	var bullet := bulletScene.instantiate() as Bullet
	$"..".add_child(bullet)
	bullet.dir = shootDir
	bullet.global_position = arrow.global_position
	print("Generate bullet at %s" % bullet.global_position)
	anim.play("arrow_shake")
	

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