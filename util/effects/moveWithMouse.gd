extends PositionBasedEffect
class_name MoveWithMouse


@export var moveRange := 20.0
@export var maxRangeThreshold := 200.0

func _input(event):
	if !active: return
	if event is InputEventMouse:
		var mouseEvt = event as InputEventMouse
		var mousePosition = mouseEvt.position if !useGlobalPosition else mouseEvt.global_position
		var pPos = get_parent_position()
		if pPos == null:
			return 
		var diff = mousePosition - pPos
		var lerped = lerp(0.0, moveRange, clampf(diff.length(), 0.0, maxRangeThreshold)/maxRangeThreshold)
		set_parent_position(_originPosition + lerped * diff.normalized())