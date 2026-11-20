extends Entity
class_name StatsViewer


@export var stats_viewer_menu: Control


func _on_interact():
	stats_viewer_menu.show()
