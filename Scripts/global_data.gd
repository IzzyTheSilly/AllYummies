extends Node


"""Settings"""
# Audio
var dialogue_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0

# Visuals
var less_vfx: bool = false

# Gameplay
var day_amount: int = 7
var day_length: float = 15
var start_yummies: int = 50
var start_bummies_lost: int = 10
var start_bummies_goner: int = 5
var start_bummies_damned: int = 2
var start_chummies: int = 10
var start_yummies_rate: int = 30
var start_chummies_rate: int = 1
var start_chummy_efficiency: int = 5
var bummies_chance: float = 0.1
var yummy_interest_average: float = 1.1


"""Game Stats"""
var yummies: int = start_yummies
var bummies_lost: int = start_bummies_lost
var bummies_goner: int = start_bummies_goner
var bummies_damned: int = start_bummies_damned
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


func update_gdy():
	gross_domestic_yummy = yummies - bummies_lost - 2*bummies_goner - 5*bummies_damned


func reset_values():
	yummies = start_yummies
	bummies_lost = start_bummies_lost
	bummies_goner = start_bummies_goner
	bummies_damned = start_bummies_damned
	chummies = start_chummies
	gross_domestic_yummy = yummies - bummies_lost - 2*bummies_goner - 5*bummies_damned
	yummies_rate = start_yummies_rate
	chummies_rate =  start_chummies_rate
	chummy_efficiency = start_chummy_efficiency
	yummies_in_stock_market = 0
	max_yummy_pull = 5
	yummy_interest = yummy_interest_average


"""Flags"""
@export var flags: Array[bool]


func reset_flags():
	for flag in flags:
		flag = false
