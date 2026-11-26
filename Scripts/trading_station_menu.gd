extends Control
class_name TradingStationMenu


var selected_option: int = 1
@export var selection_highlights: Array[ColorRect]
@export var tip_label: RichTextLabel

@export var option_labels: Array[RichTextLabel]
@export var option_1_options: Array[TradingOption]
@export var option_2_options: Array[TradingOption]
@export var option_3_options: Array[TradingOption]
var option_1_stage: int = 1
var option_2_stage: int = 1
var option_3_stage: int = 1

@export var timer: Timer
@export var player: Player

@export var error_sfx: AudioStream
@export var purchase_sfx: AudioStream


func _ready() -> void:
	UIHandler.trading_station_menu = self
	set_option_labels(1)
	set_option_labels(2)
	set_option_labels(3)


func trade():
	if try_select(selected_option) == 1:
		pass


func change_tip_text(text: String, time: float = 1.5):
		tip_label.text = text
		timer.start(time)
		await timer.timeout
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
			if (option_1_stage - 1) >= option_1_options.size():
				error()
				change_tip_text("No more options here!")
				return 1
			if take_yummy(option_1_options[option_1_stage - 1].cost) == 0:
				change_tip_text(option_1_options[option_1_stage - 1].purchase_message)
				option_1(option_1_stage)
				option_1_stage = option_1_stage + 1
				set_option_labels(1)
				purchase()
				return 0
		2: 
			if (option_2_stage - 1) >= option_2_options.size():
				change_tip_text("No more options here!")
				error()
				return 1
			if take_yummy(option_2_options[option_2_stage - 1].cost) == 0:
				change_tip_text(option_2_options[option_2_stage - 1].purchase_message)
				option_2(option_2_stage)
				option_2_stage = option_2_stage + 1
				set_option_labels(2)
				purchase()
				return 0
		3: 
			if (option_3_stage - 1) >= option_3_options.size():
				change_tip_text("No more options here!")
				error()
				return 1
			if take_yummy(option_3_options[option_3_stage - 1].cost) == 0:
				change_tip_text(option_3_options[option_3_stage - 1].purchase_message)
				option_3(option_3_stage)
				option_3_stage = option_3_stage + 1
				set_option_labels(3)
				purchase()
				return 0
	
	change_tip_text("Not enough yummies!")
	error()
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


func set_option_labels(option: int):
	match option:
		1: 
			if (option_1_stage - 1) >= option_1_options.size():
				option_labels[0].text = ""
			else:
				option_labels[0].text = option_1_options[option_1_stage - 1].description
		2: 
			if (option_2_stage - 1) >= option_2_options.size():
				option_labels[1].text = ""
			else:
				option_labels[1].text = option_2_options[option_2_stage - 1].description
		3: 
			if (option_3_stage - 1) >= option_3_options.size():
				option_labels[2].text = ""
			else:
				option_labels[2].text = option_3_options[option_3_stage - 1].description


func option_1(stage: int):
	match stage:
		1: GlobalData.add_chummy(1)
		2: GlobalData.add_chummies_rate(1)
		3: GlobalData.add_chummy(1)
		4: GlobalData.add_chummy_efficiency(1)
		5: GlobalData.add_chummy(2)
		6: GlobalData.add_chummies_rate(1)
		7: GlobalData.add_chummy(2)
		8: GlobalData.add_chummy_efficiency(1)
		9: GlobalData.add_chummy(3)
		10: GlobalData.add_chummies_rate(1)


func option_2(stage: int):
	match stage:
		1: GlobalData.max_collected_yummies = GlobalData.max_collected_yummies + 3
		2: 
			for i in range(GlobalData.yummies_list.size()):
				GlobalData.yummies_list[i].add_speed(-10)
		3: GlobalData.max_collected_yummies = GlobalData.max_collected_yummies + 5
		4: GlobalData.yummies_rate = GlobalData.yummies_rate + 15
		5: GlobalData.max_collected_yummies = GlobalData.max_collected_yummies + 8
		6: 
			var count: int = 0
			for i in range(GlobalData.yummies_list.size()):
				if GlobalData.yummies_list[i - count].bummy_state != Yummy.BummyState.YUMMY:
					GlobalData.yummies_list[i - count].exterminate()
					count = count + 1
				if count >= 5:
					break
		7: GlobalData.max_yummy_invest = GlobalData.max_yummy_invest + 3
		8: GlobalData.yummy_interest = GlobalData.yummy_interest + 0.05
		9: GlobalData.max_yummy_invest = GlobalData.max_yummy_invest + 5
		10: GlobalData.yummy_interest = GlobalData.yummy_interest + 0.05


func option_3(stage: int):
	match stage:
		1: player.speed = player.speed + 15
		2: player.interaction_distance = player.interaction_distance + 10
		3: GameManager.add_time(30)
		4: GlobalData.bummies_chance = GlobalData.bummies_chance - 2
		5: player.speed = player.speed + 15
		6: for yummy: Yummy in GlobalData.yummies_list:
			yummy.set_health(yummy.health + 2)
		7: player.interaction_distance = player.interaction_distance + 10
		8: GlobalData.bummies_chance = GlobalData.bummies_chance - 4
		9: GameManager.add_time(60)
		10: for yummy: Yummy in GlobalData.yummies_list:
				yummy.set_health(yummy.health + 3)


func error():
	AudioManager.try_change_sfx_audio(error_sfx, true)


func purchase():
	AudioManager.try_change_sfx_audio(purchase_sfx, true)
