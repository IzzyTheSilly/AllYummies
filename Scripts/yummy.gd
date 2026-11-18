extends Entity
class_name Yummy


@export_enum("Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Purple") var type: String = "Red"
@export var sprite2d: AnimatedSprite2D
@export var timer: Timer
@export var animation_player: AnimationPlayer
var target: Vector2 = Vector2.ZERO
@export var speed: int = 15
@export var hurry_factor: float = 1.8
@export var wander_distance: int
@export var timer_average: float = 3.0
@export var healthbar: TextureProgressBar

@export var sprites: Array[Texture2D]
var player_position: Vector2

var health: int = 5

enum BehaviourState {IDLE, WANDER, FLEE}
enum BummyState {YUMMY, LOST, GONER, DAMNED}
var behaviour_state = BehaviourState.WANDER
var bummy_state = BummyState.YUMMY


func _ready() -> void:
	animation_player.play("bounce")
	timer.wait_time = timer_average
	healthbar.max_value = health


func _process(delta: float) -> void:
	match behaviour_state:
		BehaviourState.IDLE:
			velocity = Vector2.ZERO
		BehaviourState.WANDER:
			var move_direction = target - position
			move_direction = move_direction.normalized()
			velocity = move_direction * delta * speed
		BehaviourState.FLEE:
			var move_direction = position - player_position
			move_direction = move_direction.normalized()
			velocity = move_direction * delta * speed * hurry_factor
	
	move_and_slide()
	
	if get_slide_collision_count():
		change_state(BehaviourState.WANDER)
		print("collslide")


func _on_timer_timeout() -> void:
	match behaviour_state:
		BehaviourState.IDLE:
			change_state(BehaviourState.WANDER)
		BehaviourState.WANDER:
			change_state(BehaviourState.IDLE)
		BehaviourState.FLEE:
			if randi_range(0, 1):
				change_state(BehaviourState.WANDER)
			else:
				change_state(BehaviourState.IDLE)
	if randi_range(1, 100) < 90:
		set_health(health - 1, false)


func change_state(state: BehaviourState):
	behaviour_state = state
	match state:
		BehaviourState.IDLE:
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
			bummy_state = BummyState.GONER
			set_health(3)
		BummyState.GONER:
			bummy_state = BummyState.DAMNED
			set_health(50)
		BummyState.DAMNED:
			print("die")


func _on_player_detect_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_position = body.position
		change_state(BehaviourState.FLEE)
