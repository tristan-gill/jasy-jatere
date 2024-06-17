class_name Action
extends Resource

@export var direction: Vector2

func _init(new_direction: Vector2 = Vector2.ZERO) -> void:
	direction = new_direction
