extends CharacterBody3D

@export var dragons_detector_component: Area3D
@export var look_at_3d_modifier_component: LookAt3DModifierComponent

func _ready() -> void:
	dragons_detector_component.area_entered.connect(on_area_entered)
	dragons_detector_component.area_exited.connect(on_area_exited)

func on_area_entered(area: Area3D) -> void:
	print("Dragon entered")
	if (look_at_3d_modifier_component.look_at_target != null): return
	look_at_3d_modifier_component.look_at_target = area

func on_area_exited(area: Area3D) -> void:
	print("Dragon left")
	if (look_at_3d_modifier_component.look_at_target != area): return
	look_at_3d_modifier_component.look_at_target = null
