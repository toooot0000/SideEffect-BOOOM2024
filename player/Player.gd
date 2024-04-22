extends Node2D
class_name  Player

@export var spd: float = 70

@export_file("*.tscn") var bulletScenePath

@onready var bulletScene := load(bulletScenePath) as PackedScene
@onready var arrow := $Pivot/Arrow
@onready var arrowPivot: Node2D = $Pivot

signal point_changed(newPoint)

var hp: int = 10
var point: int = 0:
	set(value):
		point = value
		point_changed.emit(value)


func _input(event):

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
	move(delta)


func move(delta):
	var verDir := float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
	var horDir := float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
	var spdDir := Vector2(verDir, horDir)
	position += spdDir * spd * delta
	global_position = G.clampInsideCircle(global_position)


func shoot(shootDir: Vector2):
	var bullet := bulletScene.instantiate() as Bullet
	$"..".add_child(bullet)
	bullet.dir = shootDir
	bullet.global_position = arrow.global_position
	print("Generate bullet at %s" % bullet.global_position)
