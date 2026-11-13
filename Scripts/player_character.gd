extends CharacterBody2D
class_name Player

@export var test_dialogue: DialogueData
@export var test_cutscene: CutsceneData

@export var speed: int
@export var interaction_raycast: RayCast2D
@export var interaction_distance: int
@export var interaction_cooldown: float
##How many things the player can interact with at once.
@export var interaction_stacking: int

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if !CutsceneHandler.in_cutscene and !OptionsHandler.showing_options:
		direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		direction = direction.normalized()
	
	if direction:
		interaction_raycast.position = -direction * 9
		interaction_raycast.target_position = direction * interaction_distance
	velocity = direction * speed * delta
	
	if Input.is_action_just_pressed("interact"):
		# test functions, delete later when implementing entity interaction
		if interaction_raycast.get_collider() and !CutsceneHandler.in_cutscene and !OptionsHandler.showing_options:
			CutsceneHandler.show_cutscene(test_cutscene)
		elif CutsceneHandler.in_cutscene:
			CutsceneHandler.hide_dialogue()
	
	if Input.is_action_pressed("options"):
		if CutsceneHandler.in_cutscene:
			CutsceneHandler.hide_dialogue()
		elif Input.is_action_just_pressed("options"):
			if OptionsHandler.showing_options:
				OptionsHandler.hide_options()
			else:
				OptionsHandler.show_options()
	
	move_and_slide()
