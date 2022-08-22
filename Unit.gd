extends Area2D
class_name Unit

export var data: Resource = load("res://resource/unit/TestUnit.tres")

# Local variables for a unit, can change
var hp: int = 10

# Turn variables
var can_move: bool = true
var can_attack: bool = true
var selected: bool = false
export var side: int = 0

var attackable: bool = false setget set_attackable
var tile = null

onready var board = get_parent().get_parent()
onready var turnManager = get_parent().get_parent().get_node("TurnManager")
onready var pathfinding = get_parent().get_parent().get_node("Pathfinding")

# Sets the shape of the clickbox and fixes it to the tile and sets unit variables.
func initialize():
	var grid_pos = board.world_to_grid(position)
	$CollisionShape2D.shape.extents = Vector2(board.half_tile_size, board.half_tile_size)
	set_tile(board.get_tile_at(grid_pos))
	
	# Set unit variables
	hp = data.base_hp

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
		$AnimationPlayer.play("selected")
		pathfinding.start_tile = tile
#		set_LOS_tiles()
		if can_move:
			set_walkable_tiles()
		if can_attack:
			set_attackable_tiles()
	else:
		set_walkable_tiles()
		set_attackable_tiles()
		$AnimationPlayer.play("ready")

# On click
func _on_Unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if turnManager.player_side == side:
				turnManager.set_selected_unit(self)

# Ends this unit's turn
func end_turn():
	print("%s ends turn" % self.name)
	if turnManager.player_side == side:
		turnManager.set_selected_unit(null)
	else:
		turnManager.next_unit()

# Function used to actually move the unit.
func move(_path):
	if _path.size() > 0:
		can_move = false
		set_walkable_tiles()
		var _tile = board.get_tile_at(_path[-1])
		for pathTileGridPos in _path:
			var pathTile = board.get_tile_at(pathTileGridPos)
			var timer = Timer.new()
			timer.wait_time = 0.1
			timer.one_shot
			add_child(timer)
			timer.start()
			yield(timer, "timeout")
			timer.queue_free()
			set_tile(pathTile)
		set_tile(_tile)
		set_attackable_tiles()
		if get_attackable_units().size() < 1:
			end_turn()

# Gets a path to the point and moves the unit there.
func move_to(_tile):
	var _path = pathfinding._get_path(pathfinding.start_tile, _tile)
	move(_path)

# Function used to make this unit attack another.
# Where the fork in this template happens: either a hit chance or a damage calculation.
# This branch will use a damage calculation, often used in wargames.
# Always ends turn.
func attack(_target):
	_target.damage(data.attack_damage)
	can_attack = false
	end_turn()
	print("%s attacks %s for %s damage" % [self.name, _target.name, str(data.attack_damage)])

# Damages this unit with the specific amount of attack damage.
func damage(_amount):
	hp -= _amount
	$AnimationPlayer.play("hurt")
	print("%s takes %s damage. HP is now %s" % [self.name, str(_amount), str(hp)])

# Gets the tiles within move range of this unit.
func get_walkable_tiles():
	return pathfinding.get_points_in_range(tile, data.move_range)

# Gets all tiles within attack range. Have to add LOS check once LOS is implemented.
func get_attackable_tiles():
	return pathfinding.get_points_in_range(tile, data.attack_range)

# Gets all tiles within LOS.
func get_LOS_tiles():
	var _LOS_range_tiles = pathfinding.get_points_in_range(tile, data.LOS_range)
	var output:= []
	for _tile in _LOS_range_tiles:
		var line = board.get_tiles_between(tile, _tile)
		if board.has_LOS(line):
			output.append(_tile)
	return output

# Sets all tiles visible to this unit as within LOS.
func set_LOS_tiles():
	for _tile in get_LOS_tiles():
		if _tile.obstacle == false and _tile.blocks_LOS == false and _tile.unit == null:
			_tile.set_in_LOS(true)

# Gets attackable units in attack range.
func get_attackable_units():
	var output:= []
	var LOS_tiles = get_LOS_tiles()
	for _tile in get_attackable_tiles():
		if _tile.unit != null:
			output.append(_tile.unit)
	return output

# Sets the tiles within move range of this unit as walkable.
func set_walkable_tiles():
	for _tile in board.tile_array:
		_tile.set_walkable(false)
	if can_move:
		for _tile in get_walkable_tiles():
			_tile.set_walkable(true)

# Sets tiles within attack range as attackable.
func set_attackable_tiles():
	var LOS = get_LOS_tiles()
	for _tile in board.tile_array:
		_tile.set_attackable(false)
	if can_attack:
		for _tile in get_attackable_tiles():
			if _tile.unit != null and _tile in LOS:
				_tile.set_attackable(true)

# Sets this unit as attackable by whichever unit is selected.
func set_attackable(value: bool):
	attackable = value
	if attackable: $Sprite.modulate = Color.red
	else: $Sprite.modulate = Color.white
