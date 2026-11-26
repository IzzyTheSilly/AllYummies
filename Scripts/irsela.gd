extends Entity
class_name Irsela


@export var player: Player
@export var animated_sprite: AnimatedSprite2D


func _process(delta: float) -> void:
	var direction_to_player: Vector2 = player.position - position
	var direction_facing: Vector2 = get_direction(direction_to_player)
	match direction_facing:
		Vector2.DOWN: animated_sprite.frame = 0
		Vector2.LEFT: animated_sprite.frame = 1
		Vector2.UP: animated_sprite.frame = 2
		Vector2.RIGHT: animated_sprite.frame = 3


func get_direction(direction: Vector2) -> Vector2:
	if abs(direction.x) > abs(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if direction.y > 0 else Vector2.UP
