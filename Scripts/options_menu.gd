extends Control
class_name OptionsMenu


@export var page_one: Control
@export var page_two: Control
@export var page_three: Control
var page: int = 1

@export var back_button: Button
@export var main_menu_button: Button

@export var dialogue_volume_slider: HSlider
@export var sfx_volume_slider: HSlider
@export var music_volume_slider: HSlider


func _ready() -> void:
	OptionsHandler.options_menu = self
	dialogue_volume_slider.value = GlobalData.dialogue_volume
	sfx_volume_slider.value = GlobalData.sfx_volume
	music_volume_slider.value = GlobalData.music_volume
	if GameManager.in_game:
		main_menu_button.show()
	else:
		main_menu_button.hide()


func change_page(page: int):
	if page == 1:
		page_one.show()
		page_two.hide()
		page_three.hide()
	elif page == 2:
		page_one.hide()
		page_two.show()
		page_three.hide()
	elif page == 3:
		page_one.hide()
		page_two.hide()
		page_three.show()


func _on_back_button_pressed() -> void:
	OptionsHandler.hide_options()


func _on_main_menu_button_pressed() -> void:
	GameManager.in_game = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_next_page_button_pressed() -> void:
	if page < 3:
		page = page + 1
		change_page(page)


func _on_previous_page_button_pressed() -> void:
	if page > 1:
		page = page - 1
		change_page(page)


func _on_dialogue_volume_slider_value_changed(value: float) -> void:
	AudioManager.change_dialogue_volume(value)
	GlobalData.dialogue_volume = value
