extends Node

@export var camera: Camera3D
@export var move_speed := 5.0              # World units per second
@export var lerp_speed := 10.0            # Smoothing speed
@export var min_drag_threshold := 5.0     # Deadzone in screen pixels

var drag_start_pos: Vector2
var is_dragging := false
var target_position: Vector3
var camera_right: Vector3
var camera_forward: Vector3

var use_drag_mouse_control: bool = false

func _ready():
	_update_camera_vectors()
	target_position = camera.global_position

func _update_camera_vectors():
	var basis = camera.global_transform.basis
	camera_forward = Vector3.FORWARD  # Camera's forward direction
	camera_right = basis.x.normalized()     # Camera's right direction

func _process(delta: float):
	# Smooth camera movement
	var camera_dir: Vector2 = Input.get_vector("camera_left", "camera_right",  "camera_forward", "camera_back")
	target_position += Vector3(camera_dir.x, 0, camera_dir.y).normalized() * move_speed * get_process_delta_time()

	if not camera.global_position.is_equal_approx(target_position):
		camera.global_position = camera.global_position.lerp(
			target_position, 
			lerp_speed * delta
		)

func _unhandled_input(event: InputEvent) -> void:
	if (use_drag_mouse_control): 
		drag_mouse_control(event)
		return

func drag_mouse_control(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_update_camera_vectors()
	if event is InputEventKey and event.keycode == KEY_SPACE:
		is_dragging = event.pressed
		get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_dragging:
			drag_start_pos = get_viewport().get_mouse_position()
			get_viewport().set_input_as_handled()
			return
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_dragging = false
	if is_dragging and event is InputEventMouseMotion:
		var current_pos: Vector2 = get_viewport().get_mouse_position()
		var drag_distance: float = (current_pos - drag_start_pos).length()
		if drag_distance < min_drag_threshold:
			return
		var drag_vector: Vector2 = (current_pos - drag_start_pos).normalized()
		var move_dir: Vector3 = -(camera_right * drag_vector.x) + (camera_forward * drag_vector.y)
		target_position += move_dir * move_speed * get_process_delta_time()
		drag_start_pos = current_pos
		get_viewport().set_input_as_handled()
		return
