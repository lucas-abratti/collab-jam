extends Node
class_name ForceFieldNavigator

# Tunable parameters
@export var attraction_strength := 2.0
@export var repulsion_strength := 3.0
@export var influence_radius := 100.0
@export var decay_curve: Curve  # For distance-based falloff

var active_attractors: Array[Vector3] = []
var active_repulsors: Array[Vector3] = []

func calculate_direction(current_pos: Vector3) -> Vector3:
	var net_force := Vector3.ZERO
	# Process attractors
	for point in active_attractors:
		var vec = point - current_pos
		var dist = vec.length()
		if dist > influence_radius:
			continue
			
		var strength = attraction_strength
		if decay_curve:
			strength *= decay_curve.sample(dist / influence_radius)
		net_force += vec.normalized() * strength
	
	# Process repulsors
	for point in active_repulsors:
		var vec = current_pos - point
		var dist = vec.length()
		if dist > influence_radius:
			continue
			
		var strength = repulsion_strength
		if decay_curve:
			strength *= decay_curve.sample(dist / influence_radius)
		net_force += vec.normalized() * strength
	
	return net_force.normalized()

func add_attractor(position: Vector3):
	print("Active repulsors: %s | Active attractors: %s" % [active_repulsors.size(), active_attractors.size()])
	active_attractors.append(position)
	get_tree().create_timer(5).timeout.connect(remove_attractor.bind(position))

func add_repulsor(position: Vector3):
	print("Active repulsors: %s | Active attractors: %s" % [active_repulsors.size(), active_attractors.size()])
	active_repulsors.append(position)
	get_tree().create_timer(5).timeout.connect(remove_repulsor.bind(position))

func remove_attractor(position: Vector3):
	print("Active repulsors: %s | Active attractors: %s" % [active_repulsors.size(), active_attractors.size()])
	active_attractors.erase(position)

func remove_repulsor(position: Vector3):
	print("Active repulsors: %s | Active attractors: %s" % [active_repulsors.size(), active_attractors.size()])
	active_repulsors.erase(position)

func clear_forces():
	active_attractors.clear()
	active_repulsors.clear()
