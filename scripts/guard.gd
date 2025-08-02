class_name Guard
extends CharacterBody2D

@export var patrol_speed: float = 20
@export var chase_speed: float = 50

var player: Player
var current_speed: float
var is_alerted: bool
var stuck_timer: float = 0.0
var last_position: Vector2 = Vector2.ZERO
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var nav_tiles: Array = []
var tile_map: TileMapLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var navigation_timer: Timer = $NavigationTimer
@onready var alert: Sprite2D = $Alert
@onready var anchor: Node2D = $Anchor
@onready var cone: Polygon2D = $Anchor/DetectionCone/Cone
@onready var cone_collision: CollisionPolygon2D = $Anchor/DetectionCone/ConeCollision
@onready var box: Polygon2D = $Anchor/DetectionCone/Box
@onready var box_collision: CollisionPolygon2D = $Anchor/DetectionCone/BoxCollision


func _ready() -> void:
	tile_map = %TileMapLayer
	rng.randomize()
	_cache_nav_tiles()
	current_speed = patrol_speed
	make_random_path()
	last_position = global_position
	SignalManager.on_alert.connect(_on_alert)


func _process(_delta: float) -> void:
	if player:
		if player.is_looting and player.is_looting_npc and !is_alerted:
			SignalManager.on_alert.emit(player)


func _physics_process(delta: float) -> void:
	update_movement()
	move_and_slide()
	if !is_alerted:
		check_if_stuck(delta)


func check_if_stuck(delta: float) -> void:
	var moved_distance: float = global_position.distance_to(last_position)
	if moved_distance < 1.0:
		stuck_timer += delta
	else:
		stuck_timer = 0.0
	last_position = global_position
	if stuck_timer > 8.0:
		make_random_path()
		stuck_timer = 0.0


func _cache_nav_tiles() -> void:
	nav_tiles.clear()
	for cell in tile_map.get_used_cells():
		var tile_data = tile_map.get_cell_tile_data(cell)
		if tile_data and tile_data.get_navigation_polygon(0):
			var world_pos = tile_map.map_to_local(cell)
			nav_tiles.append(world_pos)


func update_movement() -> void:
	var direction: Vector2 = to_local(navigation_agent.get_next_path_position()).normalized()
	var new_velocity: Vector2 = direction * current_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		velocity = new_velocity
	if direction != Vector2.ZERO:
		anchor.rotation = direction.angle()


func _on_alert(target: Player) -> void:
	player = target
	alert_guard()


func alert_guard() -> void:
	is_alerted = true
	cone_collision.disabled = true
	box_collision.disabled = false
	cone.hide()
	box.show()
	alert.show()
	animation_player.play("chase")
	current_speed = chase_speed
	navigation_timer.start()


func make_path_to_player() -> void:
	if player:
		navigation_agent.target_position = player.global_position


func make_random_path() -> void:
	var target = nav_tiles[randi_range(0, nav_tiles.size() - 1)]
	navigation_agent.target_position = target


func _on_detection_cone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		if is_alerted:
			SignalManager.on_player_busted.emit()


func _on_detection_cone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null


func _on_navigation_finished() -> void:
	make_random_path()


func _on_navigation_timer_timeout() -> void:
	make_path_to_player()


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
