extends Node


signal game_start
signal game_end

@export var day_timer: Timer


##Not in the title screen.
var in_game: bool = false
##Currently collecting yummies, not in cutscene.
var in_gameplay: bool = false
var days_left: int


func _ready() -> void:
	days_left = GlobalData.day_amount
	stop_day_timer()


func start_game():
	game_start.emit()
	reset_day_timer()


func end_game():
	game_end.emit()
	stop_day_timer()


func reset_day_timer():
	day_timer.wait_time = GlobalData.day_length * 60
	day_timer.start()


func stop_day_timer():
	day_timer.stop()


func get_day_time_left() -> float:
	return floor(day_timer.time_left)


func add_time(time: int):
	day_timer.start(day_timer.time_left + 30)


func _on_day_timer_timeout() -> void:
	end_game()
	UIHandler.notify("Day End!")
	if days_left == 1:
		pass
	else:
		days_left = days_left - 1
		stop_day_timer()
