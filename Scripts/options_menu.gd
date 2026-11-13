extends Control
class_name OptionsMenu


func _ready() -> void:
	OptionsHandler.options_menu = self


func _on_back_button_pressed() -> void:
	OptionsHandler.hide_options()


func _on_dialogue_audio_slider_value_changed(value: float) -> void:
	OptionsHandler.change_volume(0, value)
