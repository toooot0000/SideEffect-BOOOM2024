extends Node2D
class_name G

@export var _radius := 230

@onready var _center :Node2D = $BG
@onready var _player :Player = $Player
@onready var _enemySpawnerManager: EnemySpawnerManager = $EnemySpawnerManager
@onready var _bullets :Array = U.getAllResUnderDir("res://bullet/configs/")

static var shared: G

enum State { Idle, End, Pause }

signal startTimeChangedFromTo(o, n)
signal stateChangedFromTo(o, n)
signal remainingTimeChangedFromTo(o, n)

signal gameOver
signal levelClear

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

static var bullets: Array[BulletConfig]:
	get:
		return shared._bullets

static var state: State:
	get:
		return shared._state

static var remainingTime: float:
	get:
		return shared._remainingTime


var startTime := 0:
	set(v):
		var o = startTime
		startTime = v
		startTimeChangedFromTo.emit(o, startTime)

var _state: State = State.Idle:
	set(v):
		var o = _state
		state = v
		stateChangedFromTo.emit(o, v)

var _remainingTime := 60.0:
	set(v):
		U.makeGetter(self, "_remainingTime").call(v)


func _init():
	if G.shared == null :
		G.shared = self
	else:
		queue_free()
	randomize()


func _ready():
	start()

func _process(_delta):
	if state != State.Idle:
		return
	var cur = Time.get_ticks_msec()
	_remainingTime = (60.0 - (cur - startTime)/1000.0)
	if _remainingTime > 0:
		return
	state = State.End
	gameOver.emit()


func start():
	
	player.hpLimit = 10
	player.hp = 10
	player.point = 0
	player.global_position = center

	startTime = Time.get_ticks_msec()


func _on_player_point_changed_from_to(_old:Variant, newPoint:Variant):
	if newPoint > 200:
		_state = State.Pause
		levelClear.emit()



func _on_player_hp_changed_from_to(_old:Variant, new:Variant):
	if new > 0:
		return 
	gameOver.emit()
	_state = State.End

