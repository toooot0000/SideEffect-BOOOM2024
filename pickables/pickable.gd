extends Sprite2D
class_name Pickable

enum Type{ Heart, Star, Ice }

signal triggerPickable(type: Type)

@export var type: Type = Type.Heart

func _on_area_2d_area_entered(area:Area2D):
	if !area.is_in_group("player"):
		return
	triggerPickable.emit(type)

	match type:
		Type.Heart:
			G.player.hp = G.player.hpLimit

		Type.Star:
			G.player.pointFactor *= 2
			G.player.damageFactor *= 2
			var task = ScheduleExecutor.ExecuteItem.new()
			task.start(3, func():
				var ind = PickableManager.shared.activePickables.find(Type.Star)
				if ind != -1:
					PickableManager.shared.activePickables.remove_at(ind)
				G.player.pointFactor /= 2
				G.player.damageFactor /= 2
			)
			PickableManager.shared.activePickables.append(type)

		Type.Ice:
			Engine.time_scale *= 0.6
			var task = ScheduleExecutor.ExecuteItem.new()
			task.start(3, func():
				Engine.time_scale /= 0.6
			)

	queue_free()

