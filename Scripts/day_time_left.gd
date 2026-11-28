extends Control
class_name DayTimeLeft


@export var day_time_left_label: RichTextLabel
@export var current_gdy_label: RichTextLabel


func _ready() -> void:
	UIHandler.daytime_left_panel = self


func _on_timer_timeout() -> void:
	set_timer()


func set_timer():
	var minutes: int = floor(GameManager.get_day_time_left() / 60)
	var seconds: int = int(GameManager.get_day_time_left()) % 60
	day_time_left_label.text = "Daytime Left: " + str(minutes) + "min " + str(seconds) + "sec"
	
	current_gdy_label.text = "Current GDY:\n" + str(GlobalData.update_gdy())
