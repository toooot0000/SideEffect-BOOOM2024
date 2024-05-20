extends TextureButton

@export var totalTime = 0.1
@export var group :CanvasGroup

@onready var mat := group.material as ShaderMaterial

var _timer := 0.0
var _active := false

func _process(delta):
	if _active:
		_timer = clamp(_timer + delta, 0, totalTime)
	else:
		_timer = clamp(_timer - delta, 0, totalTime)
	
	var i = _timer / totalTime

	mat.set_shader_parameter("x", i)


func _on_mouse_entered():
	_active = true

func _on_mouse_exited():
	_active = false
