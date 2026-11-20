extends Control
class_name StatsViewerMenu


@export var gdy_label: RichTextLabel
@export var yummies_count_label: RichTextLabel
@export var bummies_count_label: RichTextLabel
@export var days_left_label: RichTextLabel


func _ready() -> void:
	UIHandler.stats_viewer_menu = self


func update_stats():
	gdy_label.text = "GDY: " + str(GlobalData.update_gdy())
