extends Node


var options_menu: OptionsMenu
var showing_options: bool = false
var start_position_y: float # starts hidden
var current_tween: Tween


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left") and showing_options:
		options_menu._on_previous_page_button_pressed()
	elif Input.is_action_just_pressed("move_right") and showing_options:
		options_menu._on_next_page_button_pressed()


func show_options():
	if showing_options:
		return
	if current_tween:
		current_tween.kill()
	var show_tween = get_tree().create_tween()
	current_tween = show_tween
	var duration: float = 0.4 * (((start_position_y - options_menu.position.y) / 300) + 1)
	show_tween.tween_property(options_menu, "position:y", start_position_y + 300, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	showing_options = true


func hide_options():
	if !showing_options:
		return
	if current_tween:
		current_tween.kill()
	var hide_tween = get_tree().create_tween()
	current_tween = hide_tween
	var duration: float = 0.4 * (options_menu.position.y - start_position_y) / 300
	hide_tween.tween_property(options_menu, "position:y", start_position_y, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	get_viewport().gui_release_focus()
	showing_options = false
