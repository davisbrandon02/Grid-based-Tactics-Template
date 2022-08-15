extends Node2D
class_name Pathfinding

signal pathfinding_initialized

onready var board = get_parent()
var astar = AStar2D.new()
var obstacle_array = Array()
var active_unit = null setget set_active_unit

var path: PoolVector2Array

var start_tile = null setget set_start_tile
var moving = false

# Initializes pathfinding for the first time.
func initialize_pathfinding():
	_add_points(board.tile_array)
	_connect_points(board.tile_array)
	for child in get_parent().get_node("Units").get_children():
		connect("pathfinding_initialized", child, "initialize")
	emit_signal("pathfinding_initialized")

# Adds all points that aren't considered obstacles to the pathfinding array.
func _add_points(_points: Array):
	for _point in _points:
		if _point.obstacle == false: # (and _point.unit == null to make units block pathfinding)
			astar.add_point(_point.get_point_index(), _point.grid_pos)

# Connects each point to the tiles surrounding it. No diagonals - only 4 directions.
func _connect_points(points: Array):
	for point in points:
		for adjacent in point.adjacency_array:
			astar.connect_points(point.get_point_index(), adjacent.get_point_index())

# Creates a path from start to end of tiles. Show debug shows a line along the path.
func _get_path(start, end, show_debug: bool = false):
#	print("end tile: %s" % end.grid_pos)
#	print("getting path from %s to %s:" % [start.grid_pos, end.grid_pos])
	path = astar.get_point_path(start.get_point_index(), end.get_point_index())
	if show_debug: set_debug_path_line(path)
	path.remove(0)
	return path

# Gets the size of the path to the target in tile steps.
func get_distance(start, end):
	var path_to_tgt = _get_path(start, end)
	return path_to_tgt.size()

# Used by _get_path() to show the debug line of a path with Line2D.
func set_debug_path_line(_path):
	var world_path = Array()
	for _point in _path:
		world_path.append(board.grid_to_world(_point))
	$Line2D.points = world_path

# Gets all tiles within a certain distance from this tile.
func get_points_in_range(start_tile, range_param):
	var points_in_range = Array()
	for _tile in board.tile_array:
		if _tile.obstacle == false:
			if _tile != start_tile:
				var tile_distance = get_distance(start_tile, _tile)
				if tile_distance <= range_param:
					points_in_range.append(_tile)
	return points_in_range

# Sets the start tile for a path.
func set_start_tile(_tile):
	start_tile = _tile
	get_points_in_range(_tile, 3)

# Sets the unit that is currently using pathfinding.
func set_active_unit(_unit):
	active_unit = _unit
