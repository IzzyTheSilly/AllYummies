extends Node


"""Settings"""
# Audio
var dialogue_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0

# Visuals
var less_vfx: bool = false

# Gameplay
var day_amount: int = 5
var day_length: float = 10
var start_yummies: int = 25
var start_chummies: int = 10
var start_yummies_rate: int = 30
var start_chummies_rate: int = 1
var start_chummy_efficiency: int = 2
var bummies_chance: float = 0.1
var yummy_interest_average: float = 1.1


"""Game Stats"""
var yummies: int = start_yummies
var bummies_lost: int = 0
var bummies_goner: int = 0
var bummies_damned: int = 0
var chummies: int = start_chummies
var gross_domestic_yummy: int = yummies - bummies_lost - 2*bummies_goner - 5*bummies_damned

##New yummy production rate per minute.
var yummies_rate: int = start_yummies_rate
##Chummies coming into the kingdom per minute.
var chummies_rate: int = start_chummies_rate
##How many yummies are secured by one chummy.
var chummy_efficiency: int = start_chummy_efficiency

##Amount of yummies in the stock market, will not count towards total GDY.
var yummies_in_stock_market: int = 0
##Maximum amount of yummies you can pull from the stock market.
var max_yummy_pull: int = 5
##How many extra yummies you get in the stock market per minute.
var yummy_interest: float = yummy_interest_average

var max_collected_yummies: int = 3
var collected_yummies_amounts: Array[int]
var total_yummies_collected: int = 0

var days_left: int = day_amount

func update_collected_yummies(yummy_color_index: int, amount: int, add: bool = false):
	if add:
		collected_yummies_amounts[yummy_color_index] = collected_yummies_amounts[yummy_color_index] + amount
	else:
		collected_yummies_amounts[yummy_color_index] = amount
	var total: int
	for i in range(7):
		total = total + collected_yummies_amounts[i]
	total_yummies_collected = total


func try_collect_yummy(yummy: Yummy) -> int:
	if total_yummies_collected >= max_collected_yummies:
			return 1
	update_collected_yummies(yummy.type, 1, true)
	return 0


func update_yummy_amount(amount: int, type: int, add: bool = false):
	match type:
		0: yummies = yummies + amount if add else amount
		1: bummies_lost = bummies_lost + amount if add else amount
		2: bummies_goner = bummies_goner + amount if add else amount
		3: bummies_damned = bummies_damned + amount if add else amount


func total_bummies() -> int:
	return bummies_lost + bummies_goner + bummies_damned


func update_gdy() -> int:
	print("update gdy")
	gross_domestic_yummy = yummies - bummies_lost - 2*bummies_goner - 5*bummies_damned
	return gross_domestic_yummy


func reset_game_stats():
	yummies = start_yummies
	bummies_lost = 0
	bummies_goner = 0
	bummies_damned = 0
	chummies = start_chummies
	yummies_rate = start_yummies_rate
	chummies_rate =  start_chummies_rate
	chummy_efficiency = start_chummy_efficiency
	yummies_in_stock_market = 0
	max_yummy_pull = 5
	yummy_interest = yummy_interest_average
	update_gdy()


"""Local Flags"""
@export var local_flags: Dictionary[String, int]


func reset_local_flags():
	for flag in local_flags:
		local_flags[flag] = false


"""Global Flags"""
@export var global_flags: Dictionary[String, int]


func _ready() -> void:
	collected_yummies_amounts.resize(7)
