extends Node

var active_side = 0 setget set_active_side
var selected_unit = null setget set_selected_unit
export var player_side: int = 0
export var amountOfSides: int = 1 # 0 counts as 1, so 1 is actually 2

onready var board = get_parent()
onready var pathfinding = get_parent().get_node("Pathfinding")

# Sets the side whose turn it currently is
func set_active_side(_side: int):
	active_side = _side

# Sets the currently active unit
func set_selected_unit(_unit):
	if selected_unit == _unit:
		return
		
	if selected_unit != null:
		selected_unit.set_selected(false)
	
	if _unit == null:
		selected_unit = null
		return
		
	_unit.set_selected(true)
	pathfinding.set_active_unit(_unit)
	selected_unit = _unit

# Moves on to the next unit on a side (used by the AI)
func next_unit():
	pass

# Gets all units of the given side
func get_all_units_from_side(_side: int):
	var output = Array()
	for _unit in get_parent().get_node("Units").get_children():
		if _unit.side == _side:
			output.append(_unit)

# Selects a random unit to start turn on (used by the AI)
func get_random_unit_from_side(_side: int):
	var allUnitsFromSide = get_all_units_from_side(_side)
	return allUnitsFromSide[randi() % allUnitsFromSide.size()]
