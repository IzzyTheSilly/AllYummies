extends Node2D
class_name ChummySpawner


@export var chummy_scene: PackedScene
@export var timer: Timer
@export var range: int = 300
@export var chummy_parent_node: Node2D


func _ready() -> void:
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)
	timer.stop()
	timer.wait_time = 60/GlobalData.chummies_rate
	for i in range(GlobalData.start_chummies):
		spawn_chummy()


func start():
	timer.start()


func end():
	timer.stop()


func _on_timer_timeout() -> void:
	spawn_chummy()


func spawn_chummy():
	var chummy: Chummy = chummy_scene.instantiate()
	chummy.position = Vector2(randi_range(-range, range), randi_range(-range, range)) + position
	chummy_parent_node.add_child(chummy)
