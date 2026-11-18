extends Resource
class_name DialogueData


@export_multiline var text: String
@export var blip: AudioStream
@export var portrait: Texture2D

@export var next_dialogue_index: int = -1
@export var next_dialogue_choice_index: int = -1

@export var text_speed: float = 25.0
