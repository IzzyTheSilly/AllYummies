extends Entity
class_name TradingStation


func _on_interact():
	UIHandler.set_menu_showing(UIHandler.Menu.TRADING_STATION, true)
