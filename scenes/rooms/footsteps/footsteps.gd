extends Node2D

const FOOTSTEP = preload("res://scenes/characters/enemy/footstep.tscn")

var are_eyes_open: bool = true

func _ready() -> void:
	Events.footstep.connect(_footstep)
	Events.toggle_eyes.connect(_toggle_eyes)

func _footstep(global_pos: Vector2) -> void:
	if not are_eyes_open:
		var new_footstep = FOOTSTEP.instantiate()
		new_footstep.global_position = global_pos
		add_child(new_footstep)

func _toggle_eyes() -> void:
	are_eyes_open = not are_eyes_open
	
	if are_eyes_open:
		for child in get_children():
			child.queue_free()
