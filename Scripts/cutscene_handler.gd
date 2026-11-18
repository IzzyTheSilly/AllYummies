extends Node


var current_cutscene: CutsceneData

var dialogue_box: DialogueBox
var in_cutscene: bool = false
var in_dialogue_choice: bool = false
var dialogue_has_finished: bool = true


func show_cutscene(cutscene: CutsceneData):
	in_cutscene = true
	current_cutscene = cutscene
	if cutscene.dialogues:
		await handle_dialogue(0)
	
	if cutscene.set_flags:
		for key in cutscene.set_flags:
			GlobalData.flags[key] = cutscene.set_flags[key]
	in_cutscene = false


func handle_dialogue(index: int):
	await show_dialogue(current_cutscene.dialogues[index])
	if current_cutscene.dialogues[index].next_dialogue_index >= 0:
		await handle_dialogue(current_cutscene.dialogues[index].next_dialogue_index)
	elif current_cutscene.dialogues[index].next_dialogue_choice_index >= 0:
		await handle_dialogue_choice(current_cutscene.dialogues[index].next_dialogue_choice_index)


func handle_dialogue_choice(index: int):
	in_dialogue_choice = true
	var next_dialogue_index: int = await show_dialogue_choice(current_cutscene.dialogue_choices[index])
	if next_dialogue_index >= 0:
		in_dialogue_choice = false
		await handle_dialogue(next_dialogue_index)
	in_dialogue_choice = false


func show_dialogue(dialogue: DialogueData):
	if !dialogue_box:
		return
	
	dialogue_has_finished = false
	dialogue_box.portrait_area.show()
	dialogue_box.change_portrait(dialogue.portrait)
	dialogue_box.change_blip(dialogue.blip)
	dialogue_box.show()
	await dialogue_box.show_text(dialogue.text, dialogue.text_speed)


func show_dialogue_choice(dialogue_choice: DialogueChoiceData) -> int:
	if !dialogue_box:
		return -1
	
	dialogue_box.portrait_area.hide()
	var dialogue_chosen: String = await dialogue_box.show_choices(dialogue_choice.options.keys()[0], dialogue_choice.options.keys()[1])
	print(dialogue_chosen)
	return dialogue_choice.options.get(dialogue_chosen, -1)


func hide_dialogue():
	if !in_dialogue_choice:
		dialogue_box.hide_dialogue()


func finish_dialogue():
	dialogue_has_finished = true
