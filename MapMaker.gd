extends TileMap

onready var board = get_parent()
onready var pathfinding = get_parent().get_node("Pathfinding")


func set_tile_info():
	for _tile in board.tile_array:
		var tile_index = get_cellv(_tile.grid_pos)
		match tile_index:
			0:
				_tile.obstacle = false
			1:
				_tile.obstacle = true
				_tile.blocks_LOS = true
				pathfinding.obstacle_array.append(_tile)
				_tile.get_node("Sprite").modulate = Color.black
