extends Button
class_name CommonButton

signal pressedOn(btn: CommonButton)

func _ready():
	pressed.connect(func(): 
		pressedOn.emit(self)	
	)
