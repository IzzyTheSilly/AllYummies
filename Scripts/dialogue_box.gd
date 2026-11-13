extends Control
class_name DialogueBox


@export var dialogue_text: RichTextLabel
@export var portrait_image: TextureRect
@export var dialogue_timer: Timer


func _ready() -> void:
	CutsceneHandler.dialogue_box = self


func show_text(text: String, text_speed: float = 25.0, comma_delay: float = 2.5, period_delay: float = 4.0):
	var wait_time = 1 / text_speed
	dialogue_timer.wait_time = wait_time
	dialogue_text.visible_characters = 0
	dialogue_text.text = text
	var text_length = text.length()
	
	dialogue_timer.start()
	for i in range(text_length):
		if CutsceneHandler.dialogue_has_finished:
			dialogue_timer.stop()
			return
		
		AudioManager.audio_stream_players[0].play()
		dialogue_text.visible_characters += 1
		
		dialogue_timer.wait_time = wait_time
		if text[i] == ",":
			dialogue_timer.wait_time += wait_time * comma_delay
		elif text[i] == ".":
			dialogue_timer.wait_time += wait_time * period_delay
		
		await dialogue_timer.timeout
	dialogue_timer.stop()
	
	finish_dialogue()


func skip_current_dialogue():
	dialogue_text.visible_ratio = 1.0
	finish_dialogue()


func finish_dialogue():
	CutsceneHandler.finish_dialogue()


func change_portrait(image: Texture2D):
	portrait_image.texture = image


func change_blip(blip: AudioStream):
	AudioManager.audio_stream_players[0].stream = blip
