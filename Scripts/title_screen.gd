extends Control


func _on_play_button_pressed() -> void:
	GameManager.in_game = true
	get_tree().change_scene_to_file("res://Scenes/game_area.tscn")


func _on_options_button_pressed() -> void:
	OptionsHandler.show_options()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
