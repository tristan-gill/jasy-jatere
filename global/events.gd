extends Node

signal toggle_eyes

signal tick

signal caught_by_enemy

signal check_vision

signal footstep(global_pos: Vector2)
signal position_enemy(global_pos: Vector2)
signal direction_enemy(direction: Vector2)
signal update_enemy_action_queue(action_queue: ActionQueue)

signal position_player(global_pos: Vector2)
signal direction_player(direction: Vector2)

signal start_room(room_number: int)

signal offset_camera(offset: Vector2)

signal update_dialog_text(text: String)
