extends Node


var options_menu: OptionsMenu
var showing_options: bool = false


func show_options():
	options_menu.show()
	#options_menu.animation_player.play("show")
	showing_options = true


func hide_options():
	options_menu.hide()
	#options_menu.animation_player.play("hide")
	showing_options = false
