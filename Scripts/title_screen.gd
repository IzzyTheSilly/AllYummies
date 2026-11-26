extends Control


@export var black_screen: ColorRect

@export var title_music: AudioStream

var current_tween: Tween


func _ready() -> void:
	AudioManager.change_music_audio(title_music, true, true)
	var black_screen_tween: Tween = get_tree().create_tween()
	current_tween = black_screen_tween
	black_screen_tween.tween_property(black_screen, "modulate", Color(255, 255, 255, 0), 1)
	await black_screen_tween.finished
	current_tween = null
	black_screen.hide()


func _on_play_button_pressed() -> void:
	GameManager.in_game = true
	black_screen.show()
	if current_tween:
		current_tween.kill()
	var black_screen_tween: Tween = get_tree().create_tween()
	black_screen_tween.tween_property(black_screen, "modulate", Color(255, 255, 255, 1), 2)
	AudioManager.stop_music_audio()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/game_area.tscn")
	GameManager.reset_day_timer()


func _on_options_button_pressed() -> void:
	UIHandler.set_menu_showing(UIHandler.Menu.OPTIONS, true)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
