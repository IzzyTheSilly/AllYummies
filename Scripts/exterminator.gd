extends Entity
class_name Exterminator


@export var exterminate_audio: AudioStream


func _on_interact():
	for i in range(GlobalData.collected_yummies_list.size()):
		if GlobalData.collected_yummies_list[i]:
			exterminate_yummy(GlobalData.collected_yummies_list[i])
			break


func exterminate_yummy(yummy: Yummy):
	UIHandler.notify("Yummy exterminated!")
	AudioManager.try_change_sfx_audio(exterminate_audio, true)
	yummy.exterminate()
