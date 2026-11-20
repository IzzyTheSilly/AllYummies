extends Entity
class_name StatsViewer


func _on_interact():
	UIHandler.stats_viewer_menu.update_stats()
	UIHandler.set_menu_showing(UIHandler.Menu.STATS_VIEWER, true)
