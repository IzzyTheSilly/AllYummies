extends Control
class_name OptionsMenu


@export var pages: Array[Control]
var page: int = 1

@export var back_button: Button
@export var main_menu_button: Button

@export var dialogue_volume_slider: HSlider
@export var sfx_volume_slider: HSlider
@export var music_volume_slider: HSlider

@export var quit_cutscene_id: String
@export var cancel_quit_cutscene_id: String

@export var are_you_sure: Panel
@export var input_blocker: Control


func _ready() -> void:
	UIHandler.options_menu = self
	dialogue_volume_slider.value = GlobalData.dialogue_volume
	sfx_volume_slider.value = GlobalData.sfx_volume
	music_volume_slider.value = GlobalData.music_volume
	UIHandler.start_position_y = position.y
	if GameManager.in_game:
		main_menu_button.show()
	else:
		main_menu_button.hide()


func change_page(page: int):
	if UIHandler.menu_showing != UIHandler.Menu.OPTIONS:
		return
	for i in range(pages.size()):
		if i == page - 1:
			pages[i].show()
		else:
			pages[i].hide()


func _on_back_button_pressed() -> void:
	UIHandler.set_menu_showing(UIHandler.Menu.OPTIONS, false)


func _on_main_menu_button_pressed() -> void:
	if GameManager.in_gameplay:
		input_blocker.show()
		await CutsceneHandler.show_cutscene(quit_cutscene_id)
		are_you_sure_()
	else:
		quit_to_title_screen()


func quit_to_title_screen():
	GameManager.in_game = false
	UIHandler.set_menu_showing(UIHandler.Menu.NONE, false)
	GlobalData.reset_local_flags()
	GlobalData.reset_game_stats()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_next_page_button_pressed() -> void:
	return
	if page < pages.size():
		page = page + 1
		change_page(page)


func _on_previous_page_button_pressed() -> void:
	return
	if page > 1:
		page = page - 1
		change_page(page)


func _on_dialogue_volume_slider_value_changed(value: float) -> void:
	AudioManager.change_dialogue_volume(value)
	GlobalData.dialogue_volume = value


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioManager.change_sfx_volume(value)
	GlobalData.sfx_volume = value


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioManager.change_music_volume(value)
	GlobalData.music_volume = value


func are_you_sure_():
	are_you_sure.show()


func _on_yes_pressed() -> void:
	quit_to_title_screen()


func _on_no_pressed() -> void:
	await CutsceneHandler.show_cutscene(cancel_quit_cutscene_id)
	are_you_sure.hide()
	input_blocker.hide()
	UIHandler.set_menu_showing(UIHandler.Menu.OPTIONS, false)
