extends Entity
class_name Yummy


@export_enum("Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Purple") var type: int = 0
@export var timer: Timer
@export var animation_player: AnimationPlayer
var target: Vector2 = Vector2.ZERO
@export var speed: int = 15
@export var hurry_factor: float = 1.8
@export var wander_distance: int
@export var timer_average: float = 3.0
@export var healthbar: TextureProgressBar
@export var protected_healthbar_texture: Texture
@export var unprotected_healthbar_texture: Texture
var health: int = 5
@export var health_loss_chance: int = 50

@export var collect_sfx: AudioStream

enum BehaviourState {IDLE, WANDER, FLEE, COLLECTING, COLLECTED, DROPPING}
enum BummyState {YUMMY, LOST, GONER, DAMNED}
var behaviour_state = BehaviourState.WANDER
var bummy_state = BummyState.YUMMY
var chummy: Chummy


func _ready() -> void:
	GlobalData.add_yummy(self)
	healthbar.max_value = health
	if randi_range(0, 1):
		change_state(BehaviourState.IDLE)
	else:
		change_state(BehaviourState.WANDER)


func _process(delta: float) -> void:
	if behaviour_state == BehaviourState.COLLECTED:
		return
	
	var move_direction = Vector2.ZERO
	if (target - position).length() > 5:
		move_direction = (target - position).normalized()
	
	match behaviour_state:
		BehaviourState.IDLE:
			move_direction = Vector2.ZERO
		BehaviourState.FLEE:
			move_direction = move_direction * hurry_factor
	
	velocity = move_direction * speed
	move_and_slide()
	
	if get_slide_collision_count():
		change_state(BehaviourState.WANDER)


func _on_timer_timeout() -> void:
	match behaviour_state:
		BehaviourState.IDLE:
			change_state(BehaviourState.WANDER)
		BehaviourState.WANDER:
			change_state(BehaviourState.IDLE)
		BehaviourState.FLEE:
			change_state(BehaviourState.IDLE)
	if randi_range(1, 100) < health_loss_chance and !chummy:
		set_health(health - 1, false)


func change_state(state: BehaviourState):
	if (
		behaviour_state == BehaviourState.COLLECTING and 
		state != BehaviourState.COLLECTED and 
		state != BehaviourState.DROPPING
		):
		return
	
	behaviour_state = state
	match state:
		BehaviourState.IDLE:
			target = position
			animation_player.play("idle")
			timer.start(randf_range(timer_average - 0.7, timer_average - 0.5))
		BehaviourState.WANDER:
			target.x = randf_range(-wander_distance, wander_distance) + position.x
			target.y = randf_range(-wander_distance, wander_distance) + position.y
			animation_player.play("bounce")
			timer.start(randf_range(timer_average - 0.1, timer_average + 0.1))
		BehaviourState.FLEE:
			animation_player.play("hurry")
			timer.start(3.5)
		BehaviourState.COLLECTING:
			target = position
			animation_player.play("collect")
			timer.start(0.5)
		BehaviourState.COLLECTED:
			hide()
			timer.stop()
		BehaviourState.DROPPING:
			show()
			animation_player.play("drop")
			GlobalData.update_collected_yummies(type, -1, true)


func _on_interact():
	if behaviour_state != BehaviourState.COLLECTING:
		if GlobalData.try_collect_yummy(self):
			return
		
		AudioManager.try_change_sfx_audio(collect_sfx, true)
		change_state(BehaviourState.COLLECTING)
		await animation_player.animation_finished
		if behaviour_state != BehaviourState.DROPPING:
			change_state(BehaviourState.COLLECTED)


func set_health(health: int, set_healthbar: bool = true):
	self.health = health
	healthbar.value = health
	if set_healthbar:
		healthbar.max_value = health
	if health == 0:
		health_zero()


func health_zero():
	match bummy_state:
		BummyState.YUMMY:
			bummy_state = BummyState.LOST
			set_health(3)
		BummyState.LOST:
			GlobalData.update_yummy_amount(-1, 0, true)
			GlobalData.update_yummy_amount(1, 1, true)
			bummy_state = BummyState.GONER
			GlobalData.update_yummy_amount(-1, 1, true)
			GlobalData.update_yummy_amount(1, 2, true)
			set_health(3)
		BummyState.GONER:
			GlobalData.update_yummy_amount(-1, 2, true)
			GlobalData.update_yummy_amount(1, 3, true)
			bummy_state = BummyState.DAMNED
			set_health(50)
		BummyState.DAMNED:
			print("die")


func _on_player_detect_area_body_entered(body: Node2D) -> void:
	if body is Player and behaviour_state != BehaviourState.DROPPING:
		target = position + 7*(position - body.position)
		change_state(BehaviourState.FLEE)


func set_chummy(chummy: Chummy):
	self.chummy = chummy
	healthbar.texture_progress = protected_healthbar_texture
	health = 5


func unset_chummy():
	chummy = null
	healthbar.texture_progress = unprotected_healthbar_texture


func drop(position: Vector2):
	self.position = position
	change_state(BehaviourState.DROPPING)
	await animation_player.animation_finished
	change_state(BehaviourState.IDLE)


func exterminate():
	if chummy:
		chummy.remove_yummy(self)
	GlobalData.remove_yummy(self)
	queue_free()
