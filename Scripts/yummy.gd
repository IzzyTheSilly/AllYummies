extends Area2D
class_name Yummy


@export_enum("Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Purple") var type: String = "Red"
@export var sprite2d: AnimatedSprite2D
@export var timer: Timer
var target: Vector2 = Vector2.ZERO
@export var speed: int = 15

enum State {IDLE, WANDER, FLEE, CHASE}
var state = State.WANDER


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if state == State.IDLE:
		pass
	elif state == State.WANDER:
		var move_direction = target - position
		move_direction = move_direction.normalized()
		position += move_direction * delta * speed


func _on_timer_timeout() -> void:
	if state == State.IDLE:
		target.x = randf_range(-250, 250)
		target.y = randf_range(-250, 250)
		timer.wait_time = randf_range(0.9, 1.1)
		state = State.WANDER
	else:
		state = State.IDLE
