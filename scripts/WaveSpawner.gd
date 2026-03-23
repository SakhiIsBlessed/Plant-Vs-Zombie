extends Node

## WaveSpawner - Manages zombie wave spawning.
## Starts wave 1 after a 5-second delay, spawns more zombies each wave.

# Zombie scenes
const BASIC_SCENE: PackedScene = preload("res://scenes/BasicZombie.tscn")
const FAST_SCENE: PackedScene = preload("res://scenes/FastZombie.tscn")
const TANK_SCENE: PackedScene = preload("res://scenes/TankZombie.tscn")

var _wave_timer: Timer      # Countdown between waves
var _spawn_timer: Timer     # Countdown between individual spawns

var _zombies_to_spawn: Array = []   # Queue of scenes to spawn this wave
var _spawn_index: int = 0

const ROWS: int = 5
const SPAWN_X: float = 1155.0

func _ready() -> void:
	add_to_group("wave_spawner")
	_wave_timer = $WaveTimer
	_spawn_timer = $SpawnTimer
	_wave_timer.timeout.connect(_on_wave_timer_timeout)
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)

## Begin the first wave shortly after the game starts.
func start_spawning() -> void:
	_wave_timer.start()

## Called when it's time to start the next wave.
func _on_wave_timer_timeout() -> void:
	if not GameManager.game_active:
		return
	GameManager.next_wave()
	_build_wave(GameManager.current_wave)
	_spawn_index = 0
	_spawn_timer.start()

## Build a list of zombies to spawn based on the wave number.
func _build_wave(wave: int) -> void:
	_zombies_to_spawn.clear()
	var count: int = 3 + wave * 2   # More zombies each wave
	for i in range(count):
		var roll: float = randf()
		if wave >= 3 and roll < 0.15:
			_zombies_to_spawn.append(TANK_SCENE)
		elif wave >= 2 and roll < 0.35:
			_zombies_to_spawn.append(FAST_SCENE)
		else:
			_zombies_to_spawn.append(BASIC_SCENE)

## Spawn one zombie from the queue.
func _on_spawn_timer_timeout() -> void:
	if not GameManager.game_active:
		_spawn_timer.stop()
		return
	if _spawn_index >= _zombies_to_spawn.size():
		_spawn_timer.stop()
		# Wait before next wave (45 sec minus wave bonus)
		_wave_timer.wait_time = max(15.0, 45.0 - GameManager.current_wave * 3.0)
		_wave_timer.start()
		return

	var zombie_layer: Node = get_tree().get_first_node_in_group("zombie_layer")
	if zombie_layer == null:
		return

	var scene: PackedScene = _zombies_to_spawn[_spawn_index]
	_spawn_index += 1

	var zombie: Node = scene.instantiate()
	var row: int = randi() % ROWS
	# Use Grid constants from Grid.gd
	var row_y: float = 80.0 + row * 108.0 + 54.0
	zombie.global_position = Vector2(SPAWN_X, row_y)
	zombie_layer.add_child(zombie)
