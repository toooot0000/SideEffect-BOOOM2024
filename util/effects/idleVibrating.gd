extends PositionBasedEffect
class_name  IdleVibrating

@export var vibrateRange :float = 0.6
@export var freqency := 15


var _timer := 0.0

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
