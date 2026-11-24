extends Entity
class_name Chummy


enum BehaviourState {STOP, IDLE, WANDER}
var behaviour_state: BehaviourState

var yummy_protection_count: int = 0
@export var behaviour_timer: Timer
@export var behaviour_timer_average: float = 3.5
var target: Vector2
@export var wander_range: int
@export var speed: int


func _ready() -> void:
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)
	try_protect_yummies()
	GlobalData.yummies_list_updated.connect(_on_yummies_list_updated)
	behaviour_timer.stop()
	
	var random_cutscene: int = randi_range(0, 2)
	print(random_cutscene)
	match random_cutscene:
		0: cutscene_ids[0] = "chummy_1"
		1: cutscene_ids[0] = "chummy_2"
		2: cutscene_ids[0] = "chummy_3"


func start():
	behaviour_timer.start()
	change_state(BehaviourState.IDLE)


func end():
	change_state(BehaviourState.STOP)


func _physics_process(delta: float) -> void:
	if behaviour_state == BehaviourState.STOP:
		return
	
	var move_direction = Vector2.ZERO
	if (target - position).length() > 5:
		move_direction = (target - position).normalized()
	
	match behaviour_state:
		BehaviourState.IDLE:
			move_direction = Vector2.ZERO
	
	velocity = move_direction * speed
	move_and_slide()


func change_state(state: BehaviourState):
	behaviour_state = state
	match state:
		BehaviourState.STOP:
			behaviour_timer.stop()
		BehaviourState.IDLE:
			target = position
			behaviour_timer.start(behaviour_timer_average + randf_range(-0.5, 0.5))
		BehaviourState.WANDER:
			target = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range)) + position
			behaviour_timer.start(behaviour_timer_average + randf_range(-0.5, 0.5))


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


func _on_behaviour_timer_timeout() -> void:
	match behaviour_state:
		BehaviourState.IDLE:
			change_state(BehaviourState.WANDER)
		BehaviourState.WANDER:
			change_state(BehaviourState.IDLE)
