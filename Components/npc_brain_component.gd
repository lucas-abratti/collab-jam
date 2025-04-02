extends Node

@export_category("Components")
@export var target_follow_component: TargetFollowComponent

var tasks: Array

func _ready() -> void:
	target_follow_component.navigation_finished.connect(on_navigation_finished)

func on_navigation_finished() -> void:
	target_follow_component.go_to_random_position()
