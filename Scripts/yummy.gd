extends Entity
class_name Yummy


@export_enum("Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Purple") var type: int = 0
@export var behaviour_timer: Timer
@export var collision_shape: CollisionShape2D
@export var animation_player: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
var target: Vector2 = Vector2.ZERO
@export var speed: int = 65
@export var hurry_factor: float = 2.5
@export var wander_distance: int = 500
@export var timer_average: float = 3.0
@export var healthbar: TextureProgressBar
@export var protected_healthbar_texture: Texture
@export var unprotected_healthbar_texture: Texture
var health: int = 5
var health_loss_chance: int

@export var collect_sfx: AudioStream

enum BehaviourState {STOP, IDLE, WANDER, FLEE, COLLECTING, COLLECTED, DROPPING, INVESTED}
enum BummyState {YUMMY, LOST, GONER, DAMNED}
var behaviour_state = BehaviourState.STOP
var bummy_state = BummyState.YUMMY
var chummy: Chummy


func _ready() -> void:
	GameManager.game_start.connect(start)
	GameManager.game_end.connect(end)
	healthbar.max_value = health
	health_loss_chance = GlobalData.bummies_chance


func start():
	behaviour_timer.start()
	if randi_range(0, 1):
		change_state(BehaviourState.IDLE)
	else:
		change_state(BehaviourState.WANDER)


func end():
	change_state(BehaviourState.STOP)


func _process(delta: float) -> void:
	if behaviour_state == BehaviourState.COLLECTED or behaviour_state == BehaviourState.STOP:
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
		BehaviourState.STOP:
			behaviour_timer.stop()
		BehaviourState.IDLE:
			target = position
			animation_player.play("idle", 0.1)
			behaviour_timer.start(randf_range(timer_average - 0.7, timer_average - 0.5))
		BehaviourState.WANDER:
			target.x = randf_range(-wander_distance, wander_distance) + position.x
			target.y = randf_range(-wander_distance, wander_distance) + position.y
			animation_player.play("bounce", 0.1)
			behaviour_timer.start(randf_range(timer_average - 0.1, timer_average + 0.1))
		BehaviourState.FLEE:
			animation_player.play("hurry", 0.05)
			behaviour_timer.start(3.5)
		BehaviourState.COLLECTING:
			target = position
			animation_player.play("collect", 0.075)
			behaviour_timer.stop()
			collision_shape.disabled = true
		BehaviourState.COLLECTED:
			hide()
			behaviour_timer.stop()
		BehaviourState.DROPPING:
			show()
			animation_player.play("drop", 0.075)
			GlobalData.remove_collected_yummy(self)
			collision_shape.disabled = false


func _on_interact():
	if behaviour_state != BehaviourState.COLLECTING:
		if GlobalData.add_collected_yummy(self):
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
			animated_sprite.frame = 1
			add_speed(-10)
			GlobalData.update_yummy_amount(-1, 0, true)
			GlobalData.update_yummy_amount(1, 1, true)
			set_health(3)
		BummyState.LOST:
			bummy_state = BummyState.GONER
			animated_sprite.frame = 2
			add_speed(-10)
			GlobalData.update_yummy_amount(-1, 1, true)
			GlobalData.update_yummy_amount(1, 2, true)
			set_health(3)
		BummyState.GONER:
			bummy_state = BummyState.DAMNED
			animated_sprite.frame = 3
			add_speed(-10)
			GlobalData.update_yummy_amount(-1, 2, true)
			GlobalData.update_yummy_amount(1, 3, true)
			set_health(50)


func _on_player_detect_area_body_entered(body: Node2D) -> void:
	if body is Player and behaviour_state != BehaviourState.DROPPING and behaviour_state != BehaviourState.STOP:
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


func add_speed(amount: int):
	speed = speed + amount


func invest():
	pass
