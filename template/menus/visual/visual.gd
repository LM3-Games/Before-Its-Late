class_name Visual
extends Control

@onready var display: Button = %Display
@onready var v_sync: Button = %VSync
@onready var screen_shake: Button = %ScreenShake
@onready var flash: Button = %Flash
@onready var back_to_options: Button = %BackToOptions


var DISPLAY: Dictionary[int, String] = {
	0: "WINDOWED",
	2: "MAXIMIZED",
	3: "FULLSCREEN",
	4: "EXCLUSIVE FULLSCREEN"
}

var VSYNC: Dictionary[int, String] = {
	0: "OFF",
	1: "ON",
}

var SCREENSHAKE: Dictionary[bool, String] = {
	true: "ON",
	false: "OFF",
}

var FLASH: Dictionary[bool, String] = {
	true: "ON",
	false: "OFF",
}


func _ready() -> void:
	display.text = DISPLAY[GameManager.display]
	v_sync.text = VSYNC[GameManager.v_sync]
	screen_shake.text = SCREENSHAKE[GameManager.screen_shake]
	flash.text = FLASH[GameManager.flash]

	display.pressed.connect(change_display_mode)
	v_sync.pressed.connect(toggle_v_sync_mode)
	screen_shake.pressed.connect(toggle_screen_shake_mode)
	flash.pressed.connect(toggle_flash_mode)

	if OS.get_name() == "Web" or OS.has_feature("web_android"):
		%DisplayBox.hide()
		%VSyncBox.hide()
		back_to_options.focus_neighbor_bottom = screen_shake.get_path()


func change_display_mode() -> void:
	AudioManager.play_sfx(AudioManager.TICK)
	match display.text:
		"WINDOWED":
			display.text = "MAXIMIZED"
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		"MAXIMIZED":
			display.text = "FULLSCREEN"
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		"FULLSCREEN":
			display.text = "EXCLUSIVE FULLSCREEN"
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		"EXCLUSIVE FULLSCREEN":
			display.text = "WINDOWED"
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func toggle_v_sync_mode() -> void:
	AudioManager.play_sfx(AudioManager.TICK)
	match v_sync.text:
		"ON":
			v_sync.text = "OFF"
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		"OFF":
			v_sync.text = "ON"
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)


func toggle_screen_shake_mode() -> void:
	AudioManager.play_sfx(AudioManager.TICK)
	match screen_shake.text:
		"ON":
			screen_shake.text = "OFF"
			GameManager.screen_shake = false
		"OFF":
			screen_shake.text = "ON"
			GameManager.screen_shake = true


func toggle_flash_mode() -> void:
	AudioManager.play_sfx(AudioManager.TICK)
	match flash.text:
		"ON":
			flash.text = "OFF"
			GameManager.flash = false
		"OFF":
			flash.text = "ON"
			GameManager.flash = true
