extends Node


var options_menu: OptionsMenu
var showing_options: bool = false


func show_options():
	options_menu.show()
	showing_options = true


func hide_options():
	options_menu.hide()
	showing_options = false
