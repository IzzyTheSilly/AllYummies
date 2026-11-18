extends CharacterBody2D
class_name Player


@export var speed: int
@export var sprint_speed: float = 1.5
@export var interaction_raycast: RayCast2D
@export var interaction_distance: int
@export var interaction_cooldown: float
##How many yummies the player can collect with at once.
@export var collection_stacking: int

var collected_yummies: Array[Yummy]


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if !CutsceneHandler.in_cutscene and !OptionsHandler.showing_options:
		direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		direction = direction.normalized()
	
	if direction:
		interaction_raycast.position = -direction * 9
		interaction_raycast.target_position = direction * interaction_distance
	if Input.is_action_pressed("cancel"):
		delta = delta * 1.5
	velocity = direction * speed * delta
	
	process_interaction()
	
	move_and_slide()


func process_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		if (
				interaction_raycast.get_collider() and 
				!CutsceneHandler.in_cutscene and 
				!OptionsHandler.showing_options and 
				interaction_raycast.get_collider() is Entity
			):
			interaction_raycast.get_collider()._on_interact()
		elif CutsceneHandler.in_cutscene:
			if !CutsceneHandler.in_dialogue_choice:
				CutsceneHandler.hide_dialogue()
			else:
				CutsceneHandler.select_current_choice()
	
	if Input.is_action_pressed("options"):
		if CutsceneHandler.in_cutscene:
			CutsceneHandler.hide_dialogue()
		elif Input.is_action_just_pressed("options"):
			if OptionsHandler.showing_options:
				OptionsHandler.hide_options()
			else:
				OptionsHandler.show_options()
	
	if Input.is_action_just_pressed("move_left") and CutsceneHandler.in_dialogue_choice:
		CutsceneHandler.change_currently_selected_choice(-1)
	if Input.is_action_just_pressed("move_right") and CutsceneHandler.in_dialogue_choice:
		CutsceneHandler.change_currently_selected_choice(1)
