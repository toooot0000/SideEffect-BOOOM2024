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
	G.player.pointChangedFromTo.connect(func(_o:int, point: int):
		pointLabel.text = "Point: %d" % point
	)

	G.player.hpChangedFromTo.connect(func(_o:int, n:int):
		($HpBar as ProgressBar).value = float(n) / G.player.hpLimit * 100
		($HpBar/HpLabel as Label).text = "%d / %d" % [n, G.player.hpLimit]
	)
