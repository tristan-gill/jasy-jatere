extends CharacterBody2D
enum State { IDLE, ACTION }

const TILE_SIZE = 16
const ACTION_DURATION = 0.5

var facing_direction: Vector2 = Vector2.RIGHT
var state: State = State.IDLE
var footstep_counter: int = 0

@export var action_queue: ActionQueue

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pivot: Node2D = $Pivot
@onready var footstep_stream_player: AudioStreamPlayer2D = $FootstepStreamPlayer


func _ready() -> void:
	Events.tick.connect(_tick)
	
	Events.position_enemy.connect(_position_enemy)
	Events.direction_enemy.connect(_direction_enemy)
	Events.update_enemy_action_queue.connect(_update_enemy_action_queue)
	
	animate_idle()


func _tick() -> void:
	if not action_queue:
		return
	
	if action_queue.is_empty():
		push_error("Tried to tick on empty enemy action queue")
	
	var next_action = action_queue.get_next()
	handle_action(next_action)


func handle_action(action: Action) -> void:
	state = State.ACTION
	
	if facing_direction.is_equal_approx(action.direction):
		global_position = global_position + (action.direction * TILE_SIZE)
		Events.footstep.emit(global_position)
		footstep_sound()
	else:
		facing_direction = action.direction
		pivot.rotation = action.direction.angle()
	
	animate_idle()
	
	state = State.IDLE


func footstep_sound() -> void:
	footstep_counter = footstep_counter + 1
	
	if footstep_counter % 2 == 0:
		# pitch up
		footstep_stream_player.pitch_scale = randf_range(1.0, 1.2)
	else:
		# pitch down
		footstep_stream_player.pitch_scale = randf_range(0.8, 1.0)
	
	footstep_stream_player.play()


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


func _position_enemy(new_global_position: Vector2) -> void:
	global_position = new_global_position

func _direction_enemy(new_facing_direction: Vector2) -> void:
	facing_direction = new_facing_direction
	pivot.rotation = new_facing_direction.angle()
	animate_idle()

func _update_enemy_action_queue(new_action_queue: ActionQueue) -> void:
	action_queue = new_action_queue
	if action_queue:
		action_queue.reset()
