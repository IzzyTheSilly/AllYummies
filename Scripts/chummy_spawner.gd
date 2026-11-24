extends Node2D
class_name ChummySpawner


@export var chummy_scene: PackedScene
@export var timer: Timer
@export var range_x: int = 500
@export var range_y: int = 200
@export var chummy_parent_node: Node2D


func _ready() -> void:
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)
	timer.stop()
	timer.wait_time = 60/GlobalData.chummies_rate
	GlobalData.chummies_added.connect(_on_chummies_added)
	for i in range(GlobalData.start_chummies):
		spawn_chummy()


func start():
	timer.start()


func end():
	timer.stop()


func _on_timer_timeout() -> void:
	spawn_chummy()


func _on_chummies_added(amount: int):
	for i in range(amount):
		spawn_chummy()


func spawn_chummy():
	var chummy: Chummy = chummy_scene.instantiate()
	chummy.position = Vector2(randi_range(-range_x, range_x), randi_range(-range_y, range_y)) + position
	chummy_parent_node.add_child(chummy)
