extends PlantBase

## PeaShooter - Fires pea projectiles every 1.5 seconds.
## Only shoots when a zombie is in the same row (to the right).

const PEA_SCENE: PackedScene = preload("res://scenes/PeaProjectile.tscn")

var _shoot_timer: Timer

func _ready() -> void:
	# Override PlantBase stats
	max_health = 100
	plant_color = Color(0.22, 0.78, 0.22)
	plant_size = 40.0
	plant_cost = 100
	super._ready()

	# Create auto-shooting timer
	_shoot_timer = Timer.new()
	_shoot_timer.wait_time = 1.5
	_shoot_timer.autostart = true
	_shoot_timer.timeout.connect(_on_shoot_timeout)
	add_child(_shoot_timer)

## Fire a pea if a zombie exists in this row.
func _on_shoot_timeout() -> void:
	if not GameManager.game_active:
		return
	if _zombie_in_row():
		_fire_pea()

## Check if any zombie shares the same horizontal row as this plant.
func _zombie_in_row() -> bool:
	for zombie in get_tree().get_nodes_in_group("zombies"):
		if abs(zombie.global_position.y - global_position.y) < 55.0:
			if zombie.global_position.x > global_position.x:
				return true
	return false

## Spawn a pea projectile at this plant's position.
func _fire_pea() -> void:
	var layer: Node = get_tree().get_first_node_in_group("projectile_layer")
	if layer == null:
		return
	var pea: Node = PEA_SCENE.instantiate()
	pea.global_position = global_position + Vector2(40.0, 0.0)
	pea.row_y = global_position.y
	layer.add_child(pea)

## Draw a simple shadow instead of the old procedural body.
func _draw() -> void:
	# Subtle shadow at base
	draw_circle(Vector2(0, 35), 25, Color(0, 0, 0, 0.2))

func _process(_delta: float) -> void:
	# Gentle breathing/bobbing animation
	var bob: float = 1.0 + 0.03 * sin(Time.get_ticks_msec() * 0.003)
	$Sprite2D.scale = Vector2(0.12 * bob, 0.12 * (1.0 / bob))
