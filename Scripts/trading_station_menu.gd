extends Control
class_name TradingStationMenu


var selected_option: int = 0


func _ready() -> void:
	UIHandler.trading_station_menu = self


func trade():
	select(selected_option)


func select(option: int):
	match option:
		1: 
			if take_yummy(2):
				pass
		2: 
			if take_yummy(3):
				pass
		3: 
			if take_yummy(3):
				pass


func take_yummy(cost: int) -> int:
	var amount: int = 0
	var index_array: Array[int]
	for i in GlobalData.collected_yummies_list:
		if GlobalData.collected_yummies_list[i].bummy_state == Yummy.BummyState.YUMMY:
			amount = amount + 1
			index_array.append(i)
			if amount >= cost:
				for j in range(cost):
					GlobalData.collected_yummies_list[index_array[j]].exterminate()
				return 0
	return 1
