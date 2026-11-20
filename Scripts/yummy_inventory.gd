extends Control
class_name YummyInventory


@export var slots: Array[YummyInventorySlot]


func _ready() -> void:
	UIHandler.inventory_panel = self


func update_inventory_slot(yummy_color_index):
	slots[yummy_color_index].update_slot(GlobalData.collected_yummies_amounts[yummy_color_index])
