extends CharacterBody2D
class_name Player


@export var speed: int
@export var sprint_speed: float = 1.5
@export var interaction_raycast: RayCast2D
@export var interaction_distance: int
@export var interaction_cooldown: float
##How many yummies the player can collect with at once.
@export var collection_stacking: int

@export var animated_sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer

var auto_moving: bool = false
var auto_moving_direction: Vector2

var game_end: bool = false


func _ready() -> void:
	CutsceneHandler.player = self
	UIHandler.trading_station_menu.player = self
	GameManager.game_end.connect(_on_game_end)
	GameManager.stop_day_timer()


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if !CutsceneHandler.in_cutscene and !UIHandler.showing_menu() and !auto_moving and !game_end:
		direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		direction = direction.normalized()
	elif auto_moving:
		direction = auto_moving_direction
	
	if direction:
		interaction_raycast.position = -direction * 9
		interaction_raycast.target_position = direction * interaction_distance
	velocity = direction * speed
	
	process_animation(direction)
	
	if !GameManager.ending:
		process_interaction()
	
	move_and_slide()


func process_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		interaction_raycast.force_raycast_update()
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
			if UIHandler.menu_showing != UIHandler.Menu.NONE:
				if UIHandler.menu_showing == UIHandler.Menu.OPTIONS:
					UIHandler.set_menu_showing(UIHandler.Menu.OPTIONS, false)
			else:
				UIHandler.set_menu_showing(UIHandler.Menu.OPTIONS, true)
	
	if Input.is_action_just_pressed("cancel"):
		if !CutsceneHandler.in_cutscene:
			if !UIHandler.showing_menu():
				drop_yummy()
			elif UIHandler.menu_showing == UIHandler.Menu.TRADING_STATION:
				UIHandler.do_trade()
			elif UIHandler.menu_showing == UIHandler.Menu.INVESTING_STATION:
				UIHandler.invest_yummy()
	
	if CutsceneHandler.in_dialogue_choice:
		if Input.is_action_just_pressed("move_left"):
			CutsceneHandler.change_currently_selected_choice(-1)
		if Input.is_action_just_pressed("move_right"):
			CutsceneHandler.change_currently_selected_choice(1)
	if UIHandler.menu_showing == UIHandler.Menu.TRADING_STATION:
		if Input.is_action_just_pressed("move_up"):
			UIHandler.change_select_trading_station(-1)
		if Input.is_action_just_pressed("move_down"):
			UIHandler.change_select_trading_station(1)
	if UIHandler.menu_showing == UIHandler.Menu.INVESTING_STATION:
		if Input.is_action_just_pressed("move_left"):
			UIHandler.change_select_investing_station(-1)
		if Input.is_action_just_pressed("move_right"):
			UIHandler.change_select_investing_station(1)


func process_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		animation_player.play("stop")
		return
	
	var cardinal_direction: Vector2 = get_direction(direction)
	animation_player.play("walk")
	match cardinal_direction:
		Vector2.UP:
			animated_sprite.play("up")
		Vector2.DOWN:
			animated_sprite.play("down")
		Vector2.LEFT:
			animated_sprite.play("left")
		Vector2.RIGHT:
			animated_sprite.play("right")


func drop_yummy():
	if GlobalData.collected_yummies_list.size() > 0:
		GlobalData.collected_yummies_list[0].drop(position)


func auto_move(direction: Vector2, time: float):
	auto_moving_direction = direction
	auto_moving = true
	await get_tree().create_timer(time).timeout
	auto_moving = false


func _on_game_end():
	game_end = true


func get_direction(direction: Vector2) -> Vector2:
	if abs(direction.x) > abs(direction.y):
		return Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if direction.y > 0 else Vector2.UP
