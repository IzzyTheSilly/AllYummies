extends Node


var options_menu: OptionsMenu
var showing_options: bool = false


func change_volume(audio_stream_player_index: int, volume: float):
	AudioManager.audio_stream_players[audio_stream_player_index].volume_db = linear_to_db(volume)


func show_options():
	options_menu.show()
	showing_options = true


func hide_options():
	options_menu.hide()
	showing_options = false
