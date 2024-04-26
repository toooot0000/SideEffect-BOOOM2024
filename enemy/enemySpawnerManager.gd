class_name EnemySpawnerManager
extends Node2D

@export var spawnerScene: PackedScene
@export var enemyScene: PackedScene

func spawnEnemyFrom(bullet: Bullet):
	var new = spawnerScene.instantiate() as EnemySpawner
	add_child(new)
	new.makeSpawnCurve(bullet.global_position)
	await new.shouldSpawnEnemyAt
	var enemy := enemyScene.instantiate() as Node2D
	enemy.global_position = new.spawnGlobalPosition
	G.bg.reRipple(new.spawnGlobalPosition)
	G.shared.add_child(enemy)
	new.queue_free()
