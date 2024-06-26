class_name EnemySpawnerManager
extends Node2D

signal enemySpawned(enemy: Enemy)

static var shared: EnemySpawnerManager

@export var spawnerScene: PackedScene
@export var enemyScene: PackedScene

func _init():
	if shared:
		queue_free()
	else:
		shared = self


func spawnEnemyFrom(bullet: Bullet):
	var new = spawnerScene.instantiate() as EnemySpawner
	add_child(new)
	new.makeSpawnCurve(bullet)
	var config := bullet.config.relatedEnemy
	await new.shouldSpawnEnemyAt
	var enemy := config.scene.instantiate() as Enemy
	enemy.global_position = new.spawnGlobalPosition
	G.bg.reRipple(new.spawnGlobalPosition)
	G.shared.add_child(enemy)
	new.queue_free()
	await enemy.ready
	enemy.hpUplimit = config.enemyLife
	enemy.hp = config.enemyLife
	enemy.enemyConfig = config
	enemySpawned.emit(enemy)
