class_name Room
extends Node2D

const ROOM_SIZE: Vector2 = Vector2(240, 128)

@export var room_number: int

@export var enemy_spawn_position: Vector2
@export var enemy_spawn_direction: Vector2
@export var enemy_action_queue: ActionQueue

@export var player_spawn_position: Vector2
@export var player_spawn_direction: Vector2

# TODO slide camera using this
@export var entrance_direction: Vector2


func _ready() -> void:
	Events.start_room.connect(_start_room)

func _start_room(called_room_number: int) -> void:
	if room_number == called_room_number:
		Events.position_enemy.emit(global_position + enemy_spawn_position)
		Events.direction_enemy.emit(enemy_spawn_direction)
		Events.update_enemy_action_queue.emit(enemy_action_queue)
		
		Events.position_player.emit(global_position + player_spawn_position)
		Events.direction_player.emit(player_spawn_direction)
		
		Events.offset_camera.emit(global_position)
		

func _on_exit_area_body_entered(body: Node2D) -> void:
	Events.start_room.emit(room_number + 1)


func _on_entrance_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
