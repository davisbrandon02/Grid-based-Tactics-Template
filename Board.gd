extends Node2D

signal board_created

onready var tiles = $Tiles
onready var pathfinding = $Pathfinding
onready var tilemap = $MapMaker
var tile_array = Array()

export var width: int
export var height: int
export var tile_size: int
var half_tile_size = tile_size / 2


func _ready():
	connect("board_created", $MapMaker, "set_tile_info")
	connect("board_created", pathfinding, "initialize_pathfinding")
	create_board()

var tile = preload("res://Tile.tscn")
func create_board():
	var used_tiles = tilemap.get_used_cells()
	for _tile in used_tiles:
		var new_tile = tile.instance()
		new_tile.board = self
		new_tile.grid_pos = _tile
		new_tile.position = grid_to_world(_tile)
		new_tile.pathfinding = pathfinding
		tile_array.append(new_tile)
		tiles.add_child(new_tile)
		connect("board_created", new_tile, "get_adjacent_tiles")
	set_tile_adjacencies()

func create_board_old():
	for x in width:
		for y in height:
			var new_tile = tile.instance()
			new_tile.board = self
			new_tile.grid_pos = Vector2(x, y)
			new_tile.position = grid_to_world(Vector2(x, y))
			new_tile.pathfinding = pathfinding
			tile_array.append(new_tile)
			tiles.add_child(new_tile)
			connect("board_created", new_tile, "get_adjacent_tiles")
	set_tile_adjacencies()

func set_tile_adjacencies():
	for tile in tile_array:
		tile.get_adjacent_tiles()
	emit_signal("board_created")

func grid_to_world(grid_pos: Vector2):
	return (Vector2(grid_pos.x * tile_size, grid_pos.y * tile_size))

func world_to_grid(world_pos: Vector2):
	return (Vector2(world_pos.x / tile_size, world_pos.y / tile_size))
