extends Sprite2D

class_name BG

@onready var shMat := (material as ShaderMaterial)
@onready var rippleLength := 10

var rippleTimes :Array[float] = []
var ripplePositions :Array[float] = []
var rippleInd := 0

var reRippleTimes :Array[float] = []
var reRipplePositions :Array[float] = []
var reRippleInd := 0

func _ready():
	for i in range(rippleLength):
		rippleTimes.append(5)
		reRippleTimes.append(5)
		ripplePositions.append(0)
		reRipplePositions.append(0)
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


func rippleAtRad(rad: float):
	ripplePositions[rippleInd] = rad
	rippleTimes[rippleInd] = 0
	shMat.set_shader_parameter("ripplePositions", ripplePositions)

func reRipple(ripplePosition: Vector2):
	reRippleInd = (reRippleInd + 1) % 5
	var rad = (ripplePosition - position).angle_to(Vector2.RIGHT)
	reRipplePositions[rippleInd] = -rad
	reRippleTimes[rippleInd] = 0
	shMat.set_shader_parameter("reRipplePositions", reRipplePositions)

func reRippleAtRad(rad: float):
	reRipplePositions[rippleInd] = rad
	reRippleTimes[rippleInd] = 0
	shMat.set_shader_parameter("reRipplePositions", reRipplePositions)

func _process(delta):
	for i in range(5):
		rippleTimes[i] = min(rippleTimes[i] + delta, 5)
		reRippleTimes[i] = min(reRippleTimes[i] + delta, 5)

	shMat.set_shader_parameter("rippleTimes", rippleTimes)
	shMat.set_shader_parameter("reRippleTimes", reRippleTimes)
	
