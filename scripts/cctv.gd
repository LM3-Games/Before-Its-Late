class_name CCTV
extends StaticBody2D

var player: Player
var is_alerted: bool = false

@onready var alert: Sprite2D = $Alert
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	await get_tree().create_timer(randf_range(0, 1)).timeout
	animation_player.play("rotate")


func _process(_delta: float) -> void:
	if player:
		if player.is_looting and player.is_looting_npc and !is_alerted:
			alert_guard()


func alert_guard() -> void:
	is_alerted = true
	alert.show()
	SignalManager.on_alert.emit(player)


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
