extends Entity
class_name Exterminator


func _on_interact():
	for i in range(GlobalData.collected_yummies_list.size()):
		if GlobalData.collected_yummies_list[i]:
			exterminate_yummy(GlobalData.collected_yummies_list[i])


func exterminate_yummy(yummy: Yummy):
	UIHandler.notify("Yummy exterminated!")
	yummy.exterminate()
