extends Entity
class_name Exterminator


@export var exterminate_audio: AudioStream
@export var splash_effects: Array[AnimatedSprite2D]


func _on_interact():
	for i in range(GlobalData.collected_yummies_list.size()):
		if GlobalData.collected_yummies_list[i]:
			exterminate_yummy(GlobalData.collected_yummies_list[i])
			return
	UIHandler.notify("No yummies to exterminate!")


func exterminate_yummy(yummy: Yummy):
	UIHandler.notify("Yummy exterminated!")
	AudioManager.try_change_sfx_audio(exterminate_audio, true)
	yummy.exterminate()
	
	splash_effects[randi_range(0, splash_effects.size() - 1)].play()
