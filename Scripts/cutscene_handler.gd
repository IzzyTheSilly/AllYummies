extends Node


var current_cutscene: CutsceneData
var currently_selected_choice: int = -1

var dialogue_box: DialogueBox
var in_cutscene: bool = false
var in_dialogue_choice: bool = false
var dialogue_has_finished: bool = true

var player: Player


func show_cutscene(id: String) -> int:
	var cutscene: CutsceneData = AssetDictionaries.cutscenes.get(id, AssetDictionaries.cutscenes["error"])
	if cutscene.flag_requirements and !check_requirements(cutscene):
		return 1
	
	in_cutscene = true
	
	current_cutscene = cutscene
	if cutscene.dialogues:
		await handle_dialogue(0)
	
	if cutscene.set_flags:
		for key in cutscene.set_flags:
			if !GlobalData.local_flags.has(key):
				continue
			GlobalData.local_flags[key] = cutscene.set_flags[key]
			check_special_flags(key, cutscene)
	
	in_cutscene = false
	return 0


func check_special_flags(key: String, cutscene: CutsceneData):
	if key == "game_start" and cutscene.set_flags[key] == 1:
		GameManager.start_game()
		UIHandler.notify("Day Start!")
	if key == "move_player_left" and cutscene.set_flags[key] == 1:
		player.auto_move(Vector2.LEFT, 0.2)
	if key == "move_player_right" and cutscene.set_flags[key] == 1:
		player.auto_move(Vector2.RIGHT, 0.2)
	if key == "move_player_down" and cutscene.set_flags[key] == 1:
		player.auto_move(Vector2.DOWN, 0.2)


func check_requirements(cutscene: CutsceneData) -> bool:
	for key in cutscene.flag_requirements:
		if !GlobalData.local_flags.has(key):
			continue
		if GlobalData.local_flags[key] != cutscene.flag_requirements[key]:
			return false
	return true


func handle_dialogue(index: int):
	await show_dialogue(current_cutscene.dialogues[index])
	if current_cutscene.dialogues[index].next_dialogue_index >= 0:
		await handle_dialogue(current_cutscene.dialogues[index].next_dialogue_index)
	elif current_cutscene.dialogues[index].next_dialogue_choice_index >= 0:
		await handle_dialogue_choice(current_cutscene.dialogues[index].next_dialogue_choice_index)


func handle_dialogue_choice(index: int):
	in_dialogue_choice = true
	currently_selected_choice = 1
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
	if dialogue.portrait:
		dialogue_box.change_portrait(dialogue.portrait)
	else: dialogue_box.hide_portrait()
	dialogue_box.change_blip(dialogue.blip)
	dialogue_box.show()
	await dialogue_box.show_text(dialogue.text, dialogue.text_speed)


func show_dialogue_choice(dialogue_choice: DialogueChoiceData) -> int:
	if !dialogue_box:
		return -1
	
	dialogue_box.dialogue_choice_texts[0].get_child(0).show()
	dialogue_box.dialogue_choice_texts[1].get_child(0).hide()
	dialogue_box.portrait_area.hide()
	var dialogue_chosen: String = await dialogue_box.show_choices(dialogue_choice.options.keys()[0], dialogue_choice.options.keys()[1])
	return dialogue_choice.options.get(dialogue_chosen, -1)


func hide_dialogue():
	if !in_dialogue_choice:
		dialogue_box.hide_dialogue()


func select_current_choice():
	dialogue_box.select_choice(currently_selected_choice)


func change_currently_selected_choice(direction: int):
	currently_selected_choice = clamp(currently_selected_choice + direction, 1, 2)
	match currently_selected_choice:
		1: 
			dialogue_box.dialogue_choice_texts[0].get_child(0).show()
			dialogue_box.dialogue_choice_texts[1].get_child(0).hide()
		2:
			dialogue_box.dialogue_choice_texts[0].get_child(0).hide()
			dialogue_box.dialogue_choice_texts[1].get_child(0).show()


func finish_dialogue():
	dialogue_has_finished = true
