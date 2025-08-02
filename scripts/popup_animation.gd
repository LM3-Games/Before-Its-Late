class_name PopupAnimation
extends Node

@export var from_center: bool = true
@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var time: float = 0.1
@export var transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_ELASTIC

var target: Control
var default_scale: Vector2
var tween: Tween


func _ready() -> void:
	target = get_parent()
	_connect_signals()
	call_deferred("_setup")


func _connect_signals() -> void:
	target.mouse_entered.connect(hover_start)
	target.mouse_exited.connect(hover_end)
	target.focus_entered.connect(hover_start)
	target.focus_exited.connect(hover_end)


func _setup() -> void:
	if from_center:
		target.pivot_offset = target.size / 2
	default_scale = target.scale


func hover_start() -> void:
	_add_tween("scale", hover_scale, time)


func hover_end() -> void:
	_add_tween("scale", default_scale, time)


func _add_tween(property: String, value, seconds: float) -> void:
	tween = self.create_tween()
	tween.tween_property(target, property, value, seconds).set_trans(transition_type)
