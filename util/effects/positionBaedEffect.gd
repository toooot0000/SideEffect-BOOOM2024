extends Node
class_name PositionBasedEffect


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


var _originPosition :Vector2
var _positionProperty := "global_position"


func _ready():
	await get_parent().ready
	if active:
		var pos = get_parent().get(_positionProperty)
		if pos is Vector2:
			_originPosition = pos as Vector2

func get_parent_position():
	var p = get_parent()
	if !p : return null
	return p.get(_positionProperty)

func set_parent_position(newPosition: Vector2):
	var p = get_parent()
	if !p: return
	p.set(_positionProperty, newPosition)