extends Node
class_name ScheduleExecutor

class ExecuteItem:
	var startTimestamp: int
	var deadlineTimestamp: int
	var id: String
	var relatedNode: Node
	# (currentTime) -> Void
	var block: Callable
	
	func start(delayTimeInSec: float, task: Callable, executor: ScheduleExecutor = null):
		startTimestamp = Time.get_ticks_msec()
		deadlineTimestamp = startTimestamp + round(delayTimeInSec * 1000)
		block = task
		if executor:
			executor.scheduled.append(self)
		else:
			G.scheduler.scheduled.append(self)

var scheduled: Array[ExecuteItem] = []

func _process(_delta):
	var cur = Time.get_ticks_msec()
	for i in scheduled:
		if cur < i.deadlineTimestamp:
			i.block.callv([cur])
