extends Area2D
class_name Yummy


@export_enum("Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Purple") var type: String = "Red"
@export var sprite2d: AnimatedSprite2D
@export var timer: Timer
@export var animation_player: AnimationPlayer
var target: Vector2 = Vector2.ZERO
@export var speed: int = 15
@export var wander_distance: int
@export var timer_average: float = 3.0

enum BehaviourState {IDLE, WANDER}
enum BummyState {YUMMY, LOST, GONER, DAMNED}
var behaviour_state = BehaviourState.WANDER
var bummy_state = BummyState.YUMMY


func _ready() -> void:
	animation_player.play("bounce")
	timer.wait_time = timer_average


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
		behaviour_state = BehaviourState.WANDER
	else:
		behaviour_state = BehaviourState.IDLE


func _on_body_entered(body: Node2D) -> void: # Collide
	target = 2*position - target
