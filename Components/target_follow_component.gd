extends Node3D
class_name TargetFollowComponent

@export_category("Components")
@export var mouse_target: TargetComponent
@export var target: TargetComponent

@export_category("Nodes")
@export var character: CharacterBody3D
@export var navigation_agent_3d: NavigationAgent3D

@export_category("Values")
@export var speed: float = 5.0

@export_category("GlobalEvents")
@export var mouse_position_sent: GlobalEventVector3

var current_target: TargetComponent:
	set = set_current_target
var target_reached: bool
var current_pos: Vector3
var next_pos: Vector3
var current_velocity: Vector3

func _ready() -> void:
	navigation_agent_3d.target_position = global_position
	#mouse_position_sent.global_signal.connect(on_mouse_position_sent)
	if (mouse_target != null): 
		current_target = mouse_target
	else:
		current_target = target

func update_position(delta: float) -> void:
	if (target_reached): return
	if (current_target == null): return
	navigation_agent_3d.target_position = current_target.global_position
	
	next_pos = navigation_agent_3d.get_next_path_position()
	current_velocity = (next_pos - character.global_position).normalized() * speed
	
	character.velocity = character.velocity.move_toward(current_velocity, 1)
	character.move_and_slide()
	var direction = (next_pos - character.global_position).normalized()
	var target_angle = atan2(direction.x, direction.z)  # Radians
	character.rotation.y = lerp_angle(
		character.rotation.y,
		target_angle,
		delta * 2.0
	)

func on_current_target_position_changed() -> void:
	navigation_agent_3d.target_position = current_target.global_position
	target_reached = false

func set_current_target(new_target: TargetComponent) -> void:
	if (!new_target.position_changed.has_connections()):
		new_target.position_changed.connect(on_current_target_position_changed)
	current_target = new_target
	target_reached = false
	current_target.position_changed.emit()

func go_to_random_position() -> void:
	var range: int = 25
	current_target = target
	target.global_position = Vector3(randi() % range - randi() % range, 1, randi() % range - randi() % range)
	target.position_changed.emit()
