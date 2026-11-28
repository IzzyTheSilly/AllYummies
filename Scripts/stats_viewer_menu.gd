extends Control
class_name StatsViewerMenu


@export var gdy_label: RichTextLabel
@export var yummies_count_label: RichTextLabel
@export var yummies_rate_label: RichTextLabel
@export var bummies_count_label: RichTextLabel
@export var chummies_count_label: RichTextLabel
@export var chummy_rate_label: RichTextLabel
@export var days_left_label: RichTextLabel

@export var gdy_label_gradient: Gradient


func _ready() -> void:
	UIHandler.stats_viewer_menu = self


func update_stats():
	var gdy: int = GlobalData.update_gdy()
	gdy_label.clear()
	gdy_label.push_color(gdy_label_gradient.sample(gdy/200.0))
	gdy_label.add_text("GDY: " + str(gdy))
	gdy_label.pop()
	
	yummies_count_label.text = "Yummies: " + str(GlobalData.yummies)
	bummies_count_label.text = "Bummies: " + str(GlobalData.total_bummies())
	days_left_label.text = "Days Left: " + str(GlobalData.days_left)
	yummies_rate_label.text = "Yummies/Min: " + str(GlobalData.yummies_rate)
	chummies_count_label.text = "Chummies: " + str(GlobalData.chummies)
	chummy_rate_label.text = "Chummies/Min: " + str(GlobalData.chummies_rate)
