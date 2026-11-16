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
var start_yummies: int = 200
var start_bummies_lost: int = 40
var start_bummies_goner: int = 15
var start_bummies_damned: int = 6
var start_chummies: int = 10
var start_yummies_rate: int = 30
var start_chummies_rate: int = 1
var bummies_chance: float = 0.1
var yummy_interest_average: float = 1.1


"""Game Stats"""
var yummies: int = start_yummies
var bummies_lost: int = start_bummies_lost
var bummies_goner: int = start_bummies_goner
var bummies_damned: int = start_bummies_damned
var chummies: int = start_chummies

##New yummy production rate per minute.
var yummies_rate: int = 30
##Chummies coming into the kingdom per minute.
var chummies_rate: int = 1

var yummies_in_stock_market: int = 0
##How many extra yummies you get in the stock market per minute.
var yummy_interest: float = yummy_interest_average
