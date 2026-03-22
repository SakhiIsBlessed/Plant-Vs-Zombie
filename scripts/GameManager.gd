extends Node

## GameManager - AutoLoad Singleton
## Available everywhere as "GameManager"
## Manages global game state: sun, score, waves, and game flow.

# ----- Signals -----
signal sun_changed(amount: int)
signal score_changed(amount: int)
signal wave_changed(wave: int)
signal game_over_triggered

# ----- Plant Costs -----
const PLANT_COSTS: Dictionary = {
	"PeaShooter": 100,
	"Sunflower": 50,
	"WallNut": 75
}

# ----- Game State -----
var sun: int = 50
var score: int = 0
var current_wave: int = 0
var game_active: bool = false
var selected_plant: String = "PeaShooter"

func _ready() -> void:
	pass

## Call this when starting a new game session.
func start_game() -> void:
	sun = 50
	score = 0
	current_wave = 0
	game_active = true
	selected_plant = "PeaShooter"
	sun_changed.emit(sun)
	score_changed.emit(score)
	wave_changed.emit(current_wave)

## Add sun to the player's total.
func add_sun(amount: int) -> void:
	sun += amount
	sun_changed.emit(sun)

## Returns true if the player has enough sun for the given plant type.
func can_afford(plant_type: String) -> bool:
	return sun >= PLANT_COSTS.get(plant_type, 0)

## Deduct sun cost. Returns true if successful.
func spend_sun(plant_type: String) -> bool:
	var cost: int = PLANT_COSTS.get(plant_type, 0)
	if sun >= cost:
		sun -= cost
		sun_changed.emit(sun)
		return true
	return false

## Add points to the player's score.
func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)

## Advance to the next wave number.
func next_wave() -> void:
	current_wave += 1
	print("Brace yourself! Wave ", current_wave, " is starting...")
	wave_changed.emit(current_wave)

## Change which plant type will be placed on the next click.
func select_plant(plant_type: String) -> void:
	selected_plant = plant_type

## Trigger the game over sequence.
func trigger_game_over() -> void:
	if not game_active:
		return
	game_active = false
	print("Hey loser, try again!")
	game_over_triggered.emit()
	# Wait 1.5 seconds then transition to Game Over screen
	get_tree().create_timer(1.5).timeout.connect(
		func(): get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
	)
