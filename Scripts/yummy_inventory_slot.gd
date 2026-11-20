extends TextureRect
class_name YummyInventorySlot


@export var item_image: Texture
@export var item_image_rect: TextureRect
@export var item_amount: RichTextLabel


func _ready() -> void:
	item_image_rect.texture = item_image


func update_slot(amount: int):
	if !amount:
		item_image_rect.hide()
		item_amount.hide()
	else:
		item_image_rect.show()
		item_amount.show()
		item_amount.text = str(amount)
