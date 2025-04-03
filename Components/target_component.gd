extends Marker3D
class_name TargetComponent

signal position_changed

var previus_global_pos: Vector3

func _ready() -> void:
	position_changed.emit()

func _process(delta: float) -> void:
	if (previus_global_pos != global_position):
		position_changed.emit()
		previus_global_pos = global_position
