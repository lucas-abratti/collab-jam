extends CharacterBody3D

@export_category("Components")
@export var target_component: TargetComponent
@export_category("Nodes")
@export var animation_player: AnimationPlayer
@export var target_follow_component: TargetFollowComponent

var gravity: float = 9.8

func _ready() -> void:
	animation_player.play("walk")
	if (target_component != null):
		target_follow_component.target = target_component
	target_follow_component.navigation_started.connect(on_navigation_started)
	target_follow_component.navigation_finished.connect(on_navigation_finished)

func _process(delta: float) -> void:
	if (!is_on_floor()):
		velocity.y -= gravity * delta
	else:
		velocity.y -= 2

func on_navigation_started() -> void:
	print("nav started")
	animation_player.play("walk")

func on_navigation_finished() -> void:
	print("nav finished")
	animation_player.play("idle")
