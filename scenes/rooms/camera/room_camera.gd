extends Camera2D

const CAMERA_SIZE: Vector2 = Vector2(240, 128)

func _ready() -> void:
	Events.offset_camera.connect(_offset_camera)

func _offset_camera(new_offset: Vector2) -> void:
	offset = new_offset + (CAMERA_SIZE / 2.0)
