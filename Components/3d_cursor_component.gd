extends Node

@export var mouse_position_sent: GlobalEventVector3
@export var left_click_position_sent: GlobalEventVector3
@export var right_click_position_sent: GlobalEventVector3
@export var camera: Camera3D
var viewport: Viewport
var mouse_2d_pos: Vector2
var mouse_3d_pos: Vector3
var target_3d_pos: Vector3

func _ready() -> void:
	viewport = camera.get_viewport()

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventJoypadButton):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif (event is InputEventMouseMotion):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if (Input.is_action_just_pressed("attract") || Input.is_action_just_pressed("reject")):
		mouse_2d_pos = viewport.get_mouse_position()
		var ray_origin: Vector3 = camera.project_ray_origin(mouse_2d_pos)
		var ray_target: Vector3 = ray_origin + camera.project_ray_normal(mouse_2d_pos) * 2000
		var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
		var physics_ray_query_parameters3D: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_target, 2)
		var intersection:= space_state.intersect_ray(physics_ray_query_parameters3D)
		if (intersection.has("position") && intersection["position"] != null):
			mouse_position_sent.global_signal.emit(intersection["position"])
			if (Input.is_action_just_pressed("attract")):
				left_click_position_sent.global_signal.emit(intersection["position"])
			elif (Input.is_action_just_pressed("reject")):
				right_click_position_sent.global_signal.emit(intersection["position"])
	
