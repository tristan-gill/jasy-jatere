extends Node2D

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_timer_timeout)

func _timer_timeout() -> void:
	queue_free()
