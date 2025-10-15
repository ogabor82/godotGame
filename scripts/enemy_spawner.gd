extends Node2D

# Reference to the enemy scene
@export var enemy_scene: PackedScene
# Number of enemies to spawn
@export var enemy_count: int = 3
# Min and max spawn interval in seconds
@export var min_spawn_interval: float = 0.2
@export var max_spawn_interval: float = 1.0
# Area bounds for spawning (adjust to match your game area)
@export var spawn_area_min: Vector2 = Vector2(-400, -300)
@export var spawn_area_max: Vector2 = Vector2(800, 300)

@onready var spawn_timer: Timer = $SpawnTimer
@onready var actors_node: Node2D

func _ready() -> void:
	# Find the Actors node (sibling of this spawner)
	var root = get_parent()
	if root.has_node("Actors"):
		actors_node = root.get_node("Actors")
		print("EnemySpawner: Found Actors node")
	else:
		push_error("EnemySpawner: Cannot find Actors node!")
		return
	
	# Set up the spawn timer
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.one_shot = false
	_set_random_timer_interval()
	spawn_timer.start()
	print("EnemySpawner: Timer started with interval: ", spawn_timer.wait_time)
	
	# Spawn initial enemies
	_spawn_enemies()

func _set_random_timer_interval() -> void:
	spawn_timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)

func _on_spawn_timer_timeout() -> void:
	_spawn_enemies()
	_set_random_timer_interval()

func _remove_existing_enemies() -> void:
	# Remove all existing enemies from the Actors node
	for child in actors_node.get_children():
		if child.is_in_group("enemy") or child.name.begins_with("Enemy"):
			child.queue_free()

func _spawn_enemies() -> void:
	if not enemy_scene:
		push_error("Enemy scene not assigned to EnemySpawner!")
		print("EnemySpawner: ERROR - Enemy scene is not assigned! Please set it in the Inspector.")
		return
	
	print("EnemySpawner: Spawning ", enemy_count, " enemies")
	for i in range(enemy_count):
		var enemy = enemy_scene.instantiate()
		
		# Set random position within spawn area
		var random_pos = Vector2(
			randf_range(spawn_area_min.x, spawn_area_max.x),
			randf_range(spawn_area_min.y, spawn_area_max.y)
		)
		enemy.position = random_pos
		
		# Add enemy to the Actors node
		actors_node.add_child(enemy)
		print("EnemySpawner: Spawned enemy at position: ", random_pos)
