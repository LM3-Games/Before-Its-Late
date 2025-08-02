extends Control

@onready var current_menu: Control = %Main


func _ready() -> void:
	get_tree().paused = false
	if OS.get_name() == "Web" or OS.has_feature("web_android"):
		%QuitButton.hide()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_options_pressed() -> void:
	change_current_menu(%Options, "Audio")


func _on_credits_pressed() -> void:
	change_current_menu(%Credits, "BackToMain")


func _on_quit_pressed() -> void:
	change_current_menu(%Quit, "No")


func _on_no_pressed() -> void:
	change_current_menu(%Main, "Play")


func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_back_to_main_pressed() -> void:
	AudioManager.play_sfx(AudioManager.TICK)
	change_current_menu(%Main, "Play")


func _on_audio_pressed() -> void:
	change_current_menu(%Audio, "Master")


func _on_visual_pressed() -> void:
	change_current_menu(%Visual, "Display")


func _on_back_to_options_pressed() -> void:
	AudioManager.play_sfx(AudioManager.TICK)
	change_current_menu(%Options, "Audio")


func change_current_menu(menu: Control, button: String) -> void:
	current_menu.hide()
	current_menu = menu
	current_menu.show()
	current_menu.find_child(button).grab_focus()
