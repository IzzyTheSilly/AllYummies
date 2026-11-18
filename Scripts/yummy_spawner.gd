extends Node2D
class_name YummySpawner


@export var spawn_rate: float = 1
@export var spawn_areas: Array[Area2D]
@export var yummy_scene: PackedScene
@export var timer: Timer


func _ready() -> void:
	timer.wait_time = 1/spawn_rate


func _on_timer_timeout() -> void:
	print("timeout")
	print(timer.wait_time)
	spawn_yummy()
	timer.wait_time = randf_range(1/spawn_rate - 0.3, 1/spawn_rate + 0.3)


func spawn_yummy():
	var yummy: Yummy = yummy_scene.instantiate()
	# do other stuff
	var pos = Vector2()
	pos.x = randf_range(-150, 150)
	pos.y = randf_range(-150, 150)
	yummy.position = pos
	add_child(yummy)
