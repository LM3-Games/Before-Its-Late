class_name Audio
extends Control

@onready var master: HSlider = %Master
@onready var music: HSlider = %Music
@onready var sfx: HSlider = %SFX


func _ready() -> void:
	master.value = GameManager.master_volume
	music.value = GameManager.music_volume
	sfx.value = GameManager.sfx_volume

	master.value_changed.connect(change_master_volume)
	music.value_changed.connect(change_music_volume)
	sfx.value_changed.connect(change_sfx_volume)


func change_master_volume(new_value: float) -> void:
	GameManager.master_volume = new_value
	AudioManager.play_sfx(AudioManager.TICK)
	AudioServer.set_bus_volume_db(0, linear_to_db(new_value))


func change_music_volume(new_value: float) -> void:
	GameManager.music_volume = new_value
	AudioManager.play_sfx(AudioManager.TICK)
	AudioServer.set_bus_volume_db(1, linear_to_db(new_value))


func change_sfx_volume(new_value: float) -> void:
	GameManager.sfx_volume = new_value
	AudioManager.play_sfx(AudioManager.TICK)
	AudioServer.set_bus_volume_db(2, linear_to_db(new_value))
