extends PlantBase

## WallNut - High-health defensive plant. Does not attack.
## Use it to block and slow down zombie advances.

func _ready() -> void:
	max_health = 500
	plant_color = Color(0.72, 0.45, 0.18)
	plant_size = 44.0
	plant_cost = 75
	super._ready()

func _process(_delta: float) -> void:
	# WallNut is heavy, bobs slower
	var bob: float = 1.0 + 0.02 * sin(Time.get_ticks_msec() * 0.0015)
	$Sprite2D.scale = Vector2(0.12 * bob, 0.12 * (1.0 / bob))

## Draw a shadow.
func _draw() -> void:
	draw_circle(Vector2(0, 38), 28, Color(0, 0, 0, 0.2))
