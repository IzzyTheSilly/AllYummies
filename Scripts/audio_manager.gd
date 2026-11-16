extends Node


##0: Dialogue, 1: SFX, 2: Music
@export var audio_stream_players: Array[AudioStreamPlayer]

@export var dialogue_audio: AudioStreamPlayer
@export var sfx_audio: AudioStreamPlayer
@export var music_audio: AudioStreamPlayer

func change_dialogue_volume(volume: int):
	dialogue_audio.volume_db = linear_to_db(volume)

func change_sfx_volume(volume: int):
	sfx_audio.volume_db = linear_to_db(volume)

func change_music_volume(volume: int):
	music_audio.volume_db = linear_to_db(volume)
