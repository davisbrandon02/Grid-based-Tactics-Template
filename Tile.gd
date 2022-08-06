extends Area2D

var board
var pathfinding
var turnManager

var unit = null

var grid_pos: Vector2
var obstacle: bool = false
var available: bool = false setget set_available
var adjacency_array = Array()

func _ready():
	$CollisionShape2D.shape.extents = Vector2(board.tile_size/2, board.tile_size/2)
	$Label.text = grid_pos as String

# Creates an adjacency array of neighboring tiles.
func get_adjacent_tiles():
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
	for direction in directions:
		for tile in board.tile_array:
			if tile.grid_pos == grid_pos + direction:
				adjacency_array.append(tile)

func get_point_index():
	var a = grid_pos.x
	var b = grid_pos.y
	return (a + b) * (a + b + 1) / 2 + b

func _on_Tile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_RIGHT and available:
			var path = pathfinding._get_path(pathfinding.start_tile, self, true)
			turnManager.selected_unit.move(path)

func set_available(value):
	if !obstacle:
		available = value
		if available: $Sprite.modulate = Color.blue
		else: $Sprite.modulate = Color.transparent
