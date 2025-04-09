extends Node

@export_category("Nodes")
@export var target: Node3D
@export_category("Values")
@export var axis: AXIS = AXIS.Horizontal
@export var frequency: float = 1
@export var amplitude: float = 1

var time: float

enum AXIS {
	Horizontal,
	Vertical,
	Forward,
}

func _physics_process(delta: float) -> void:
	time += delta
	if (target == null): return
	var offset: Vector3
	match axis:
		AXIS.Horizontal:
			offset = Vector3(get_sine(), 0, 0)
		AXIS.Vertical:
			offset = Vector3(0, get_sine(), 0)
		AXIS.Forward:
			offset = Vector3(0, 0, get_sine())
	
	offset = target.transform.basis * offset
	target.position += offset

func get_sine() -> float:
	var sin: float = sin(time * frequency) * amplitude
	#print(sin)
	return sin
