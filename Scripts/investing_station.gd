extends Entity
class_name InvestingStation


func _on_interact():
	UIHandler.set_menu_showing(UIHandler.Menu.INVESTING_STATION, true)
