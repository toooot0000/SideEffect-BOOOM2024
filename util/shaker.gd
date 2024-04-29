class_name Shaker
extends Timer


@export var freqency := 1.0

@export var randomness := 0.0
@export var axisOffet := 0.0

@export var minX := -1.0
@export var maxX := 1.0
@export var xRangeCurve :Curve

@export var minY := -1.0
@export var maxY := 1.0
@export var yRangeCurve :Curve

var _callable: Callable

func _process(_delta):
	if is_stopped():
		_callable.callv([1, Vector2.ZERO])
		return
	_callable.callv([_getI(), getPosition()])

func startWithCallable(time_sec: float, callable: Callable):
	wait_time = time_sec
	startShake(callable)

func startShake(callable: Callable):
	if !is_stopped():
		stop()
	super.start()
	_callable = callable


func _getI() -> float:
	return time_left / wait_time

func getPosition() -> Vector2:
	var i := _getI()
	var k1 = (sin(i * freqency) + 1) * .5
	var k2 = (sin(i * freqency + (axisOffet * (1 + randf() * randomness)) * PI) + 1) * .5
	var kx = k1 if xRangeCurve == null else  xRangeCurve.sample(k1)
	var ky = k2 if yRangeCurve == null else yRangeCurve.sample(k2)
	var x = lerp(minX * (1 + randf() * randomness), maxX * (1 + randf() * randomness), kx)
	var y = lerp(minY * (1 + randf() * randomness), maxY * (1 + randf() * randomness), ky)
	return Vector2(x, y)
