extends Area2D
class_name CutsceneTrigger


@export var cutscene: CutsceneData
var has_triggered: bool = false


func _ready() -> void:
	body_entered.connect(triggered)


func triggered():
	if !has_triggered:
		CutsceneHandler.show_cutscene(cutscene)
		has_triggered = true
