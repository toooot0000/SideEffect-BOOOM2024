extends Node2D
class_name Enemy

@export var spd: float = 50

@onready var hpBar: ProgressBar = $ProgressBar
@onready var animator: AnimationPlayer = $AnimationPlayer

var enemyConfig: EnemyConfig
var hpUplimit = 5
 
var hp = 5:
	set(value):
		hp = value
		hpBar.value = hp / float(hpUplimit) * 100
		if hp <= 0:
			animator.play("die")
			await animator.animation_finished
			G.player.point += 5
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


func _on_area_2d_area_entered(area:Area2D):
	if _spawnTimer.time_left > 0:
		return
	if hp <= 0:
		return
	var bullet = area.get_parent() as Bullet
	if bullet != null:
		hp -= bullet.config.bulletDamage
