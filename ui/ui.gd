extends Control
class_name UI

@export var pointItem: PackedScene

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
		var inst = pointItem.instantiate() as PointItem
		inst.point = point - _o
		$PointLabel/VBoxContainer.add_child(inst)
		await inst.animation_finished
		inst.queue_free()
		pointLabel.text = "当前分数: %d" % point
	)

	G.player.hpChangedFromTo.connect(func(_o:int, n:int):
		($HpBar as ProgressBar).value = float(n) / G.player.hpLimit * 100
		($HpBar/HpLabel as Label).text = "%d / %d" % [n, G.player.hpLimit]
		var pos = $HpBar.position
		($HpBar/Shaker as Shaker).startShake(func(_i, p):
			$HpBar.position = pos + p
		)
	)


func _on_game_game_over():
	$GameOver.visible = true


func _on_game_game_start():
	$GameOver.visible = false

func show_dialog(on: Node, dialog: NodePath):
	on.get_node(dialog).visible = true

func hide_dialog(on: Node, dialog: NodePath):
	on.get_node(dialog).visible = false


func _on_game_state_changed_from_to(_o:Variant, n:G.State):
	match n:
		G.State.Pause:
			pass
