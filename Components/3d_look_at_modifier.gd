class_name LookAt3DModifierComponent
extends Node

@export var object: Node3D
@export var look_at_target: Node3D
@export var rotation_speed: float = 5.0  # Radians per second
@export var max_yaw_angle: float = TAU  # Full rotation by default (TAU = 360°)
@export var max_pitch_angle: float = PI/4  # 45° up/down by default

func _ready() -> void:
	if object == null:
		object = get_parent() as Node3D
	assert(object != null, "No object assigned and parent isn't Node3D")

func _process(delta: float) -> void:
	if not _validate_nodes(): return
	var original_scale = object.scale
	var current_transform: Transform3D = object.global_transform
	var target_position: Vector3 = look_at_target.global_position
	# Get direction and ensure we're not looking at ourselves
	var direction: Vector3 = (target_position - object.global_position)
	if direction.length_squared() < 0.0001:
		return
		
	direction = direction.normalized()
	# Create properly orthonormalized basis
	var target_basis: Basis = Basis.looking_at(direction, Vector3.UP).orthonormalized()
	var current_basis: Basis = current_transform.basis.orthonormalized()
	# Apply angle constraints
	target_basis = _constrain_rotation(current_basis, target_basis)
	# Smoothly rotate
	var new_basis: Basis = current_basis.slerp(target_basis, rotation_speed * delta)
	object.global_transform.basis = new_basis.orthonormalized()
	object.scale = original_scale

func _constrain_rotation(current: Basis, target: Basis) -> Basis:
	# Convert to quaternions for easier angle math
	var current_quat: Quaternion = current.get_rotation_quaternion()
	var target_quat: Quaternion = target.get_rotation_quaternion()
	# Get relative rotation
	var relative_quat: Quaternion = current_quat.inverse() * target_quat
	var angles: Vector3 = relative_quat.get_euler()
	# Apply constraints (convert angles to -PI..PI range first)
	angles.y = wrapf(angles.y, -PI, PI)
	angles.x = wrapf(angles.x, -PI, PI)
	angles.y = clamp(angles.y, -max_yaw_angle/2, max_yaw_angle/2)
	angles.x = clamp(angles.x, -max_pitch_angle/2, max_pitch_angle/2)
	# Return constrained rotation
	return current * Basis.from_euler(angles).orthonormalized()

func _validate_nodes() -> bool:
	if object == null or look_at_target == null:
		return false
	if not is_instance_valid(object) or not is_instance_valid(look_at_target):
		return false
	return true
