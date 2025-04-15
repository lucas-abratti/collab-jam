extends Node

@export_category("Global Signals")
@export var left_click_position_sent: GlobalEventVector3
@export var right_click_position_sent: GlobalEventVector3
@export_category("Packed Scenes")
@export var interest_component: PackedScene

func _ready() -> void:
	left_click_position_sent.global_signal.connect(on_left_click)
	right_click_position_sent.global_signal.connect(on_right_click)

func on_left_click(vec3: Vector3) -> void:
	var attractor_i: InterestComponent =  interest_component.instantiate()
	attractor_i.influence = 1
	add_child(attractor_i)
	attractor_i.global_position = vec3

func on_right_click(vec3: Vector3) -> void:
	var rejector_i: InterestComponent =  interest_component.instantiate()
	rejector_i.influence = -1
	add_child(rejector_i)
	rejector_i.global_position = vec3
