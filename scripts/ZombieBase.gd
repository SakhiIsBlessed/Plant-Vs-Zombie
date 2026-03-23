extends CharacterBody2D

class_name ZombieBase

## ZombieBase - Base class for all zombies.
## Extend to create BasicZombie, FastZombie, TankZombie.
## Moves left, stops to attack plants, triggers game over at the house.

# ----- Stats (override in subclasses) -----
var speed: float = 60.0
var max_health: int = 100
var health: int = 100
var attack_damage: int = 10
var attack_rate: float = 1.0    # Attacks per second
var score_value: int = 50
var zombie_color: Color = Color(0.55, 0.65, 0.45)

# ----- Internal state -----
var _current_plant: PlantBase = null   # Plant being attacked
var _attack_timer: float = 0.0
var _is_attacking: bool = false

# Boundary where reaching means game over (left edge of grid)
const HOUSE_X: float = 115.0

func _ready() -> void:
	health = max_health
	add_to_group("zombies")
	# Connect the AttackArea signals to detect plants
	var attack_area: Area2D = $AttackArea
	attack_area.area_entered.connect(_on_attack_area_entered)
	attack_area.area_exited.connect(_on_attack_area_exited)


## Called when a plant enters the zombie's attack range.
func _on_attack_area_entered(area: Area2D) -> void:
	if area is PlantBase:
		_current_plant = area
		_is_attacking = true
		_attack_timer = 0.0   # Attack immediately
		velocity = Vector2.ZERO

## Called when the attacked plant leaves range (plant died).
func _on_attack_area_exited(area: Area2D) -> void:
	if area == _current_plant:
		_current_plant = null
		_is_attacking = false

## Apply damage, die if health is 0.
func take_damage(amount: int) -> void:
	health -= amount
	queue_redraw()
	if health <= 0:
		die()

## Award score and remove zombie.
func die() -> void:
	print("Zombie defeated! +", score_value, " points.")
	GameManager.add_score(score_value)
	queue_free()

## Draw zombie body + health bar (no sprites needed).
## Draw a simple shadow.
func _draw() -> void:
	draw_circle(Vector2(0, 36), 25, Color(0, 0, 0, 0.2))

func _physics_process(delta: float) -> void:
	if not GameManager.game_active:
		return

	if _is_attacking and is_instance_valid(_current_plant):
		_attack_timer -= delta
		if _attack_timer <= 0.0:
			_attack_timer = 1.0 / attack_rate
			_current_plant.take_damage(attack_damage)
	else:
		_is_attacking = false
		_current_plant = null
		velocity = Vector2(-speed, 0.0)
		move_and_slide()
		
		# Limping/Shuffling animation
		var tilt: float = 0.1 * sin(Time.get_ticks_msec() * 0.008)
		$Sprite2D.rotation = tilt
		var step_up: float = abs(sin(Time.get_ticks_msec() * 0.008)) * 5.0
		$Sprite2D.position.y = -step_up
		
		if global_position.x < HOUSE_X:
			GameManager.trigger_game_over()
			queue_free()
