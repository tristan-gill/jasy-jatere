extends CharacterBody2D


enum State { IDLE, ACTION }

const TILE_SIZE = 16
const ACTION_DURATION = 0.6

var facing_direction: Vector2 = Vector2.RIGHT
var state: State = State.IDLE
var action_queue: ActionQueue

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer


# TODO look at the card game to see how the deck shit works cause i cant manually add in the editor
func _ready() -> void:
	Events.tick.connect(_tick)
	timer.timeout.connect(_timer_timeout)
	
	action_queue = ActionQueue.new()
	
	animate_idle()


func _physics_process(delta: float) -> void:
	handle_input()


func _timer_timeout() -> void:
	if state == State.ACTION:
		push_error("timer timeout during action, something out of sync")
	
	if state == State.IDLE and not action_queue.is_empty():
		Events.tick.emit()


func _tick() -> void:
	if action_queue.is_empty():
		push_error("Tried to tick on empty player action queue")
	
	var next_action = action_queue.pop_front()
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


func handle_input() -> void:
	if Input.is_action_just_released("input_up"):
		var action = Action.new(Vector2.UP)
		action_queue.append(action)
	if Input.is_action_just_released("input_down"):
		var action = Action.new(Vector2.DOWN)
		action_queue.append(action)
	if Input.is_action_just_released("input_left"):
		var action = Action.new(Vector2.LEFT)
		action_queue.append(action)
	if Input.is_action_just_released("input_right"):
		var action = Action.new(Vector2.RIGHT)
		action_queue.append(action)
	
	# TODO eyes and waits
	
	if state == State.IDLE and action_queue.queue.size() > 0:
		Events.tick.emit()
		timer.start()
