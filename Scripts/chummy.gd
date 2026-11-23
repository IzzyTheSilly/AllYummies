extends Entity
class_name Chummy


func _ready() -> void:
	protect_yummies()


func protect_yummies():
	var yummy_protection_count: int = 0
	for i in range(GlobalData.yummies_list.size()):
		if yummy_protection_count >= GlobalData.chummy_efficiency:
			break
		if GlobalData.yummies_list[i].chummy != null:
			continue
		GlobalData.yummies_list[i].set_chummy(self)
