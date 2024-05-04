class_name BulletConfig
extends Resource

@export_category("Basic")
@export var bulletDamage := 1
@export var magazineSize := -1
@export var reloadTime := 1.0

@export var displayTexture: Texture2D
@export var bulletPackedScene: PackedScene

@export var relatedEnemy: EnemyConfig