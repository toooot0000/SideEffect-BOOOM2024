extends Control
class_name UI

@onready var _pointLabel :Label = $PointLabel

static var shared: UI

static var pointLabel: Label:
	get:
		return shared._pointLabel

func _init():
	if shared != null:
		queue_free()
		return
	shared = self

func _ready():
	# point 
	call_deferred("_connectSignals")


func _connectSignals():
	G.player.point_changed.connect(func(point: int):
		pointLabel.text = "Point: %d" % point
	)
