class_name Player
extends CharacterBody2D

@export var speed: float = 80

var direction: Vector2 = Vector2.ZERO
var is_looting: bool = false
var is_looting_npc: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(_delta: float) -> void:
	update_movement()
	move_and_slide()
	update_sprite_animation()


func update_movement() -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	is_looting = Input.is_action_pressed("loot")
	velocity = direction * speed


func update_sprite_animation() -> void:
	if is_looting:
		animation_player.play("loot")
	else:
		animation_player.play("walk")
	if direction != Vector2.ZERO:
		sprite.rotation = direction.angle()
