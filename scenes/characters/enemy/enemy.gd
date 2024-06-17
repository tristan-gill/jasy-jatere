extends CharacterBody2D

enum State { IDLE, ACTION }

const TILE_SIZE = 16
const ACTION_DURATION = 0.5

var facing_direction: Vector2 = Vector2.RIGHT
var state: State = State.IDLE

@export var action_queue: ActionQueue

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Events.tick.connect(_tick)
	
	animate_idle()


func _tick() -> void:
	if action_queue.is_empty():
		push_error("Tried to tick on empty enemy action queue")
	
	var next_action = action_queue.get_next()
	handle_action(next_action)


func handle_action(action: Action) -> void:
	state = State.ACTION
	
	if facing_direction.is_equal_approx(action.direction):
		animate_run()
		var tween := create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", global_position + (action.direction * TILE_SIZE), ACTION_DURATION)
		tween.finished.connect(action_completed, CONNECT_ONE_SHOT)
	else:
		facing_direction = action.direction
		action_completed()

func action_completed() -> void:
	state = State.IDLE
	animate_idle()

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
