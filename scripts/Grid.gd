extends Node2D

## Grid - Manages the 5x9 lawn grid where plants are placed.
## Handles mouse input for plant placement, draws grid visuals.

# ----- Grid Constants -----
const COLS: int = 9
const ROWS: int = 5
const TILE_W: int = 108
const TILE_H: int = 108
const GRID_X: int = 120   # Left edge X of the grid
const GRID_Y: int = 80    # Top edge Y of the grid

# ----- Plant scenes to instantiate -----
const PEASHOOTER_SCENE: PackedScene = preload("res://scenes/PeaShooter.tscn")
const SUNFLOWER_SCENE: PackedScene = preload("res://scenes/Sunflower.tscn")
const WALLNUT_SCENE: PackedScene = preload("res://scenes/WallNut.tscn")

# ----- Grid data: null = empty, Node = has a plant -----
var grid: Array = []

# ----- Visual hover feedback -----
var _hovered: Vector2i = Vector2i(-1, -1)

func _ready() -> void:
	add_to_group("grid")
	# Fill grid with nulls
	grid.resize(ROWS)
	for r in range(ROWS):
		grid[r] = []
		grid[r].resize(COLS)
		for c in range(COLS):
			grid[r][c] = null

func _input(event: InputEvent) -> void:
	if not GameManager.game_active:
		return
	if event is InputEventMouseMotion:
		_hovered = _get_cell(event.position)
		queue_redraw()
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_try_place_plant(_get_cell(event.position))

## Convert a screen position to grid cell coordinates.
func _get_cell(pos: Vector2) -> Vector2i:
	var col: int = int((pos.x - GRID_X) / TILE_W)
	var row: int = int((pos.y - GRID_Y) / TILE_H)
	return Vector2i(col, row)

## Returns true if the cell is within the grid bounds.
func _is_valid(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < COLS and cell.y >= 0 and cell.y < ROWS

## Returns the center world position of a grid cell.
func get_cell_center(col: int, row: int) -> Vector2:
	return Vector2(
		GRID_X + col * TILE_W + TILE_W / 2,
		GRID_Y + row * TILE_H + TILE_H / 2
	)

## Returns the vertical center position (Y) of a row.
func get_row_y(row: int) -> float:
	return GRID_Y + row * TILE_H + TILE_H / 2.0

## Attempt to place the selected plant on the given cell.
func _try_place_plant(cell: Vector2i) -> void:
	if not _is_valid(cell):
		return
	if grid[cell.y][cell.x] != null:
		return   # Cell already occupied
	if not GameManager.can_afford(GameManager.selected_plant):
		return   # Not enough sun
	if not GameManager.spend_sun(GameManager.selected_plant):
		return

	var scene: PackedScene = _get_plant_scene(GameManager.selected_plant)
	if scene == null:
		return

	var plant: Node = scene.instantiate()
	plant.grid_row = cell.y
	plant.grid_col = cell.x
	plant.position = get_cell_center(cell.x, cell.y)
	add_child(plant)
	grid[cell.y][cell.x] = plant
	print("Planting ", GameManager.selected_plant, " at ", cell)
	plant.plant_died.connect(_on_plant_died.bind(cell.y, cell.x))

## Clear the grid cell when a plant dies.
func _on_plant_died(row: int, col: int) -> void:
	grid[row][col] = null

## Return the correct scene for a plant type name.
func _get_plant_scene(plant_type: String) -> PackedScene:
	match plant_type:
		"PeaShooter": return PEASHOOTER_SCENE
		"Sunflower":  return SUNFLOWER_SCENE
		"WallNut":    return WALLNUT_SCENE
	return null

## Draw the grid lines and hover highlight.
func _draw() -> void:
	var line_color: Color = Color(0.18, 0.5, 0.08, 0.45)
	var hover_color: Color = Color(1.0, 1.0, 0.3, 0.35)

	for r in range(ROWS):
		for c in range(COLS):
			var rect := Rect2(GRID_X + c * TILE_W, GRID_Y + r * TILE_H, TILE_W, TILE_H)
			# Highlight hovered empty cell
			if _hovered == Vector2i(c, r) and _is_valid(_hovered) and grid[r][c] == null:
				draw_rect(rect, hover_color)
			draw_rect(rect, line_color, false, 2.0)
