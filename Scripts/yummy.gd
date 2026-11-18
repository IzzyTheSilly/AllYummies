extends Entity
class_name Yummy


@export_enum("Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Purple") var type: String = "Red"
@export var sprite2d: AnimatedSprite2D
@export var timer: Timer
@export var animation_player: AnimationPlayer
var target: Vector2 = Vector2.ZERO
@export var speed: int = 15
@export var wander_distance: int
@export var timer_average: float = 3.0
@export var healthbar: TextureProgressBar

@export var sprites: Array[Texture2D]

var health: int = 5

enum BehaviourState {IDLE, WANDER}
enum BummyState {YUMMY, LOST, GONER, DAMNED}
var behaviour_state = BehaviourState.WANDER
var bummy_state = BummyState.YUMMY


func _ready() -> void:
	animation_player.play("bounce")
	timer.wait_time = timer_average
	healthbar.max_value = health


func _process(delta: float) -> void:
	if behaviour_state == BehaviourState.IDLE:
		pass
	elif behaviour_state == BehaviourState.WANDER:
		var move_direction = target - position
		move_direction = move_direction.normalized()
		position += move_direction * delta * speed


func _on_timer_timeout() -> void:
	if behaviour_state == BehaviourState.IDLE:
		target.x = randf_range(-wander_distance, wander_distance) + position.x
		target.y = randf_range(-wander_distance, wander_distance) + position.y
		timer.wait_time = randf_range(timer_average - 0.1, timer_average + 0.1)
		animation_player.play("bounce")
		behaviour_state = BehaviourState.WANDER
	else:
		animation_player.stop()
		behaviour_state = BehaviourState.IDLE
	if randi_range(1, 100) < 90:
		set_health(health - 1, false)


func _on_body_entered(body: Node2D) -> void: # Collide
	target = 2*position - target


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
