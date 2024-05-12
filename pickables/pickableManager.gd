extends  Node2D
class_name PickableManager

@export var packedScenes: Array[PickableScene]

var activePickables: Array[Pickable.Type] = []

static var shared: PickableManager

func _init():
	if shared: 
		queue_free()
	else:
		shared = self

func _ready():
	await G.shared.ready
	EnemySpawnerManager.shared.enemySpawned.connect(func(enemy: Enemy):
		enemy.didDie.connect(func():
			if randf() < 0.1:
				randPickable()
		, CONNECT_ONE_SHOT)
	)


func randPickable():
	generatePickable(U.rand([Pickable.Type.Star, Pickable.Type.Ice, Pickable.Type.Heart]))

func generatePickable(type: Pickable.Type):
	var packedScene :PackedScene
	for i in packedScenes:
		if i.type == type:
			packedScene = i.scene
			break
	if !packedScene:
		return
	var inst = packedScene.instantiate() as Node2D
	inst.global_position = U.randInCicle(G.center, G.radius)
	add_child(inst)

