extends Button


func _ready() -> void:
	pressed.connect(func() -> void:
		AudioManager.play_sfx(AudioManager.TICK)
		)
