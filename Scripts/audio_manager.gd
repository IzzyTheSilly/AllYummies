extends Node


##0: Dialogue, 1: SFX, 2: Music
@export var audio_stream_players: Array[AudioStreamPlayer]

@export var dialogue_audio: AudioStreamPlayer
@export var sfx_audio: AudioStreamPlayer
@export var music_audio: AudioStreamPlayer


func change_dialogue_volume(volume: float):
	audio_stream_players[0].volume_db = linear_to_db(volume)


func change_dialogue_audio(audio: AudioStream, play_immediately: bool = false):
	audio_stream_players[0].stream = audio
	if play_immediately:
		audio_stream_players[0].play()


func change_sfx_volume(volume: float):
	for i in range(1, 5):
		audio_stream_players[i].volume_db = linear_to_db(volume)


func try_change_sfx_audio(audio: AudioStream, play_immediately: bool = false, offset: float = 0) -> int:
	for i in range(1, 5):
		if !audio_stream_players[i].playing:
			audio_stream_players[i].stream = audio
			if play_immediately:
				audio_stream_players[i].play(offset)
				print(offset)
			return 0
	return 1


func change_music_volume(volume: float):
	music_audio.volume_db = linear_to_db(volume)


func change_music_audio(audio: AudioStream, play_immediately: bool = false, fade_in: bool = false):
	audio_stream_players[6].stream = audio
	
	if play_immediately:
		audio_stream_players[6].play()
	
	if fade_in:
		var old_volume: float = audio_stream_players[6].volume_linear
		change_music_volume(0)
		var audio_tween: Tween = get_tree().create_tween()
		audio_tween.tween_property(audio_stream_players[6], "volume_linear", old_volume, 3)


func stop_music_audio():
	var old_volume: float = audio_stream_players[6].volume_linear
	var fade_out_tween: Tween = get_tree().create_tween()
	fade_out_tween.tween_property(audio_stream_players[6], "volume_linear", 0, 3)
	await  fade_out_tween.finished
	audio_stream_players[6].stop()
	change_music_volume(old_volume)
