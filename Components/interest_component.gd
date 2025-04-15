extends Area3D
class_name InterestComponent

@export_category("Values")
@export var range: float = 10.0
@export_range(-1, 1, 0.1) var influence: float
@export var duration: float = 1.0
@export var influence_degradation_curve: Curve
@export_category("Nodes")
@export var collision_shape_3d: CollisionShape3D

var life_time: float = 0.0
var current_influence: float

func _ready() -> void:
	var shape: CylinderShape3D = collision_shape_3d.shape
	shape.radius = range
	if (duration > 0):
		get_tree().create_timer(duration).timeout.connect(queue_free)
	current_influence = influence

func _process(delta: float) -> void:
	if (duration <= 0): return
	life_time += delta
	var normalized_lifetime: float = clamp(life_time / duration, 0.0, 1.0)
	current_influence = influence * influence_degradation_curve.sample(normalized_lifetime)
