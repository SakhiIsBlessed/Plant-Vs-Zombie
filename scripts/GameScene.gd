extends Node2D

## GameScene - Root script for the main gameplay scene.
## Registers all key nodes to their groups so scripts can find them
## without tight coupling (using get_first_node_in_group).

func _ready() -> void:
	# Register layers so plants/zombies/spawner can find them via groups
	$ZombieLayer.add_to_group("zombie_layer")
	$ProjectileLayer.add_to_group("projectile_layer")
	$SunLayer.add_to_group("sun_layer")
	$Grid.add_to_group("grid")
	
	# Start the game state first
	GameManager.start_game()
	
	# Finally, find and start the WaveSpawner
	var spawner = get_tree().get_first_node_in_group("wave_spawner")
	if spawner:
		spawner.start_spawning()
		print("Waves started!")
	else:
		printerr("WaveSpawner not found in group!")
