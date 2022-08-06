extends Area2D

var grid_pos: Vector2
var board
var pathfinding
var obstacle: bool
var adjacency_array = Array()

func _ready():
	$CollisionShape2D.shape.extents = Vector2(board.tile_size/2, board.tile_size/2)
	$Label.text = grid_pos as String

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
		if event.button_index == BUTTON_LEFT:
			pathfinding.moving = true
			pathfinding.set_start_tile(self)
			$Sprite.modulate = Color.yellow
			print("origin tile: %s" % self.grid_pos)
		elif event.button_index == BUTTON_RIGHT:
			$Sprite.modulate = Color.green
			pathfinding._get_path(pathfinding.start_tile, self, true)
