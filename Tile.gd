extends Area2D

var board
var pathfinding
var turnManager

var unit = null

var grid_pos: Vector2
var obstacle: bool = false
var blocks_LOS: bool = false
var walkable: bool = false setget set_walkable
var attackable: bool = false setget set_attackable
var in_LOS: bool = false setget set_in_LOS
var adjacency_array = Array()
var is_edge_tile: bool = false

func _ready():
	$CollisionShape2D.shape.extents = Vector2(board.tile_size/2, board.tile_size/2)
	$Label.text = grid_pos as String

# Creates an adjacency array of neighboring tiles, and sets edge tiles of the board.
func get_adjacent_tiles():
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
	for direction in directions:
		for tile in board.tile_array:
			if tile.grid_pos == grid_pos + direction and tile != self and !(tile in adjacency_array):
					adjacency_array.append(tile)
	if adjacency_array.size() != 4:
		is_edge_tile = true
		board.edge_tiles.append(self)

# Creates a unique ID for each tile.
func get_point_index():
	var a = grid_pos.x
	var b = grid_pos.y
	return (a + b) * (a + b + 1) / 2 + b

# On click event for each tile.
func _on_Tile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if attackable:
				turnManager.selected_unit.attack(unit)
			elif walkable:
				turnManager.selected_unit.move_to(self)
		
#		# debug grid raycast
#		elif event.button_index == BUTTON_RIGHT:
#			if board.los_tile == null:
#				board.los_tile = self
#				$Sprite.modulate = Color.purple
#			else:
#				var tiles = board.get_tiles_between(board.los_tile, self)
#				for _tile in tiles:
#					print(_tile.grid_pos)
#					_tile.get_node("Sprite").modulate = Color.aqua

# Sets whether or not this tile is walkable by whichever tile is selected.
func set_walkable(value: bool):
	if !obstacle and unit == null:
		walkable = value
		if walkable: $Sprite.modulate = Color.blue
		else: $Sprite.modulate = Color.transparent

# Sets whether or not this tile is attackable by whichever tile is selected.
func set_attackable(value: bool):
	if !obstacle and unit != null:
		attackable = value
		unit.set_attackable(value)

func set_in_LOS(value: bool):
	in_LOS = value
	if in_LOS: $Sprite.modulate = Color.yellow
	else: $Sprite.modulate = Color.white
