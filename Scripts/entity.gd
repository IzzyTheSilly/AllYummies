extends Area2D
class_name Entity


@export var cutscene: CutsceneData


func _on_interact():
	CutsceneHandler.show_cutscene(cutscene)
