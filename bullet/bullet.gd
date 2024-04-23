extends Node2D
class_name Bullet

@export var spd: = 300
@export_file("*.tscn") var enemyPath: String

@onready var enemyScene := load(enemyPath) as PackedScene
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
	var enemy := enemyScene.instantiate() as Node2D
	enemy.global_position = global_position
	G.shared.add_child(enemy)
	G.bg.ripple(position)
	queue_free()
	isDeleted = true


func _on_area_2d_area_entered(_area:Area2D):
	($Sprite as Sprite2D).visible = false
	($Area2D as Area2D).monitoring = false
	dir = Vector2.ZERO
	part.restart()
	await part.finished
	queue_free()