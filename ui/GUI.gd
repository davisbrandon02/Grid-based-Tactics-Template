extends Control

# Base for the GUI

onready var board = get_parent().get_parent()
onready var turnManager = get_parent().get_parent().get_node("TurnManager")

func _process(delta):
	if turnManager != null:
		if turnManager.selected_unit == null:
			visible = false
		else:
			visible = true
			$UnitInfoPanel/Panel/MarginContainer/VBoxContainer/TeamContainer/Value.text = turnManager.selected_unit.side as String
			$UnitInfoPanel/Panel/MarginContainer/VBoxContainer/UnitNameContainer/Value.text = turnManager.selected_unit.data.name as String
			$UnitInfoPanel/Panel/MarginContainer/VBoxContainer/HPContainer/Value.text = "%s / %s" % [str(turnManager.selected_unit.hp), str(turnManager.selected_unit.data.base_hp)]
