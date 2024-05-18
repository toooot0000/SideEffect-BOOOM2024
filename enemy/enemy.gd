extends Node2D
class_name Enemy

@export var spd: float = 50

@onready var hpBar: ProgressBar = $ProgressBar
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var sprite  := $Sprite as Sprite2D
@onready var colored := preload("res://mats/colored.tres").duplicate() as ShaderMaterial

signal didDie

var enemyConfig: EnemyConfig
var hpUplimit = 5
var _tweenHolder = U.TweenHolder.new() 

var hp = 5:
	set(value):
		hp = value
		hpBar.value = hp / float(hpUplimit) * 100
		if hp <= 0:
			animator.play("die")
			$Label.text = "+%d" % (enemyConfig.point * G.player.pointFactor)
			await animator.animation_finished
			G.player.point += enemyConfig.point * G.player.pointFactor
			didDie.emit()
			queue_free()


var _spawnTimer :Timer

func _ready():
	hpBar.value = 100
	_spawnTimer = Timer.new()
	add_child(_spawnTimer)
	_spawnTimer.one_shot = true
	_spawnTimer.start(.1)
	($AnimationPlayer as AnimationPlayer).play("spawned")
	await animator.animation_finished
	animator.play("walking")
	ready.emit()


func _process(delta):
	if hp <= 0:
		return
	var playerPos = G.player.global_position
	var dir = (playerPos - global_position).normalized()
	var vel = dir * spd
	global_position += vel * delta
	
	if G.state != G.State.Idle:
		queue_free()


func _on_area_2d_area_entered(area:Area2D):
	if _spawnTimer.time_left > 0:
		return
	if hp <= 0:
		return
	var bullet = area.get_parent() as Bullet
	if bullet != null:
		hp -= bullet.config.bulletDamage

		var prevMat = sprite.material
		sprite.material = colored
		colored.set_shader_parameter("color", Color.RED)
		var tween := _tweenHolder.create(self)
		tween.tween_callback(func():
			sprite.material = prevMat	
		).set_delay(0.1)
	