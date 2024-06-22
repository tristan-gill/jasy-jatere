extends Control

var is_proceed_enabled: bool = false

@onready var label: Label = $Panel/MarginContainer/VBoxContainer/Label

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1, 10)
	tween.finished.connect(_intro_finished)


func _intro_finished() -> void:
	is_proceed_enabled = true


func _physics_process(delta: float) -> void:
	if is_proceed_enabled and Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/world.tscn")
