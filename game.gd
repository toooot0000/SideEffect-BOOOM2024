extends Node2D
class_name G

@export var _radius := 230
@export var _initlevelTarget := 200
@export var _levelTargetGrowth := 100

@onready var _center :Node2D = $BG
@onready var _player :Player = $Player
@onready var _enemySpawnerManager: EnemySpawnerManager = $EnemySpawnerManager
@onready var _bullets :Array = U.getAllResUnderDir("res://bullet/configs/")

static var shared: G

enum State { Launch, Idle, End, Pause }

signal startTimeChangedFromTo(o, n)
signal stateChangedFromTo(o, n)
signal remainingTimeChangedFromTo(o, n)
signal currentTargetPointChangedFromTo(o, n)

signal gameStart
signal gameOver
signal levelClear
signal enterNewLevel

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
		var ret :Array[BulletConfig]= []
		for obj in shared._bullets:
			ret.append(obj as BulletConfig)
		return ret

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

var __state := State.Launch
var _state: State:
	set(v):
		U.makeGetter(self, "__state").call(v)
		match v:
			State.End:
				gameOver.emit()
	get:
		return __state

var __remainingTime := 60.0
var _remainingTime := 60.0:
	set(v):
		U.makeGetter(self, "__remainingTime").call(v)
	get:
		return __remainingTime


var __currentTargetPoint :int
var _currentTargetPoint :int :
	set(v):
		U.makeGetter(self, "__currentTargetPoint").call(v)
	get:
		return __currentTargetPoint

func _init():
	if G.shared == null :
		G.shared = self
	else:
		queue_free()
	randomize()

func _ready():
	_currentTargetPoint = _initlevelTarget

func _process(_delta):
	if _state != State.Idle:
		return
	var cur = Time.get_ticks_msec()
	_remainingTime = (60.0 - (cur - startTime)/1000.0)
	if _remainingTime > 0:
		return
	_state = State.End

func _input(event):
	if event is InputEventKey:
		var keyInput = event as InputEventKey
		if !keyInput.is_released():
			return
		if keyInput.keycode == KEY_F:
			_state = State.End
		elif keyInput.keycode == KEY_ESCAPE:
			_state = State.Pause

func start():
	
	player.hpLimit = 10
	player.hp = 10
	player.point = 0
	player.global_position = center

	_currentTargetPoint = _initlevelTarget

	startTime = Time.get_ticks_msec()

	_state = State.Idle
	gameStart.emit()



func _on_player_point_changed_from_to(_old:Variant, newPoint:Variant):
	if newPoint >= _currentTargetPoint:
		_state = State.Pause
		levelClear.emit()



func _on_player_hp_changed_from_to(_old:Variant, new:Variant):
	if new > 0:
		return 
	_state = State.End


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_start_btn_pressed():
	start()

func _on_resume_btn_pressed():
	_state = State.Idle

func _on_restart_btn_pressed():
	start()

func _on_next_lv_btn_pressed():

	var bullet = ($UI/LevelClear as LevelClear).chosenBullet
	if bullet != null:
		player.getNewBullet(bullet)

	player.hpLimit = 10
	player.hp = 10
	player.point = 0
	player.global_position = center

	startTime = Time.get_ticks_msec()
	_currentTargetPoint += _levelTargetGrowth

	_state = State.Idle
	enterNewLevel.emit()