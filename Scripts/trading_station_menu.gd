extends Control
class_name TradingStationMenu


var selected_option: int = 1
@export var selection_highlights: Array[ColorRect]
@export var tip_label: RichTextLabel


func _ready() -> void:
	UIHandler.trading_station_menu = self


func trade():
	if try_select(selected_option) == 1:
		change_tip_text("Not enough yummies!")


func change_tip_text(text: String, time: float = 1.5):
		tip_label.text = text
		await get_tree().create_timer(2).timeout
		tip_label.text = "Press X to buy!"


func change_select(direction: int):
	if direction == 1:
		if selected_option == 3:
			selected_option = 1
		else:
			selected_option = selected_option + 1
	elif direction == -1:
		if selected_option == 1:
			selected_option = 3
		else:
			selected_option = selected_option - 1
	
	set_selection_highlights(selected_option)


func set_selection_highlights(option: int):
	for i in range(selection_highlights.size()):
		if i + 1 == option:
			selection_highlights[i].show()
		else:
			selection_highlights[i].hide()


func try_select(option: int) -> int:
	match option:
		1: 
			if take_yummy(2) == 0:
				GlobalData.add_chummy(1)
				change_tip_text("Employed two chummies!")
				return 0
		2: 
			if take_yummy(3) == 0:
				GlobalData.max_collected_yummies = GlobalData.max_collected_yummies + 3
				change_tip_text("Increased inventory storage!")
				return 0
		3: 
			if take_yummy(3) == 0:
				return 0
	return 1


func take_yummy(cost: int) -> int:
	var amount: int = 0
	var index_array: Array[int]
	for i in range(GlobalData.collected_yummies_list.size()):
		if GlobalData.collected_yummies_list[i].bummy_state == Yummy.BummyState.YUMMY:
			amount = amount + 1
			index_array.append(i)
			if amount >= cost:
				for j in range(cost):
					GlobalData.collected_yummies_list[index_array[j] - j].exterminate()
				return 0
	return 1
