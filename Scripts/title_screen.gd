extends Control


@export var black_screen: ColorRect


func _ready() -> void:
	var black_screen_tween: Tween = get_tree().create_tween()
	black_screen_tween.tween_property(black_screen, "modulate", Color(255, 255, 255, 0), 1)
	await black_screen_tween.finished
	black_screen.hide()


func _on_play_button_pressed() -> void:
	GameManager.in_game = true
	get_tree().change_scene_to_file("res://Scenes/game_area.tscn")
	GameManager.reset_day_timer()


func _on_options_button_pressed() -> void:
	UIHandler.set_menu_showing(UIHandler.Menu.OPTIONS, true)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
