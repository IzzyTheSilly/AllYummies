extends Node


enum Menu {NONE, OPTIONS, STATS_VIEWER, INVESTING_STATION, TRADING_STATION}
var menu_showing: Menu = Menu.NONE


var options_menu: OptionsMenu
var stats_viewer_menu: StatsViewerMenu
var investing_station_menu: InvestingStationMenu
var trading_station_menu: TradingStationMenu

var daytime_left_panel: DayTimeLeft
var inventory_panel: YummyInventory
var notifications: Notifications


var start_position_y: float # starts hidden
var current_tween: Tween


func _ready() -> void:
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)


func start():
	daytime_left_panel.show()
	notifications.show()
	daytime_left_panel.day_time_left_label.text = "Daytime Left: " + str(int(GlobalData.day_length)) + "min 0sec"


func end():
	daytime_left_panel.hide()
	notifications.hide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left") and showing_menu:
		options_menu._on_previous_page_button_pressed()
	elif Input.is_action_just_pressed("move_right") and showing_menu:
		options_menu._on_next_page_button_pressed()


func set_menu_showing(menu: Menu, showing: bool):
	if showing:
		match menu:
			Menu.NONE: set_menu_showing(Menu.NONE, false)
			Menu.OPTIONS: show_options()
			Menu.STATS_VIEWER: show_stats_viewer()
			Menu.INVESTING_STATION: show_investing_station()
			Menu.TRADING_STATION: show_trading_station()
		menu_showing = menu
	else:
		match menu_showing:
			Menu.OPTIONS: hide_options()
			Menu.STATS_VIEWER: hide_stats_viewer()
			Menu.INVESTING_STATION: hide_investing_station()
			Menu.TRADING_STATION: hide_trading_station()
		menu_showing = Menu.NONE


func showing_menu() -> bool:
	return menu_showing != Menu.NONE


func show_options():
	if menu_showing == Menu.OPTIONS:
		return
	if current_tween:
		current_tween.kill()
	var show_tween = get_tree().create_tween()
	current_tween = show_tween
	var duration: float = 0.4 * (((start_position_y - options_menu.position.y) / 300) + 1)
	show_tween.tween_property(options_menu, "position:y", start_position_y + 300, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func hide_options():
	if menu_showing != Menu.OPTIONS:
		return
	if current_tween:
		current_tween.kill()
	var hide_tween = get_tree().create_tween()
	current_tween = hide_tween
	var duration: float = 0.4 * (options_menu.position.y - start_position_y) / 300
	hide_tween.tween_property(options_menu, "position:y", start_position_y, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	get_viewport().gui_release_focus()


func show_stats_viewer():
	if showing_menu():
		return
	stats_viewer_menu.show()


func hide_stats_viewer():
	if menu_showing != Menu.STATS_VIEWER:
		return
	stats_viewer_menu.hide()


func show_investing_station():
	if showing_menu():
		return
	investing_station_menu.show()


func hide_investing_station():
	if menu_showing != Menu.INVESTING_STATION:
		return
	investing_station_menu.hide()


func show_trading_station():
	if showing_menu():
		return
	trading_station_menu.show()


func hide_trading_station():
	if menu_showing != Menu.TRADING_STATION:
		return
	trading_station_menu.hide()


func update_inventory(type: int):
	inventory_panel.update_inventory_slot(type)
	popup_inventory()


func popup_inventory():
	var show_tween: Tween = get_tree().create_tween()
	show_tween.tween_property(inventory_panel, "position:y", -155, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await show_tween.finished
	await get_tree().create_timer(0.7).timeout
	var hide_tween: Tween = get_tree().create_tween()
	hide_tween.tween_property(inventory_panel, "position:y", -245, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func notify(text: String):
	notifications.set_next_label(text)


func do_trade():
	if menu_showing == Menu.TRADING_STATION:
		trading_station_menu.trade()


func change_select_trading_station(direction: int):
	trading_station_menu.change_select(direction)


func invest_yummy():
	investing_station_menu.handle_invest()


func change_select_investing_station(direction: int):
	investing_station_menu.change_select(direction)
