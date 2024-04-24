class_name EnemySpawner
extends Path2D

@export var a := 100.0
@export var b := 300.0
@export var c := 60.0
@export var randRangeInDeg := 10.0

var spawnGlobalPosition: Vector2

signal shouldSpawnEnemyAt(position)

func cross(v:Vector2, vup: Vector3 = Vector3.BACK) -> Vector2:
	var ret = Vector3(v.x, v.y, 0).cross(vup)
	ret = Vector2(ret.x, ret.y).normalized()
	return ret

func makeSpawnCurve(bulletGlobalPosition: Vector2):
	($PathFollow2D as PathFollow2D).progress_ratio = 0
	($AnimationPlayer as AnimationPlayer).stop()
	($AnimationPlayer as AnimationPlayer).play("follow_path")
	var center = G.center
	var d1 := (bulletGlobalPosition - G.center).normalized()
	var ang := d1.angle()
	var d2 := Vector2.from_angle(randf_range(ang + PI - randRangeInDeg * 0.5 / PI, ang + PI + randRangeInDeg * 0.5 / PI))
	
	var p1 := bulletGlobalPosition
	var p2 := d2 * G.radius + G.center

	spawnGlobalPosition = p2

	var q1out := d1 * a
	var q2in := d2 * a

	var d3 := (d1 + d2).normalized()
	var up = Vector3(d1.x, d1.y, 0).cross(Vector3(d2.x, d2.y, 0)).normalized()
	var d3x := cross(d3, up)
	var p3 := d3 * b * (1 + randf() * 0.2) + G.center
	var q3in = d3x * c
	var q3out = -d3x * c

	curve.clear_points()
	curve.point_count = 5

	curve.set_point_position(0, p1)
	curve.set_point_out(0, q1out * (1 + randf() * 0.2))

	var pp = (p1 + p3 - 2 * G.center).normalized()
	var ppx = cross(pp, up)
	curve.set_point_in(1, ppx * c * (1 + randf() * 0.2))
	curve.set_point_position(1, pp * b* (1 + randf() * 0.2) + G.center)
	curve.set_point_out(1, -ppx * c * (1 + randf() * 0.2))
	
	curve.set_point_in(2, q3in* (1 + randf() * 0.2))
	curve.set_point_position(2, p3)
	curve.set_point_out(2, q3out* (1 + randf() * 0.2))

	pp = (p2 + p3 - 2 * G.center).normalized()
	ppx = cross(pp, up)
	curve.set_point_in(3, ppx * c* (1 + randf() * 0.2))
	curve.set_point_position(3, pp * b* (1 + randf() * 0.2) + G.center)
	curve.set_point_out(3, -ppx * c* (1 + randf() * 0.2))

	curve.set_point_in(4, q2in* (1 + randf() * 0.2))
	curve.set_point_position(4, p2)

func _on_animation_player_animation_finished(_anim_name:StringName):
	shouldSpawnEnemyAt.emit(spawnGlobalPosition)
