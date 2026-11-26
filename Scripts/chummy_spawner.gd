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
	GlobalData.chummies_rate_changed.connect(_on_chummies_rate_changed)
	timer.stop()
	GlobalData.chummies_added.connect(_on_chummies_added)
	for i in range(GlobalData.start_chummies):
		GlobalData.add_chummy(1)


func start():
	update_timer_wait_time()


func end():
	timer.stop()


func _on_timer_timeout() -> void:
	update_timer_wait_time()
	GlobalData.add_chummy(1)


func update_timer_wait_time():
	if GlobalData.chummies_rate:
		timer.wait_time = 60/GlobalData.chummies_rate
		timer.start()
	else:
		timer.stop()


func _on_chummies_added(amount: int):
	for i in range(amount):
		spawn_chummy().start()


func _on_chummies_rate_changed(amount: float):
	var old_wait_time: float = timer.wait_time
	var new_wait_time: float = old_wait_time
	if GlobalData.chummies_rate:
		new_wait_time = 60/GlobalData.chummies_rate
	
	timer.start(max(timer.time_left - (old_wait_time - new_wait_time), 0.1))


func spawn_chummy() -> Chummy:
	var chummy: Chummy = chummy_scene.instantiate()
	chummy.position = Vector2(randi_range(-range_x, range_x), randi_range(-range_y, range_y)) + position
	chummy_parent_node.add_child(chummy)
	return chummy
