extends Node2D

@export var player: Player

var can_board_train: bool = false
var train_boarded: bool = false
var train_arrived: bool = false
var train_left: bool = false

@onready var timer_bar: TextureProgressBar = %TimerBar
@onready var animation_player: AnimationPlayer = $Train/AnimationPlayer
@onready var camera: Camera = $Camera


func _ready() -> void:
	get_tree().paused = false
	GameManager.cash = 0
	SignalManager.on_alert.connect(_on_alert)
	SignalManager.on_player_busted.connect(_on_player_busted)


func _process(_delta: float) -> void:
	update_timer()
	%CashText.text = ("CASH : $ " + str(GameManager.cash))
	if Input.is_action_just_pressed("loot") and can_board_train:
		player.hide()
		%Board.hide()
		train_boarded = true


func update_timer() -> void:
	timer_bar.value -= 1
	if timer_bar.value < 1000 and !train_arrived:
		train_arrived = true
		animation_player.play("arrive_station")
	if timer_bar.value == 0 and !train_left:
		train_left = true
		animation_player.play("leave_station")


func _on_alert(_target: Player) -> void:
	timer_bar.modulate = Color("ff0000c8")


func _on_board_train_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_board_train = true


func _on_board_train_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_board_train = false


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "leave_station":
		if train_boarded:
			escaped()
		else:
			failed_to_escape()


func _on_player_busted() -> void:
	AudioManager.play_sfx(AudioManager.BUSTED)
	camera.apply_screen_shake()
	show_menu("BUSTED !", "YOU FAILED TO ESCAPE")


func failed_to_escape() -> void:
	AudioManager.play_sfx(AudioManager.BUSTED)
	camera.apply_screen_shake()
	show_menu("MISSED !", "YOU FAILED TO CATCH THE TRAIN")


func escaped() -> void:
	AudioManager.play_sfx(AudioManager.ESCAPED)
	show_menu("ESCAPED !", ("STOLEN CASH : $ " + str(GameManager.cash)))


func show_menu(main_text: String, tagline_text: String) -> void:
	%Main.text = main_text
	%Tagline.text = tagline_text
	var tween: Tween = %GameOver.create_tween()
	tween.tween_property(%GameOver, "modulate:a", 1.0, 1.0)
	get_tree().paused = true


func play_train_sound() -> void:
	AudioManager.play_sfx(AudioManager.TRAIN)


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://template/menus/title_screen/title_screen.tscn")


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
