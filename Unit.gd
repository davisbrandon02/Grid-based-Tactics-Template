extends Area2D
class_name Unit

var move_range: int = 5
var avail_tiles = Array()
var selected: bool = false
var tile = null

onready var board = get_parent()
onready var turnManager = get_parent().get_node("TurnManager")
onready var pathfinding = get_parent().get_node("Pathfinding")

func initialize():
	var grid_pos = board.world_to_grid(position)
	$CollisionShape2D.shape.extents = Vector2(board.half_tile_size, board.half_tile_size)
	set_tile(board.get_tile_at(grid_pos))

# Sets the tile that this unit is on.
func set_tile(_tile):
	if tile != null:
		tile.unit = null
	tile = _tile
	position = board.grid_to_world(_tile.grid_pos)
	_tile.unit = self

# Sets whether or not this unit is currently selected.
func set_selected(value):
	selected = value
	if selected:
		$Sprite.modulate = Color.yellow
		pathfinding.start_tile = tile
		set_available_tiles(move_range)
	else: $Sprite.modulate = Color.white

# On click
func _on_Unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			turnManager.set_selected_unit(self)
			pathfinding.set_active_unit(self)

# Function used to actually move the unit.
func move(_path):
	var _tile = board.get_tile_at(_path[-1])
	set_tile(_tile)
	set_available_tiles(0)

# Sets tiles as available within a certain range from this unit.
func set_available_tiles(_range):
	for _tile in board.tile_array:
		_tile.set_available(false)
	for _tile in pathfinding.get_points_in_range(tile, _range):
		_tile.set_available(true)
