extends Node2D

const VISION_ANGLE: float = deg_to_rad(46.0)

@onready var player: CharacterBody2D = $Player
@onready var enemy: CharacterBody2D = $Enemy

func _ready() -> void:
	Events.toggle_eyes.connect(_toggle_eyes)
	Events.check_vision.connect(_check_vision)
	
	Events.start_room.emit(0)

func _toggle_eyes() -> void:
	# TODO check vision again in case they opened eyes while in vision
	pass


func _check_vision() -> void:
	var x_axis_to_player = enemy.global_position.angle_to_point(player.global_position)
	var x_axis_to_enemy_facing = Vector2.RIGHT.angle_to(enemy.facing_direction)
	
	var angle_to_player = x_axis_to_player - x_axis_to_enemy_facing
	if abs(angle_to_player) < VISION_ANGLE:
		var did_move: bool = player.last_action and player.last_action.direction
		var are_eyes_open = not player.vision_block.visible
		if did_move or are_eyes_open:
			var can_see = check_raycasts()
			if can_see:
				Events.caught_by_enemy.emit()

func check_raycasts() -> bool:
	var corner_offsets: Array[Vector2] = [
		Vector2(-4, 0),
		Vector2(5, 0),
		Vector2(-4, -5),
		Vector2(5, -5)
	]
	
	for player_corner_offset in corner_offsets:
		for enemy_corner_offset in corner_offsets:
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(enemy.global_position + enemy_corner_offset, player.global_position + player_corner_offset)
			var result = space_state.intersect_ray(query)
			if !result or !result.collider or (result.collider is Player):
				print("player_corner_offset", player_corner_offset, "enemy_corner_offset", enemy_corner_offset)
				return true
	
	return false
