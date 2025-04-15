extends Area3D
class_name ForceFieldNavigator

var active_attractors: Array[InterestComponent]
var active_repulsors: Array[InterestComponent]

func _ready() -> void:
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)

func calculate_direction(current_pos: Vector3) -> Vector3:
	var net_force := Vector3.ZERO
	# Process attractors
	for interest in active_attractors:
		var vec = interest.global_position - current_pos
		var dist = vec.length()
		if (dist < 2):
			continue
		net_force += vec.normalized() * interest.current_influence
	
	# Process repulsors
	for interest in active_repulsors:
		var vec = interest.global_position - current_pos
		var dist = vec.length()
		if (dist < 2):
			continue
		net_force += vec.normalized() * interest.current_influence
	
	#if (net_force.length() > 0.5):
		#net_force = net_force.normalized()
	
	return net_force.normalized()

func on_area_entered(area: Area3D) -> void:
	if (area is InterestComponent):
		area = area as InterestComponent
		if area:
			if (area.influence > 0):
				add_attractor(area)
			else:
				add_repulsor(area)

func on_area_exited(area: Area3D) -> void:
	if (area is InterestComponent):
		area = area as InterestComponent
		if area:
			if (area.influence > 0):
				remove_attractor(area)
			else:
				remove_repulsor(area)

func add_attractor(interest_component: InterestComponent):
	active_attractors.append(interest_component)

func add_repulsor(interest_component: InterestComponent):
	active_repulsors.append(interest_component)

func remove_attractor(interest_component: InterestComponent):
	active_attractors.erase(interest_component)

func remove_repulsor(interest_component: InterestComponent):
	active_repulsors.erase(interest_component)

func clear_forces():
	active_attractors.clear()
	active_repulsors.clear()
