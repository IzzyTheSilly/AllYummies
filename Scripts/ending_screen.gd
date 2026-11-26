extends Control
class_name EndingScreen


@export var final_gdy_label: RichTextLabel
@export var score_label: RichTextLabel


func _ready() -> void:
	GameManager.ending_screen = self


func show_score(score: int):
	final_gdy_label.show()
	await get_tree().create_timer(1.5).timeout
	score_label.text = str(score)
	score_label.show()
	await get_tree().create_timer(2).timeout


func hide_score():
	final_gdy_label.hide()
	score_label.hide()


func show_game_end():
	score_label.text = "GAME END"
	var game_end_tween: Tween = get_tree().create_tween()
	game_end_tween.tween_property(score_label, "modulate", Color(0, 0, 0, 0), 3)
