extends Node2D
class_name YummySpawner


var spawn_rate: float
@export var yummy_scene: PackedScene
@export var yummy_spawn_node: Node2D
@export var timer: Timer
@export var range: int = 50


func _ready() -> void:
	update_spawn_rate()


func _on_timer_timeout() -> void:
	print("timeout")
	print(timer.wait_time)
	spawn_yummy()
	timer.wait_time = randf_range(1/spawn_rate - 0.3, 1/spawn_rate + 0.3)


func spawn_yummy():
	var yummy: Yummy = yummy_scene.instantiate()
	# do other stuff
	var pos: Vector2 = Vector2()
	pos.x = randf_range(-range, range) + position.x
	pos.y = randf_range(-range, range) + position.y
	yummy.position = pos
	yummy_spawn_node.add_child(yummy)


func update_spawn_rate():
	timer.wait_time = 120/GlobalData.yummies_rate
