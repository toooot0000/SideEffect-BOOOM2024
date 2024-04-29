extends CenterContainer
class_name PointItem


signal animation_finished(anim_name)

func _ready():
	($AnimationPlayer as AnimationPlayer).speed_scale = 1 + 0.2 * (randf() - 0.5)

func _on_animation_player_animation_finished(anim_name):
	animation_finished.emit(anim_name)
