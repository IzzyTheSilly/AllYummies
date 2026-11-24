extends Node2D
class_name ChummySpawner


@export var chummy_scene: PackedScene
@export var timer: Timer
@export var range: int = 300
@export var chummy_parent_node: Node2D


func _ready() -> void:
	timer.wait_time = 60/GlobalData.chummies_rate


func _on_timer_timeout() -> void:
	var chummy: Chummy = chummy_scene.instantiate()
	chummy.position = Vector2(randi_range(-range, range), randi_range(-range, range)) + position
	chummy_parent_node.add_child(chummy)
