extends TargetComponent
class_name MouseTargetComponent

@export var mouse_position_sent: GlobalEventVector3

func _ready() -> void:
	mouse_position_sent.global_signal.connect(on_mouse_position_sent)

func on_mouse_position_sent(pos: Vector3) -> void:
	global_position = pos
	position_changed.emit()
