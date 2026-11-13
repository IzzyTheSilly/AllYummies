extends Node2D
class_name YummySpawner


@export var spawn_areas: Array[Area2D]
@export var yummy_scene: PackedScene
var game_area: Node2D


func _ready() -> void:
	game_area = get_parent()


func _on_timer_timeout() -> void:
	spawn_yummy()


func spawn_yummy():
	var yummy: Yummy = yummy_scene.instantiate()
	# do other stuff
	var pos = Vector2()
	pos.x = randf_range(-150, 150)
	pos.y = randf_range(-150, 150)
	yummy.position = pos
	game_area.add_child(yummy)
