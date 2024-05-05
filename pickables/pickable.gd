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
			for e in get_tree().get_nodes_in_group("enemy"):
				var enemy = e as Enemy
				enemy.hp = enemy.enemyConfig.enemyLife
		Type.Star:
			
			pass
		Type.Ice:
			Engine.time_scale = 0.5
			await get_tree().create_timer(2).timeout
			Engine.time_scale = 1
			pass


