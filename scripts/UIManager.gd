extends CanvasLayer

## UIManager - Updates all HUD elements.
## Attached to the HUD CanvasLayer in GameScene.

@onready var sun_label: Label = $HUDPanel/SunLabel
@onready var wave_label: Label = $HUDPanel/WaveLabel
@onready var score_label: Label = $HUDPanel/ScoreLabel
@onready var ps_btn: Button = $HUDPanel/PlantButtons/PeaShooterBtn
@onready var sf_btn: Button = $HUDPanel/PlantButtons/SunflowerBtn
@onready var wn_btn: Button = $HUDPanel/PlantButtons/WallNutBtn

func _ready() -> void:
	# Connect to GameManager signals
	GameManager.sun_changed.connect(_on_sun_changed)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.wave_changed.connect(_on_wave_changed)

	# Connect plant selection buttons
	ps_btn.pressed.connect(func(): _select("PeaShooter"))
	sf_btn.pressed.connect(func(): _select("Sunflower"))
	wn_btn.pressed.connect(func(): _select("WallNut"))

	# UIManager is now passive and waits for GameScene to start the game
	pass

## Update sun label.
func _on_sun_changed(amount: int) -> void:
	sun_label.text = "☀ " + str(amount)
	# Grey out buttons the player can't afford
	ps_btn.disabled = amount < 100
	sf_btn.disabled = amount < 50
	wn_btn.disabled = amount < 75

## Update score label.
func _on_score_changed(amount: int) -> void:
	score_label.text = "Score: " + str(amount)

## Update wave label.
func _on_wave_changed(wave: int) -> void:
	wave_label.text = "Wave: " + str(wave)

## Select a plant and highlight the button.
func _select(plant_type: String) -> void:
	GameManager.select_plant(plant_type)
	# Visual highlight - reset all, then highlight selected
	for btn in [ps_btn, sf_btn, wn_btn]:
		btn.modulate = Color(1, 1, 1)
	match plant_type:
		"PeaShooter": ps_btn.modulate = Color(0.6, 1.0, 0.6)
		"Sunflower":  sf_btn.modulate = Color(1.0, 1.0, 0.4)
		"WallNut":    wn_btn.modulate = Color(1.0, 0.75, 0.4)
