extends Panel
class_name LevelClear

@export var cardScene :PackedScene
@export var cards :Array[FlipCard] = []

var candidatesBullets = []
var chosenIndex = -1 : 
	set(v):
		chosenIndex = v
		updateHightlight()


func _ready():
	await G.shared.ready
	updateReward()

func updateReward():
	var bullets = G.bullets
	candidatesBullets = [U.rand(bullets), U.rand(bullets)]
	for i in range(len(candidatesBullets)):
		cards[i].bulletConfig = candidatesBullets[i]

func _on_card2_gui_input(event:InputEvent):
	if !(event is InputEventMouseButton):
		return
	if event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		if chosenIndex == 1:
			chosenIndex = -1
		else:
			chosenIndex = 1


func _on_card1_gui_input(event:InputEvent):	
	if !(event is InputEventMouseButton):
		return
	if event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		if chosenIndex == 0:
			chosenIndex = -1
		else:
			chosenIndex = 0

func updateHightlight():
	if chosenIndex == -1:
		$Selected.visible = false
		return
	$Selected.visible = true
	$Selected.global_position = cards[chosenIndex].global_position + cards[chosenIndex].size * 0.5 - $Selected.size * 0.5
	pass
