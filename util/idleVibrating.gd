extends Node
class_name  IdleVibrating

@export var vibrateRange :float = 0.6
@export var freqency := 15
@export var useGlobalPosition := false :
	set(val):
		useGlobalPosition = val
		if val:
			_positionProperty = "global_position"
		else:
			_positionProperty = "position"

@export var active := false :
	set(val):
		active = val
		if active && get_parent():
			var pos = get_parent().get(_positionProperty)
			if pos is Vector2:
				_originPosition = pos as Vector2

var _timer := 0.0
var _originPosition :Vector2
var _positionProperty := "global_position"

func _ready():
	await get_parent().ready
	if active:
		var pos = get_parent().get(_positionProperty)
		if pos is Vector2:
			_originPosition = pos as Vector2


func _process(delta):
	if !active:
		return
	_timer += delta
	if _timer >= 1.0/freqency:
		_timer = 0
		var pos = get_parent().get(_positionProperty)
		if pos == null:
			return
		var offset = _randDir() * vibrateRange
		get_parent().set(_positionProperty, _originPosition + offset)
		print("Vibrate from %s to %s" %[pos, get_parent().get("position")])


func _randDir() -> Vector2:
	var theta = randf_range(0, 2 * PI)
	return Vector2(cos(theta), sin(theta))
