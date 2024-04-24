extends Node2D
class_name G

@export var _radius := 230

@onready var _center :Node2D = $BG
@onready var _player :Player = $Player
@onready var _enemySpawnerManager: EnemySpawnerManager = $EnemySpawnerManager

static var shared: G

func _init():
	if G.shared == null :
		G.shared = self
	else:
		queue_free()
	randomize()

# global
static var center: Vector2:
	get:
		return G.shared._center.global_position

static var radius: float:
	get:
		return G.shared._radius

static func isInsideCircle(testingPosition: Vector2) -> bool:
	return (testingPosition - center).length() <= radius

static func clampInsideCircle(origin: Vector2) -> Vector2:
	var dir = origin - center
	return center + min(dir.length(), radius) * dir.normalized()

static var player: Player:
	get:
		return G.shared._player

static var bg: BG:
	get:
		return shared._center

static var enemySpawnerManager: EnemySpawnerManager:
	get:
		return shared._enemySpawnerManager