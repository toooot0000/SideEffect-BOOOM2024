extends  Node2D
class_name PickableManager

class PickableScenes:
	extends Resource
	var type: Pickable.Type
	var scene: PackedScene

@export var packedScenes: Array[PickableScenes]

var activePickables: Array[Pickable.Type] = []

static var shared: PickableManager

func _init():
	if shared: 
		queue_free()
	else:
		shared = self

func generatePickable(type: Pickable.Type):
	var packedScene :PackedScene
	for i in packedScenes:
		if i.type == type:
			packedScene = i.scene
			break
	if !packedScene:
		return
	var inst = packedScene.instantiate()
	
	add_child(inst)

