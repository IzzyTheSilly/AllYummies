extends Entity
class_name Chummy


enum BehaviourState {IDLE, WANDER}
var behaviour_state: BehaviourState

var yummy_protection_count: int = 0


func _ready() -> void:
	try_protect_yummies()
	GlobalData.yummies_list_updated.connect(_on_yummies_list_updated)


func _physics_process(delta: float) -> void:
	match behaviour_state:
		BehaviourState.IDLE:
			pass
		BehaviourState.WANDER:
			pass


func try_protect_yummies():
	for i in range(GlobalData.yummies_list.size()):
		if yummy_protection_count >= GlobalData.chummy_efficiency:
			break
		if GlobalData.yummies_list[i].chummy != null:
			continue
		GlobalData.yummies_list[i].set_chummy(self)
		yummy_protection_count = yummy_protection_count + 1


func _on_yummies_list_updated():
	if yummy_protection_count < GlobalData.chummy_efficiency:
		try_protect_yummies()


func remove_yummy(yummy: Yummy):
	yummy.chummy = null
	yummy_protection_count = yummy_protection_count - 1
