extends Node2D
class_name Bullet

@export var spd: = 200
@export_file("*.tscn") var enemyPath: String

@onready var enemyScene := load(enemyPath) as PackedScene

var dir := Vector2.ZERO
var isDeleted := false


func _process(delta):
	if isDeleted:
		return
	var vel = dir * spd
	position += vel * delta
	if !G.isInsideCircle(global_position):
		_turnIntoEnemy()
	global_position = G.clampInsideCircle(global_position)

func _turnIntoEnemy():
	var enemy := enemyScene.instantiate() as Node2D
	enemy.global_position = global_position
	G.shared.add_child(enemy)
	G.bg.ripple(position)
	queue_free()
	isDeleted = true
