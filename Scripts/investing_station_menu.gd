extends Control
class_name InvestingStationMenu


var selected_option: int = 1
@export var stock_value_label: RichTextLabel
@export var option_highlights: Array[Control]
@export var tip_label: RichTextLabel
@export var yummies_in_stock_label: RichTextLabel
@export var cooldown_label: RichTextLabel

var stock_value: float = 1.0
@export var stock_value_update_time: float = 10
@export var stock_value_update_timer: Timer
@export var tip_label_timer: Timer
@export var cooldown_timer: Timer

@export var error_sfx: AudioStream
@export var purchase_sfx: AudioStream

var stock_values: Array[int]
var in_cooldown: bool = false


func start():
	stock_value_update_timer.start(stock_value_update_time)
	stock_value_label.text = "Stock Value: " + str(stock_value)


func end():
	stock_value_update_timer.stop()


func _ready() -> void:
	UIHandler.investing_station_menu = self
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)


func _process(delta: float) -> void:
	cooldown_label.text = "Cooldown: " + str(int(cooldown_timer.time_left)) + "s"


func handle_invest():
	if selected_option == 1:
		invest_yummy()
	elif selected_option == 2:
		pull_yummy()


func invest_yummy():
	var collected_yummies_list: Array[Yummy] = GlobalData.collected_yummies_list
	if in_cooldown:
		change_tip_text("Investing in cooldown!")
		error()
		return
	if collected_yummies_list.size() == 0:
		change_tip_text("No yummies in inventory!")
		error()
		return
	if GlobalData.yummies_in_stock_market >= GlobalData.max_yummy_invest:
		change_tip_text("Investing station is full!")
		error()
		return
	for i in range(collected_yummies_list.size()):
		if !is_instance_valid(collected_yummies_list[i]):
			continue
		if collected_yummies_list[i].bummy_state == Yummy.BummyState.YUMMY:
			collected_yummies_list[i].exterminate()
			GlobalData.add_yummies_invested(1)
			stock_values.append(stock_value)
			change_tip_text("Yummy invested!")
			update_yummies_in_stock()
			GlobalData.add_chummies_rate(0.15)
			purchase()
			set_cooldown(15)
			return
	change_tip_text("No yummies in inventory!")
	error()


func pull_yummy():
	if in_cooldown:
		change_tip_text("Investing in cooldown!")
		error()
		return
	if GlobalData.yummies_in_stock_market > 0:
		var yummy_exchange_rate: float = stock_value / stock_values[0]
		var guaranteed_yummies = floor(yummy_exchange_rate)
		var chance = (yummy_exchange_rate - guaranteed_yummies)
		if randf_range(0, 1) < chance:
			guaranteed_yummies = guaranteed_yummies + 1
		
		if GlobalData.can_add_collected_yummies(guaranteed_yummies):
			for i in range(guaranteed_yummies):
				GameManager.spawn_yummy_in_inventory(1)
			GlobalData.add_yummies_invested(-1)
			GlobalData.add_chummies_rate(-0.15)
			stock_values.pop_at(0)
			change_tip_text(str(guaranteed_yummies) + " yummies pulled!")
			update_yummies_in_stock()
			purchase()
			set_cooldown(15)
		else:
			change_tip_text("Inventory doesn't fit!")
			error()
	else:
		change_tip_text("No yummies invested yet!")
		error()


func change_tip_text(text: String, time: float = 1.5):
	tip_label.text = text
	tip_label_timer.start(time)
	await tip_label_timer.timeout
	tip_label.text = "Press X to invest or pull!"


func _on_stock_value_update_timer_timeout() -> void:
	if stock_value < 22.0:
		stock_value = min(stock_value * (GlobalData.yummy_interest_average + randf_range(-0.3, 0.4)), 22)
	else:
		stock_value = stock_value * (GlobalData.yummy_interest_average + randf_range(-0.3, -0.1))
	stock_value_label.text = "Stock Value: %.3f" % stock_value
	stock_value_update_timer.start(stock_value_update_time + randf_range(-4, 4))


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


func error():
	AudioManager.try_change_sfx_audio(error_sfx, true)


func purchase():
	AudioManager.try_change_sfx_audio(purchase_sfx, true)


func set_cooldown(seconds: int):
	in_cooldown = true
	cooldown_timer.start(seconds)


func _on_cooldown_timer_timeout() -> void:
	in_cooldown = false
