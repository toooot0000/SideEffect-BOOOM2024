extends TextureButton

@export var totalTime = 0.1
@export var group :CanvasGroup

@onready var mat := group.material as ShaderMaterial
@onready var vibrate := material as ShaderMaterial
@onready var spr := texture_normal as Texture2D

var _timer := 0.0
var _active := false

func _ready():
	texture_normal = null
	vibrate.set_shader_parameter("Range",  1)

func _process(delta):
	if _active:
		_timer = clamp(_timer + delta, 0, totalTime)
	else:
		_timer = clamp(_timer - delta, 0, totalTime)
	
	var i = _timer / totalTime

	mat.set_shader_parameter("x", i)


func _on_mouse_entered():
	texture_normal = spr
	vibrate.set_shader_parameter("Range",  2.5)
	_active = true

func _on_mouse_exited():
	texture_normal = null
	vibrate.set_shader_parameter("Range",  1)
	_active = false
