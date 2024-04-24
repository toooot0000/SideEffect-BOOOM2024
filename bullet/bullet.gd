extends Node2D
class_name Bullet

@export var spd: = 400

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var part: GPUParticles2D = $GPUParticles2D

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
	G.bg.ripple(position)
	G.enemySpawnerManager.spawnEnemyFrom(global_position)
	queue_free()
	isDeleted = true


func _on_area_2d_area_entered(_area:Area2D):
	($Sprite as Sprite2D).visible = false
	($Area2D as Area2D).monitoring = false
	dir = Vector2.ZERO
	part.restart()
	await part.finished
	queue_free()
