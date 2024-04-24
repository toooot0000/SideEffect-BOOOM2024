extends Sprite2D

class_name BG

@onready var shMat := (material as ShaderMaterial)

var rippleTimes :Array[float] = [5, 5, 5, 5, 5]
var ripplePositions :Array[float] = [0, 0, 0, 0, 0]
var rippleInd := 0

var reRippleTimes :Array[float] = [5, 5, 5, 5, 5]
var reRipplePositions :Array[float] = [0, 0, 0, 0, 0]
var reRippleInd := 0

func _ready():
	shMat.set_shader_parameter("radiusInPixel", G.radius)
	shMat.set_shader_parameter("rippleTimes", rippleTimes)
	shMat.set_shader_parameter("reRippleTimes", reRippleTimes)
	var screenSize = DisplayServer.window_get_size()
	position = screenSize / 2

func ripple(ripplePosition: Vector2):
	rippleInd = (rippleInd + 1) % 5
	var rad = (ripplePosition - position).angle_to(Vector2.RIGHT)
	ripplePositions[rippleInd] = -rad
	rippleTimes[rippleInd] = 0
	shMat.set_shader_parameter("ripplePositions", ripplePositions)

func reRipple(ripplePosition: Vector2):
	reRippleInd = (reRippleInd + 1) % 5
	var rad = (ripplePosition - position).angle_to(Vector2.RIGHT)
	reRipplePositions[rippleInd] = -rad
	reRippleTimes[rippleInd] = 0
	shMat.set_shader_parameter("reRipplePositions", reRipplePositions)

func _process(delta):
	for i in range(5):
		rippleTimes[i] = min(rippleTimes[i] + delta, 5)
		reRippleTimes[i] = min(reRippleTimes[i] + delta, 5)

	shMat.set_shader_parameter("rippleTimes", rippleTimes)
	shMat.set_shader_parameter("reRippleTimes", reRippleTimes)
	