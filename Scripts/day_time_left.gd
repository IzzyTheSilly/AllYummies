extends Control
class_name DayTimeLeft


@export var day_time_left_label: RichTextLabel


func _on_timer_timeout() -> void:
	day_time_left_label.text = "Daytime Left: " + str(GameManager.get_day_time_left())
