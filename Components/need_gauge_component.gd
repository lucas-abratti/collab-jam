extends Node
class_name NeedGaugeComponent

@export var need_type: Enums.INTERACTION_TYPE
@export_range(0, 1, 0.1) var current_need: float
@export_range(0.1, 1, 0.1) var need_increment: float
@export_exp_easing("inout") var need_multiplayer

func _process(delta: float) -> void:
	current_need += need_increment * delta

func get_priority() -> float:
	return current_need * need_multiplayer
