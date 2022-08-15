extends Node2D

signal board_created

onready var tiles = $Tiles
onready var pathfinding = $Pathfinding
onready var tilemap = $MapMaker
onready var turnManager = $TurnManager
var tile_array = Array()
var edge_tiles = Array()

var los_tile = null

export var tile_size: int
onready var half_tile_size = tile_size / 2

var tile_dict : Dictionary = {}

func _ready():
	connect("board_created", $MapMaker, "set_tile_info")
	connect("board_created", pathfinding, "initialize_pathfinding")
	create_board()

# Board generation functions

# Creates a tile and array of tiles filled with indexes from the MapMaker node.
var tile = preload("res://Tile.tscn")
func create_board():
	var used_tiles = tilemap.get_used_cells()
	for _tile in used_tiles:
		var new_tile = tile.instance()
		new_tile.board = self
		new_tile.grid_pos = _tile
		new_tile.position = grid_to_world(_tile)
		new_tile.pathfinding = pathfinding
		new_tile.turnManager = turnManager
		tile_array.append(new_tile)
		tile_dict[_tile] = new_tile
		tiles.add_child(new_tile)
		connect("board_created", new_tile, "get_adjacent_tiles")
	set_tile_adjacencies()

# Sets the neighbors of each cell on the map.
func set_tile_adjacencies():
	for tile in tile_array:
		tile.get_adjacent_tiles()
	emit_signal("board_created")

# Takes grid coordinates and turns them into pixel coordinates.
func grid_to_world(grid_pos: Vector2):
	return (Vector2(grid_pos.x * tile_size + half_tile_size, grid_pos.y * tile_size + half_tile_size))

# Takes pixel coordinates and turns them into grid coordinates.
func world_to_grid(world_pos: Vector2):
	return (Vector2(floor(world_pos.x / tile_size), floor(world_pos.y / tile_size)))

# Returns tile at given grid coordinates.
func get_tile_at(_grid_pos):
	if tile_dict.has(_grid_pos):
		return tile_dict[_grid_pos]
	return null

# Helper functions

# Returns all tiles with units on them.
func get_all_occupied_tiles():
	var output:= []
	for _tile in tile_array:
		if _tile.unit != null:
			output.append(_tile)

# Returns all units on the board.
func get_all_units():
	return $Units.get_children()

# Returns all tiles from one tile to another.
func get_tiles_between(_tile, _endTile, _includeEndTile: bool = true):
	if _tile == _endTile:
		return
	var output:= []
	if _includeEndTile: output.append(_endTile)
	var curTile = _tile
	var nextTile = null
	var diff: Vector2 = _endTile.grid_pos - curTile.grid_pos
	var normal: Vector2 = diff.normalized()
	var step: Vector2 = normal.round()
	while true:
		nextTile = get_tile_at(curTile.grid_pos + step)
		if nextTile == null or nextTile == _endTile:
			return output
		else:
			output.append(nextTile)
			curTile = nextTile
			diff = _endTile.grid_pos - curTile.grid_pos
			normal = diff.normalized()
			step = normal.round()

# Checks whether or not an LOS array from get_tiles_between() is valid.
func has_LOS(_tiles):
	for _tile in _tiles:
		if _tile.blocks_LOS or _tile.obstacle:
			return false
	return true
