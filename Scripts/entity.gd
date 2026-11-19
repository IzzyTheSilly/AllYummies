extends CharacterBody2D
class_name Entity


@export var cutscene_ids: Array[String]


func _on_interact():
	for cutscene_id: String in cutscene_ids:
		if await CutsceneHandler.show_cutscene(cutscene_id) == 1:
			continue
		else:
			break
