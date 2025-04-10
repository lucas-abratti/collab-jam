extends Node

signal global_event_recieved(vec3: Vector3)

@export var global_event: GlobalEventVector3

func _ready() -> void:
	global_event.global_signal.connect(on_global_signal_recieved)

func on_global_signal_recieved(vec3: Vector3) -> void:
	print_rich("[color=yellow]Global Event recieved %s" % vec3)
	global_event_recieved.emit(vec3)
