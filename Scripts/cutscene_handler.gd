extends Node

signal dialogue_accepted

var dialogue_box: DialogueBox
var in_cutscene: bool = false
var dialogue_has_finished: bool = true


func show_cutscene(cutscene: CutsceneData):
	in_cutscene = true
	for i in range(cutscene.dialogues.size()):
		show_dialogue(cutscene.dialogues[i])
		await dialogue_accepted
	in_cutscene = false


func show_dialogue(dialogue: DialogueData):
	if !dialogue_box:
		return
	
	dialogue_has_finished = false
	dialogue_box.change_portrait(dialogue.portrait)
	dialogue_box.change_blip(dialogue.blip)
	dialogue_box.show()
	dialogue_box.show_text(dialogue.text, dialogue.text_speed)


func show_dialogue_choice(dialogue_choice: DialogueChoiceData):
	pass


func hide_dialogue():
	if dialogue_has_finished:
		dialogue_box.hide()
		dialogue_accepted.emit()
	else:
		skip_current_dialogue()


func skip_current_dialogue():
	dialogue_box.skip_current_dialogue()


func finish_dialogue():
	dialogue_has_finished = true
