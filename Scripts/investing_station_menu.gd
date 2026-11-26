extends Control
class_name InvestingStationMenu


var selected_option: int = 1
@export var stock_value_label: RichTextLabel
@export var option_highlights: Array[Control]
@export var tip_label: RichTextLabel
@export var yummies_in_stock_label: RichTextLabel

var stock_value: float = 1.0
@export var stock_value_update_time: float = 15
@export var stock_value_update_timer: Timer
@export var tip_label_timer: Timer

var stock_values: Array[int]


func start():
	stock_value_update_timer.start(stock_value_update_time)
	stock_value_label.text = "Stock Value: " + str(stock_value)


func end():
	stock_value_update_timer.stop()


func _ready() -> void:
	UIHandler.investing_station_menu = self
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)


func handle_invest():
	if selected_option == 1:
		invest_yummy()
	elif selected_option == 2:
		pull_yummy()


func invest_yummy():
	var collected_yummies_list: Array[Yummy] = GlobalData.collected_yummies_list
	if collected_yummies_list.size() == 0:
		change_tip_text("No yummies in inventory!")
		return
	elif GlobalData.yummies_in_stock_market >= GlobalData.max_yummy_invest:
		change_tip_text("Investing station is full!")
		return
	for i in range(collected_yummies_list.size()):
		if collected_yummies_list[i].bummy_state == Yummy.BummyState.YUMMY:
			collected_yummies_list[i].exterminate()
			GlobalData.add_yummies_invested(1)
			stock_values.append(stock_value)
			change_tip_text("Yummy invested!")
			update_yummies_in_stock()
			return
	change_tip_text("No yummies in inventory!")


func pull_yummy():
	if GlobalData.yummies_in_stock_market > 0:
		var yummy_exchange_rate: float = stock_value / stock_values[0]
		print(yummy_exchange_rate)
		var guaranteed_yummies = floor(yummy_exchange_rate)
		var chance = (yummy_exchange_rate - guaranteed_yummies)
		if randf_range(0, 1) < chance:
			guaranteed_yummies = guaranteed_yummies + 1
		
		if GlobalData.can_add_collected_yummies(guaranteed_yummies):
			for i in range(guaranteed_yummies):
				GameManager.spawn_yummy_in_inventory(1)
			GlobalData.add_yummies_invested(-1)
			stock_values.pop_at(0)
			change_tip_text(str(guaranteed_yummies) + " yummies pulled!")
			update_yummies_in_stock()
		else:
			change_tip_text("Inventory full!")
	else:
		change_tip_text("No yummies invested yet!")


func change_tip_text(text: String, time: float = 1.5):
	tip_label.text = text
	tip_label_timer.start(time)
	await tip_label_timer.timeout
	tip_label.text = "Press X to invest or pull!"


func _on_stock_value_update_timer_timeout() -> void:
	stock_value = stock_value * GlobalData.yummy_interest_average
	stock_value_label.text = "Stock Value: %.3f" % stock_value


func update_yummies_in_stock():
	yummies_in_stock_label.text = "Yummies In Stock: " + str(GlobalData.yummies_in_stock_market)


func change_select(direction: int):
	if direction == 1:
		selected_option = 2
	if direction == -1:
		selected_option = 1
	change_option_highlights(selected_option)


func change_option_highlights(option: int):
	if option == 1:
		option_highlights[0].show()
		option_highlights[1].hide()
	elif option == 2:
		option_highlights[0].hide()
		option_highlights[1].show()
