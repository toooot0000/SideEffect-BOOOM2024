extends Panel

@onready var player := $AnimationPlayer as AnimationPlayer

func _on_start_button_button_up():
	player.play("click_start")


func _on_quit_button_button_up():
	player.play("click_quit")
