extends Control

@onready var label: Label = $Panel/MarginContainer/Label
@onready var timer: Timer = $Timer

func _ready() -> void:
	Events.update_dialog_text.connect(_update_dialog_text)
	Events.caught_by_enemy.connect(_caught_by_enemy)

func _caught_by_enemy() -> void:
	label.text = "Oh no, Jasy Jatere has seen you!\n\nA strange sound fill the air as your\nvision fades to black..."
	show()
	timer.start(4.0)
	await get_tree().create_timer(3.0).timeout
	get_tree().paused = true
	Events.start_room.emit(0)
	hide()
	timer.stop()
	get_tree().paused = false

func _update_dialog_text(text: String) -> void:
	label.text = text
	show()
	timer.start(1.0)
	get_tree().paused = true

func _physics_process(delta: float) -> void:
	if timer.time_left == 0 and visible and Input.is_anything_pressed(): 
		hide()
		get_tree().paused = false
