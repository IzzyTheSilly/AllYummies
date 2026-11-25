extends Node2D
class_name YummySpawner


var spawn_rate: float
@export var yummy_scene: PackedScene
@export var yummy_spawn_node: Node2D
@export var timer: Timer
@export var range_x: int = 500
@export var range_y: int = 200


func _ready() -> void:
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)
	GameManager.yummy_spawner = self
	update_spawn_rate()
	timer.stop()
	for i in range(GlobalData.start_yummies):
		spawn_yummy()


func start():
	timer.start()


func end():
	timer.stop()


func _on_timer_timeout() -> void:
	var yummy: Yummy = spawn_yummy()
	yummy.start()
	update_spawn_rate()
	timer.start(randf_range(1/spawn_rate - 0.3, 1/spawn_rate + 0.3))


func spawn_yummy() -> Yummy:
	var yummy: Yummy = yummy_scene.instantiate()
	var pos: Vector2 = Vector2()
	pos.x = randf_range(-range_x, range_x) + position.x
	pos.y = randf_range(-range_y, range_y) + position.y
	yummy.position = pos
	yummy_spawn_node.add_child(yummy)
	GlobalData.add_yummy(yummy)
	return yummy


func spawn_yummy_in_inventory():
	print("spawn yummy in inventory")
	var yummy: Yummy = spawn_yummy()
	yummy.change_state(Yummy.BehaviourState.COLLECTED)
	GlobalData.add_collected_yummy(yummy)


func update_spawn_rate():
	timer.wait_time = 60/GlobalData.yummies_rate
