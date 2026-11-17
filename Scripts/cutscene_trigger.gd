extends Area2D
class_name CutsceneTrigger


@export var multi_trigger: bool = false
@export var cutscene: CutsceneData
var has_triggered: bool = false
@export var requirements: Dictionary[int, bool]


func _ready() -> void:
	body_entered.connect(triggered)
	collision_layer = 0b0100
	collision_mask = 0b0001


func triggered(body: Node2D):
	print(GlobalData.flags[0])
	if !check_requirements():
		return
	
	if !has_triggered or multi_trigger:
		CutsceneHandler.show_cutscene(cutscene)
		has_triggered = true


func check_requirements() -> bool:
	for key in requirements:
		if GlobalData.flags[key] != requirements[key]:
			return false
	return true
