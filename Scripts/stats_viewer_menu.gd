extends Control
class_name StatsViewerMenu


@export var gdy_label: RichTextLabel
@export var yummies_count_label: RichTextLabel
@export var yummies_rate_label: RichTextLabel
@export var bummies_count_label: RichTextLabel
@export var chummies_count_label: RichTextLabel
@export var chummy_rate_label: RichTextLabel
@export var days_left_label: RichTextLabel


func _ready() -> void:
	UIHandler.stats_viewer_menu = self


func update_stats():
	gdy_label.text = "GDY: " + str(GlobalData.update_gdy())
	yummies_count_label.text = "Yummies: " + str(GlobalData.yummies)
	bummies_count_label.text = "Bummies: " + str(GlobalData.total_bummies())
	days_left_label.text = "Days Left: " + str(GlobalData.days_left)
	yummies_rate_label.text = "Yummies/Min: " + str(GlobalData.yummies_rate)
	chummies_count_label.text = "Chummies " + str(GlobalData.chummies)
	chummy_rate_label.text = "Chummies/Min: " + str(GlobalData.chummies_rate)
