extends Resource
class_name UnitData

# Base variables for a unit (do not change during gameplay)

export var name: String = "Base Unit"
export var move_range: int = 5
export var attack_range: int = 5
export var base_hp: int = 10
export var attack_damage: int = 2
export var LOS_range: int = 10
export var texture: Texture = preload("res://icon.png")
