extends Control
class_name DialogueBox


signal dialogue_accepted
signal dialogue_choice_accepted

@export var dialogue_text: RichTextLabel
@export var dialogue_choice_texts: Array[RichTextLabel]
@export var portrait_image: TextureRect
@export var portrait_area: TextureRect
@export var dialogue_timer: Timer

var selected_option: int


func _ready() -> void:
	CutsceneHandler.dialogue_box = self


func show_text(text: String, text_speed: float = 25.0, comma_delay: float = 2.5, period_delay: float = 4.0):
	var wait_time = 1 / text_speed
	dialogue_timer.wait_time = wait_time
	dialogue_text.visible_characters = 0
	dialogue_text.text = text
	var text_length = text.length()
	
	dialogue_text.show()
	for i in dialogue_choice_texts:
		i.hide()
	
	dialogue_timer.start()
	for i in range(text_length):
		if CutsceneHandler.dialogue_has_finished:
			dialogue_timer.stop()
			break
		
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
	await dialogue_accepted


func show_choices(choice_1: String = "", choice_2: String = "") -> String:
	show()
	dialogue_text.hide()
	for i in dialogue_choice_texts:
		i.show()
	
	dialogue_choice_texts[0].text = choice_1
	dialogue_choice_texts[1].text = choice_2
	
	await dialogue_choice_accepted
	hide()
	match selected_option:
		1: return choice_1
		2: return choice_2
	return ""


func skip_current_dialogue():
	dialogue_text.visible_ratio = 1.0
	finish_dialogue()


func hide_dialogue():
	if CutsceneHandler.dialogue_has_finished:
		hide()
		dialogue_accepted.emit()
	else:
		skip_current_dialogue()


func finish_dialogue():
	CutsceneHandler.finish_dialogue()


func select_choice(choice: int):
	selected_option = choice
	dialogue_choice_accepted.emit()


func change_portrait(image: Texture2D):
	portrait_image.texture = image


func change_blip(blip: AudioStream):
	AudioManager.audio_stream_players[0].stream = blip
