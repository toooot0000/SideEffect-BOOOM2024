class_name EnemySpawnerManager
extends Node2D

@export var spawnerScene: PackedScene
@export var enemyScene: PackedScene

func spawnEnemyFrom(bulletPosition: Vector2):
	var new = spawnerScene.instantiate() as EnemySpawner
	add_child(new)
	new.makeSpawnCurve(bulletPosition)
	await new.shouldSpawnEnemyAt
	var enemy := enemyScene.instantiate() as Node2D
	enemy.global_position = new.spawnGlobalPosition
	G.bg.reRipple(new.spawnGlobalPosition)
	G.shared.add_child(enemy)
	new.queue_free()
