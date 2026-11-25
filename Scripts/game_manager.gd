extends Node


signal game_start
signal game_end

@export var day_timer: Timer
var ending_screen: EndingScreen
@export var ending_cutscenes_ids: Array[String]

var yummy_spawner: YummySpawner


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
	in_game = true
	ending_screen.hide()


func end_game():
	game_end.emit()
	stop_day_timer()
	in_game = false
	ending_screen.show()
	UIHandler.set_menu_showing(UIHandler.Menu.NONE, false)
	var end_screen_tween: Tween = get_tree().create_tween()
	end_screen_tween.tween_property(ending_screen, "modulate", Color(255, 255, 255), 3)
	await end_screen_tween.finished
	var score: int = GlobalData.update_gdy()
	await ending_screen.show_score(score)
	
	if score > 100:
		await CutsceneHandler.show_cutscene(ending_cutscenes_ids[0])
	elif score > 50:
		await CutsceneHandler.show_cutscene(ending_cutscenes_ids[1])
	elif score > 20:
		await CutsceneHandler.show_cutscene(ending_cutscenes_ids[2])
	elif score < 0:
		await CutsceneHandler.show_cutscene(ending_cutscenes_ids[3])
	
	ending_screen.hide_score()
	await get_tree().create_timer(2).timeout
	GlobalData.reset_game_stats()
	GlobalData.reset_local_flags()
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


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


func spawn_yummy_in_inventory(amount: int):
	for i in range(amount):
		yummy_spawner.spawn_yummy_in_inventory()
