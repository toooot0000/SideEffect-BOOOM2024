extends Panel

@onready var player := $AnimationPlayer as AnimationPlayer

signal click_start

func _on_start_button_button_up():
	player.play("click_start")
	await player.animation_finished
	visible = false
	click_start.emit()


func _on_quit_button_button_up():
	player.play("click_quit")
	await player.animation_finished
	get_tree().quit()
