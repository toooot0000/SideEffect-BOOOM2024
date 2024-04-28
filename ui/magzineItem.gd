extends CenterContainer
class_name MagzineItem

@export var time := 0.2 :
	set(value):
		time = value
		anim.speed_scale = 1 / value

@onready var anim: AnimationPlayer = $AnimationPlayer

func used():
	anim.play("used")