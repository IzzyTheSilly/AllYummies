extends CharacterBody2D
class_name Entity


@export var cutscenes: Array[CutsceneData]


func _on_interact():
	for cutscene: CutsceneData in cutscenes:
		if await CutsceneHandler.show_cutscene(cutscene) == 1:
			continue
		else:
			break
