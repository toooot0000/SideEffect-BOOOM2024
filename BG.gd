extends Sprite2D

class_name BG

@onready var shMat := (material as ShaderMaterial)

var rippleTime := 0.0
var rippling := false

func _ready():
	shMat.set_shader_parameter("radiusInPixel", G.radius)
	shMat.set_shader_parameter("rippleTime", 5)
	var screenSize = DisplayServer.window_get_size()
	print(screenSize)
	position = screenSize / 2

func ripple(ripplePosition: Vector2):
	var rad = (ripplePosition - position).angle_to(Vector2.RIGHT)
	shMat.set_shader_parameter("ripplePosition", -rad)
	rippleTime = 0
	rippling = true

func _process(delta):
	if !rippling:
		return
	rippleTime += delta
	shMat.set_shader_parameter("rippleTime", rippleTime * 1.5)
	if rippleTime >= 5:
		rippling = false