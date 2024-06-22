class_name Player
extends CharacterBody2D


enum State { IDLE, ACTION }

const TILE_SIZE = 16
const ACTION_DURATION = 0.5

var facing_direction: Vector2 = Vector2.RIGHT
var state: State = State.IDLE
var last_action: Action
var footstep_counter: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var ray_cast_up: RayCast2D = $Raycasts/RayCastUp
@onready var ray_cast_right: RayCast2D = $Raycasts/RayCastRight
@onready var ray_cast_down: RayCast2D = $Raycasts/RayCastDown
@onready var ray_cast_left: RayCast2D = $Raycasts/RayCastLeft

@onready var vision_block: ColorRect = $VisionBlock

@onready var footstep_stream_player: AudioStreamPlayer2D = $FootstepStreamPlayer


func _ready() -> void:
	animate_idle()
	
	Events.position_player.connect(_position_player)
	Events.direction_player.connect(_direction_player)
	Events.caught_by_enemy.connect(_caught_by_enemy)
	
	Events.toggle_eyes.connect(_toggle_eyes)

func _caught_by_enemy() -> void:
	vision_block.hide()

func _toggle_eyes() -> void:
	vision_block.visible = !vision_block.visible

func _physics_process(delta: float) -> void:
	if state == State.IDLE:
		handle_input()


func perform_action(action: Action) -> void:
	if state == State.ACTION:
		push_error("Tried to perform action when already actioning")
		return
	
	state = State.ACTION
	
	if facing_direction.is_equal_approx(action.direction):
		if can_move_in_direction(action.direction):
			global_position = global_position + (action.direction * TILE_SIZE)
			footstep_sound()
	elif action.direction:
		facing_direction = action.direction
	
	animate_idle()
	
	state = State.IDLE


func can_move_in_direction(direction: Vector2) -> bool:
	if direction.is_equal_approx(Vector2.UP):
		return not ray_cast_up.is_colliding()
	if direction.is_equal_approx(Vector2.RIGHT):
		return not ray_cast_right.is_colliding()
	if direction.is_equal_approx(Vector2.DOWN):
		return not ray_cast_down.is_colliding()
	if direction.is_equal_approx(Vector2.LEFT):
		return not ray_cast_left.is_colliding()
	
	return true

func animate_idle() -> void:
	if facing_direction == Vector2.RIGHT:
		animation_player.play("idle_e")
	elif facing_direction == Vector2.LEFT:
		animation_player.play("idle_w")
	elif facing_direction == Vector2.UP:
		animation_player.play("idle_n")
	elif facing_direction == Vector2.DOWN:
		animation_player.play("idle_s")

func animate_run() -> void:
	if facing_direction == Vector2.RIGHT:
		animation_player.play("run_e")
	elif facing_direction == Vector2.LEFT:
		animation_player.play("run_w")
	elif facing_direction == Vector2.UP:
		animation_player.play("run_n")
	elif facing_direction == Vector2.DOWN:
		animation_player.play("run_s")


func footstep_sound() -> void:
	footstep_counter = footstep_counter + 1
	
	if footstep_counter % 2 == 0:
		# pitch up
		footstep_stream_player.pitch_scale = randf_range(1.0, 1.2)
	else:
		# pitch down
		footstep_stream_player.pitch_scale = randf_range(0.8, 1.0)
	
	footstep_stream_player.play()

func handle_input() -> void:
	var action: Action
	if Input.is_action_just_pressed("input_up"):
		action = Action.new(Vector2.UP)
	elif Input.is_action_just_pressed("input_down"):
		action = Action.new(Vector2.DOWN)
	elif Input.is_action_just_pressed("input_left"):
		action = Action.new(Vector2.LEFT)
	elif Input.is_action_just_pressed("input_right"):
		action = Action.new(Vector2.RIGHT)
	elif Input.is_action_just_pressed("input_wait"):
		action = Action.new(Vector2.ZERO)
	
	if Input.is_action_just_pressed("input_toggle_eyes"):
		Events.toggle_eyes.emit()
		Events.check_vision.emit()
	
	if action:
		last_action = action
		perform_action(action)
		Events.tick.emit()
		
		Events.check_vision.emit()


func _position_player(new_global_position: Vector2) -> void:
	global_position = new_global_position

func _direction_player(new_facing_direction: Vector2) -> void:
	facing_direction = new_facing_direction
	animate_idle()
