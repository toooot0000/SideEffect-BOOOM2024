extends Sprite2D

@onready var mat := material as ShaderMaterial

@export var x := 0.0:
	set(val):
		x = val
		if mat == null: return
		mat.set_shader_parameter("x", val)

@export var deg := 0.0:
	set(val):
		deg = val
		if mat == null: return
		mat.set_shader_parameter("degInRad", val)