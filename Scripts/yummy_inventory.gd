extends Control
class_name YummyInventory


@export var slots: Array[YummyInventorySlot]


func _ready() -> void:
	UIHandler.inventory_panel = self
	for i in range(slots.size()):
		update_inventory_slot(i)


func update_inventory_slot(type: int):
	var collected_yummies_list: Array[Yummy] = GlobalData.collected_yummies_list
	var amount: int = 0
	
	for i in range(collected_yummies_list.size()):
		if !is_instance_valid(collected_yummies_list[i]):
			continue
		if int(collected_yummies_list[i].bummy_state) == type:
			amount = amount + 1
	slots[type].update_slot(amount)
	
