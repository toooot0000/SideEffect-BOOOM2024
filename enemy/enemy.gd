extends Node2D
class_name Enemy

@export var spd: float = 50

@onready var hpBar: ProgressBar = $ProgressBar
 
var hp = 5:
	set(value):
		hp = value
		hpBar.value = hp / float(hpUplimit) * 100
		if hp == 0:
			G.player.point += 5
			queue_free()

var hpUplimit = 5

var _spawnTimer :Timer

func _ready():
	hpBar.value = 100
	_spawnTimer = Timer.new()
	add_child(_spawnTimer)
	_spawnTimer.one_shot = true
	_spawnTimer.start(.5)


func _process(delta):
	var playerPos = G.player.global_position
	var dir = (playerPos - global_position).normalized()
	var vel = dir * spd
	global_position += vel * delta


func _on_area_2d_area_entered(area:Area2D):
	if _spawnTimer.time_left > 0:
		return
	if area.get_parent() is Bullet:
		# area.get_parent().queue_free()
		hp -= 1
