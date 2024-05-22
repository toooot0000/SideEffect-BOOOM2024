extends Line2D

@onready var marker0 = $Marker2D as Node2D
@onready var marker1 = $Marker2D2 as Node2D

func _process(_delta):
	set_point_position(0, marker0.position)
	set_point_position(1, marker1.position)
