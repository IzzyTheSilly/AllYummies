extends CharacterBody2D
class_name Player


@export var speed: int
@export var sprint_speed: float = 1.5
@export var interaction_raycast: RayCast2D
@export var interaction_distance: int
@export var interaction_cooldown: float
##How many yummies the player can collect with at once.
@export var collection_stacking: int

var auto_moving: bool = false
var auto_moving_direction: Vector2


func _ready() -> void:
	CutsceneHandler.player = self


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if !CutsceneHandler.in_cutscene and !UIHandler.showing_menu() and !auto_moving:
		direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		direction = direction.normalized()
	elif auto_moving:
		direction = auto_moving_direction
	
	if direction:
		interaction_raycast.position = -direction * 9
		interaction_raycast.target_position = direction * interaction_distance
	if Input.is_action_pressed("cancel"):
		direction = direction * 1.5
	velocity = direction * speed
	
	process_interaction()
	
	move_and_slide()


func process_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		interaction_raycast.force_raycast_update()
		print("interact")
		var collider
		if interaction_raycast.get_collider():
			collider = interaction_raycast.get_collider()
		if (
				UIHandler.menu_showing != UIHandler.Menu.NONE and 
				UIHandler.menu_showing != UIHandler.Menu.OPTIONS
			):
			UIHandler.set_menu_showing(UIHandler.menu_showing, false)
		elif (
				collider and 
				!CutsceneHandler.in_cutscene and 
				!UIHandler.showing_menu() and 
				collider is Entity
			):
			collider._on_interact()
		elif CutsceneHandler.in_cutscene:
			if !CutsceneHandler.in_dialogue_choice:
				CutsceneHandler.hide_dialogue()
			else:
				CutsceneHandler.select_current_choice()
	
	if Input.is_action_pressed("options"):
		if CutsceneHandler.in_cutscene:
			CutsceneHandler.hide_dialogue()
		elif Input.is_action_just_pressed("options"):
			if UIHandler.menu_showing == UIHandler.Menu.OPTIONS:
				UIHandler.set_menu_showing(UIHandler.Menu.OPTIONS, false)
			else:
				UIHandler.set_menu_showing(UIHandler.Menu.OPTIONS, true)
	
	if Input.is_action_just_pressed("cancel"):
		if !UIHandler.showing_menu() and !CutsceneHandler.in_cutscene:
			drop_yummy()
	
	if Input.is_action_just_pressed("move_left") and CutsceneHandler.in_dialogue_choice:
		CutsceneHandler.change_currently_selected_choice(-1)
	if Input.is_action_just_pressed("move_right") and CutsceneHandler.in_dialogue_choice:
		CutsceneHandler.change_currently_selected_choice(1)


func drop_yummy():
	if GlobalData.collected_yummies_list.size() > 0:
		GlobalData.collected_yummies_list[0].drop(position)


func auto_move(direction: Vector2, time: float):
	auto_moving_direction = direction
	auto_moving = true
	await get_tree().create_timer(time).timeout
	auto_moving = false
