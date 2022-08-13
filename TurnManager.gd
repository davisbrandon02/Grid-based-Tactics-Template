extends Node

var selected_unit = null setget set_selected_unit
var active_side = 0 setget set_active_side

func set_selected_unit(_unit):
	if selected_unit != null:
		selected_unit.set_selected(false)
	_unit.set_selected(true)
	selected_unit = _unit

func set_active_side(_side: int):
	active_side = _side

# Gets all units of the given side
func get_all_units_from_side(_side: int):
	var output = Array()
	for _unit in get_parent().get_node("Units").get_children():
		if _unit.side == _side:
			output.append(_unit)
