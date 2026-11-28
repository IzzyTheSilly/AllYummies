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

@export var animated_sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer


func _ready() -> void:
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)
	GlobalData.yummies_list_updated.connect(_on_yummies_list_updated)
	GlobalData.chummy_efficiency_changed.connect(_on_chummy_efficiency_changed)
	behaviour_timer.stop()
	
	var random_cutscene: int = randi_range(0, 6)
	match random_cutscene:
		0: cutscene_ids[0] = "chummy_1"
		1: cutscene_ids[0] = "chummy_2"
		2: cutscene_ids[0] = "chummy_3"
		3: cutscene_ids[0] = "chummy_4"
		4: cutscene_ids[0] = "chummy_5"
		5: cutscene_ids[0] = "chummy_6"
		6: cutscene_ids[0] = "chummy_7"
	
	await get_tree().create_timer(0.5).timeout
	try_protect_yummies()


func start():
	behaviour_timer.start()
	change_state(BehaviourState.IDLE)
	animation_player.play("wander")


func end():
	change_state(BehaviourState.STOP)
	animation_player.stop()


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
	process_animation(move_direction)


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
		if GlobalData.yummies_list[i].chummy or GlobalData.yummies_list[i].bummy_state != Yummy.BummyState.YUMMY:
			continue
		GlobalData.yummies_list[i].set_chummy(self)
		yummy_protection_count = yummy_protection_count + 1


func _on_yummies_list_updated():
	if yummy_protection_count < GlobalData.chummy_efficiency:
		try_protect_yummies()


func _on_chummy_efficiency_changed():
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


func process_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		return
	
	var cardinal_direction: Vector2 = get_direction(direction)
	match cardinal_direction:
		Vector2.UP: animated_sprite.frame = 2
		Vector2.DOWN: animated_sprite.frame = 0
		Vector2.LEFT: animated_sprite.frame = 1
		Vector2.RIGHT: animated_sprite.frame = 3


func get_direction(direction: Vector2) -> Vector2:
	if abs(direction.x) > abs(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if direction.y > 0 else Vector2.UP
