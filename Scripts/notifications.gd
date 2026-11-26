extends Control
class_name Notifications


@export var labels: Array[RichTextLabel]
@export var timers: Array[Timer]
@export var disappear_time: float = 2


func _ready() -> void:
	UIHandler.notifications = self
	for i in range(labels.size()):
		labels[i].text = ""


func set_next_label(text: String):
	if text == labels[6].text:
		return
	for i in range(labels.size()):
		if labels[i].text != "":
			if i == 0:
				labels[i].text = ""
			else:
				labels[i-1].text = labels[i].text
				timers[i-1].start(timers[i].time_left)
	labels[6].text = text
	timers[6].start(disappear_time)


func _on_timer_1_timeout() -> void:
	labels[0].text = ""


func _on_timer_2_timeout() -> void:
	labels[1].text = ""


func _on_timer_3_timeout() -> void:
	labels[2].text = ""


func _on_timer_4_timeout() -> void:
	labels[3].text = ""


func _on_timer_5_timeout() -> void:
	labels[4].text = ""


func _on_timer_6_timeout() -> void:
	labels[5].text = ""


func _on_timer_7_timeout() -> void:
	labels[6].text = ""
