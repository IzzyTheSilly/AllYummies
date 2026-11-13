extends Node


var options_menu: OptionsMenu
var showing_options: bool = false


func change_volume(audio_stream_player_index: int, volume: int):
	AudioManager.audio_stream_players[audio_stream_player_index].volume_db = volume - 25
	print(volume - 25)


func show_options():
	var down_tween = get_tree().create_tween()
	down_tween.tween_property(options_menu, "position", Vector2(-120.0, -117.0), 0.5).set_trans(Tween.TRANS_CUBIC)
	showing_options = true


func hide_options():
	var up_tween = get_tree().create_tween()
	up_tween.tween_property(options_menu, "position", Vector2(-120.0, -417.0), 0.5).set_trans(Tween.TRANS_CUBIC)
	showing_options = false
