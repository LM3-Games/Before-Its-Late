class_name NPC
extends CharacterBody2D

@export var speed: float = 30

var player: Player
var can_loot: bool = false
var looted: bool = false
var wait: bool = false
var stuck_timer: float = 0.0
var last_position: Vector2 = Vector2.ZERO
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var nav_tiles: Array = []
var tile_map: TileMapLayer
var cash_amount: int = 0

@onready var cash: Sprite2D = $Cash
@onready var loot_progress: TextureProgressBar = $LootProgress
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var anchor: Node2D = $Anchor
@onready var sprite: Sprite2D = $Anchor/Sprite
@onready var cash_amount_text: Label = $CashAmountText
@onready var steal_area: Area2D = $StealArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	tile_map = %TileMapLayer
	rng.randomize()
	_cache_nav_tiles()
	await get_tree().create_timer(randf_range(1.0, 3.0)).timeout
	make_random_path()
	cash_amount = randi_range(25, 300)
	cash_amount_text.text = ("+ $" + str(cash_amount))


func _process(_delta: float) -> void:
	if !can_loot:
		reset_loot_progress()
		return
	check_loot_progress()


func _physics_process(delta: float) -> void:
	if wait:
		return
	update_movement()
	move_and_slide()
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
	var new_velocity: Vector2 = direction * speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		velocity = new_velocity
	if direction != Vector2.ZERO:
		anchor.rotation = direction.angle()


func reset_loot_progress() -> void:
	if loot_progress.value != loot_progress.max_value:
		loot_progress.value = loot_progress.min_value


func check_loot_progress() -> void:
	if player.is_looting and !looted:
		loot_progress.value += 1
		if(loot_progress.value == loot_progress.max_value):
			looted = true
			loot_progress.hide()
			cash.hide()
			AudioManager.play_sfx(AudioManager.CASH)
			GameManager.cash += cash_amount
			steal_area.set_collision_mask_value(2, false)
			animation_player.play("cash_popup")
			sprite.material.set_shader_parameter("show_outline", false)
	else:
		if loot_progress.value > loot_progress.min_value:
			loot_progress.value -= 1


func make_random_path() -> void:
	var target = nav_tiles[randi_range(0, nav_tiles.size() - 1)]
	navigation_agent.target_position = target


func _on_navigation_finished() -> void:
	wait = true
	await get_tree().create_timer(randf_range(8.0, 12.0)).timeout
	make_random_path()
	wait = false


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity


func _on_steal_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		can_loot = true
		body.is_looting_npc = true


func _on_steal_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		can_loot = false
		body.is_looting_npc = false
