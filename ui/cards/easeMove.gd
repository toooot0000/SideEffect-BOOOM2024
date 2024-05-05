extends Node
class_name EaseMove


@export var maxSpd := 200.0
@export var maxRange := 20.0
@export var tolerance := 5.0
@export var spdCurve : Curve

var enable := false
var targetPosition: Vector2

var positionSetter: Callable
var positionGetter: Callable

func _process(delta):
	if !enable:
		return 
	
	var position = positionGetter.call() as Vector2
	var dist = targetPosition - position
	var i := clamp(dist.length() / maxRange, 0, 1) as float
	if spdCurve != null:
		i = spdCurve.sample(i)
	var spd = i * maxSpd
	var nextPosition = position + dist.normalized()*spd * delta
	if (nextPosition - targetPosition).length() <= tolerance:
		positionSetter.call(targetPosition)
	else:
		positionSetter.call(nextPosition)