extends Control
class_name OptionsMenu


@export var back_button: Button
@export var dialogue_volume_slider: HSlider
@export var main_menu_button: Button


func _ready() -> void:
	OptionsHandler.options_menu = self
	dialogue_volume_slider.value = GlobalData.dialogue_volume
	if GlobalData.in_game:
		main_menu_button.show()
	else:
		main_menu_button.hide()


func _on_back_button_pressed() -> void:
	OptionsHandler.hide_options()


func _on_dialogue_volume_slider_value_changed(value: float) -> void:
	OptionsHandler.change_volume(0, value)
	GlobalData.dialogue_volume = value


func _on_main_menu_button_pressed() -> void:
	GlobalData.in_game = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
