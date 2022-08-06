extends Node

var selected_unit = null setget set_selected_unit

func set_selected_unit(_unit):
	if selected_unit != null:
		selected_unit.set_selected(false)
	_unit.set_selected(true)
	selected_unit = _unit
