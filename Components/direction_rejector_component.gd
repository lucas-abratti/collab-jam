extends Node3D
class_name DirectionRejectorComponent

@export var duration: float = 1.0

func _ready() -> void:
	get_tree().create_timer(duration).timeout.connect(queue_free)
