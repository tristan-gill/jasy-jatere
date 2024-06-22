extends Control

const OPTIONS = preload("res://scenes/menu/options.tscn")
const CREDITS = preload("res://scenes/menu/credits.tscn")

func _on_start_pressed() -> void:
	var show_intro: bool = false
	
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	show_intro = config.get_value("startup", "show_intro", true)
	
	if err == ERR_FILE_CANT_OPEN or not show_intro:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
	else:
		config.set_value("startup", "show_intro", false)
		config.save("user://settings.cfg")
		get_tree().change_scene_to_file("res://scenes/menu/introduction.tscn")


func _on_options_pressed() -> void:
	var options_menu = OPTIONS.instantiate()
	add_child(options_menu)

func _on_credits_pressed() -> void:
	var credits_menu = CREDITS.instantiate()
	add_child(credits_menu)

func _on_quit_pressed() -> void:
	get_tree().quit()
