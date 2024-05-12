extends Node
class_name ScheduleExecutor

class ExecuteItem:
	var timer := 0.0
	var totalTime := 0.0
	var id: String
	var relatedNode: Node
	# (currentTime) -> Void
	var block: Callable
	
	func start(delayTimeInSec: float, task: Callable, executor: ScheduleExecutor = null):
		block = task
		totalTime = delayTimeInSec
		if executor:
			executor.scheduled.append(self)
		else:
			G.scheduler.scheduled.append(self)

var scheduled: Array[ExecuteItem] = []

func _process(delta):
	for i in scheduled:
		i.timer += delta
		if i.timer >= i.totalTime:
			i.block.call()
	
	scheduled = scheduled.filter(func(item):
		return item.timer < item.totalTime	
	)

func forceExecuteAll():
	for i in scheduled:
		i.block.call()
	scheduled.clear()