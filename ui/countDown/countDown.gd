extends Label

@onready var shaker := $Shaker as Shaker

var _countDownTime := 0
var _start := -1.0

func _process(_delta):
	var n = G.remainingTime
	text = "%d" % ceili(n)
	if n <= 10 && shaker.is_stopped() && (_start == -1 || _start - n >= 1):
		shaker.wait_time = 0.1 * (_countDownTime)
		_start = n
		var curPos = position
		shaker.startShake(func (_i, pos):
			position = curPos + pos
		)

func _on_shaker_timeout():
	_countDownTime += 1
