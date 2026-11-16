extends Area2D
class_name Yummy


@export_enum("Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Purple") var type: String = "Red"
@export var sprite2d: AnimatedSprite2D
@export var timer: Timer
@export var animation_player: AnimationPlayer
var target: Vector2 = Vector2.ZERO
@export var speed: int = 15

enum BehaviourState {IDLE, WANDER}
enum BummyState {YUMMY, LOST, GONER, DAMNED}
var behaviour_state = BehaviourState.WANDER
var bummy_state = BummyState.YUMMY


func _ready() -> void:
	animation_player.play("bounce")


func _process(delta: float) -> void:
	if behaviour_state == BehaviourState.IDLE:
		pass
	elif behaviour_state == BehaviourState.WANDER:
		var move_direction = target - position
		move_direction = move_direction.normalized()
		position += move_direction * delta * speed


func _on_timer_timeout() -> void:
	if behaviour_state == BehaviourState.IDLE:
		target.x = randf_range(-250, 250)
		target.y = randf_range(-250, 250)
		timer.wait_time = randf_range(0.9, 1.1)
		behaviour_state = BehaviourState.WANDER
	else:
		behaviour_state = BehaviourState.IDLE
