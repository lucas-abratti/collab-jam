extends Node3D
class_name TargetFollowComponent

signal navigation_started
signal navigation_finished

@export_category("Components")
@export var target: TargetComponent:
	set = set_target
@export var random_target: TargetComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var navigation_agent_3d: NavigationAgent3D

@export_category("Values")
@export var speed: float = 5.0

var target_reached: bool
var current_pos: Vector3
var next_pos: Vector3
var current_velocity: Vector3

func _ready() -> void:
	navigation_agent_3d.target_position = global_position
	navigation_agent_3d.navigation_finished.connect(on_target_reached)
	random_target.position_changed.connect(on_target_position_changed)

func _process(delta: float) -> void:
	if (navigation_agent_3d.is_navigation_finished()): return
	if (target == null): return
	navigation_agent_3d.target_position = target.global_position
	
	next_pos = navigation_agent_3d.get_next_path_position()
	current_velocity = (next_pos - character.global_position).normalized() * speed
	
	character.velocity = character.velocity.move_toward(current_velocity, 1)
	character.move_and_slide()
	var look_at_pos: Vector3 = Vector3(target.global_position.x, 1, target.global_position.z)
	character.look_at(look_at_pos)

func on_target_reached() -> void:
	target_reached = true
	navigation_finished.emit()

func on_target_position_changed() -> void:
	navigation_agent_3d.target_position = target.global_position
	target_reached = false
	navigation_started.emit()

func set_target(value) -> void:
	target_reached = false
	target = value

func go_to_random_position() -> void:
	var range: int = 20
	random_target.global_position += Vector3(randi() % range - randi() % range, 0, randi() % range - randi() % range)
	random_target.position_changed.emit()
