extends Node

const MUSIC: AudioStream = preload("res://assets/audio/heist.ogg")

const TICK: AudioStream = preload("res://template/sfx/tick.ogg")
const CASH: AudioStream = preload("res://assets/audio/cash.ogg")
const ESCAPED: AudioStream = preload("res://assets/audio/escaped.ogg")
const BUSTED: AudioStream = preload("res://assets/audio/busted.ogg")
const ALERT: AudioStream = preload("res://assets/audio/alert.ogg")
const TRAIN: AudioStream = preload("res://assets/audio/train.ogg")

var music: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	setup_audio_stream_players()


func setup_audio_stream_players() -> void:
	music = AudioStreamPlayer.new()
	music.set_bus("Music")
	music.stream = MUSIC
	add_child(music)
	music.play()


func play_sfx(sound_effect: AudioStream) -> void:
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	sfx.set_bus("SFX")
	add_child(sfx)
	sfx.stream = sound_effect
	sfx.play()
	sfx.finished.connect(sfx.queue_free)
