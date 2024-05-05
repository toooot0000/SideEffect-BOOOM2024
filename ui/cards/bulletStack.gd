extends Control
class_name BulletStack

@export var start:Marker2D
@export var end:Marker2D
@export var dist := 10.0
@export var card: PackedScene
@export var container :Control

@onready var anim := $AnimationPlayer as AnimationPlayer
@onready var dir: Vector2 = (end.position - start.position).normalized()

var topCard: FlipCard :
	get:
		var count = container.get_child_count()
		var last = container.get_child(count - 1) as FlipCard
		return last 

func _on_player_did_add_new_bullet(_bulletInfo:Array[Player.BulletInfo], added:Player.BulletInfo):
	var inst = card.instantiate() as FlipCard
	inst.bulletConfig = added.config
	container.add_child(inst)
	inst.newlyAdded(_positionOfIdx(len(_bulletInfo)-1, len(_bulletInfo)))
	_updateCardPosition()


func _updateCardPosition():
	for i in range(container.get_child_count()):
		var ch = container.get_child(i) as FlipCard
		var targetPos = _positionOfIdx(i, container.get_child_count())
		ch.position = targetPos

func _on_player_shoot_bullet(direction:Vector2, bulletConfig:BulletConfig, indexOfMag:int):
	var count = container.get_child_count()
	var last = container.get_child(count - 1) as FlipCard
	last._on_player_shoot_bullet(direction, bulletConfig, indexOfMag)


func _positionOfIdx(ind: int, total: int) -> Vector2:
	return float(ind) * dir * dist + start.position


func _on_player_start_reload(time:Variant):
	topCard._on_player_start_reload(time)


func _on_player_shoot_in_reload():
	topCard._on_player_shoot_in_reload()


func _on_player_shift_bullet(_bulletInfo:Array[Player.BulletInfo]):
	

	pass
