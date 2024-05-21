extends Sprite2D

@export var spd := 0.1

@onready var mat := material as ShaderMaterial


# func _input(event):
# 	if event is InputEventMouse:
# 		var pos = (event as InputEventMouse).position
# 		var dir = (pos - position).angle_to(Vector2.LEFT)
# 		mat.set_shader_parameter("Deg", -dir)

var cur := 0.0

func _process(delta):
	mat.set_shader_parameter("Deg", cur)
	cur += delta * spd