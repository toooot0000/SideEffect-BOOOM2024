class_name BulletCard
extends Control


@export var rotRange := 0.1
@export var rotSpd := 0.8

@onready var shaker: Shaker = $Shaker
@onready var mat: ShaderMaterial = ($"../.." as CanvasItem).material as ShaderMaterial

var _timer := 0.0

func _process(delta):
	_timer += delta
	if _timer > 3600:
		_timer = 0
	
	mat.set_shader_parameter("x_rot", rad_to_deg(cos(_timer * PI * rotSpd) * rotRange))
	mat.set_shader_parameter("y_rot", rad_to_deg(sin(_timer * PI * rotSpd) * rotRange))
	
	

func _on_player_shoot_bullet(_direction:Vector2, _bulletConfig:BulletConfig):
	var curPos = position
	shaker.startWithCallable(0.1, func(_i, pos):
		position = pos + curPos
	)


func _on_mouse_entered():
	print("Mouse")
