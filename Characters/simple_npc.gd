extends CharacterBody3D

@export_category("Components")
@export var target_component: TargetComponent
@export var npc_brain_component: NPCBrainComponent
@export var navigator_component: ForceFieldNavigator

@export_category("Nodes")
@export var animation_player: AnimationPlayer
@export var target_follow_component: TargetFollowComponent
@export var food: Node3D

@export_category("AI")
@export var ai:UtilityAIAgent
@export var current_action:UtilityAIAction
@export var distance_to_target_sensor: UtilityAISensor
@export var exhaustion_sensor: UtilityAISensor
@export var hunger_sensor: UtilityAISensor
@export var food_sensor: UtilityAISensor

var exhaustion: float = 0.0
@export var hunger: float = 0.5
@export var available_food: float = 0

func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_finished)
	if (target_component != null):
		target_follow_component.mouse_target = target_component
		target_follow_component.set_current_target(target_component)
	ai.action_changed.connect(_on_utility_ai_agent_action_changed)
	current_action = null

func _process(delta: float) -> void:
	if (!is_on_floor()):
		velocity.y -= 9.8 * delta
	else:
		velocity.y -= 2
	# Sense
	var vec_to_target = target_follow_component.current_target.global_position - global_position 
	var distance = vec_to_target.length()
	distance_to_target_sensor.sensor_value = distance / 10.0
	exhaustion_sensor.sensor_value = exhaustion
	hunger_sensor.sensor_value = hunger
	hunger_sensor.is_active = available_food > 0
	food_sensor.sensor_value = available_food / 10
	# Think
	ai.evaluate_options(delta)
	ai.update_current_behaviour()
	# Act
	if current_action == null:
		return
	# Update the position
	# Update otherwise based on current action.
	if current_action.name == "Move":
		exhaustion += 0.1 * delta
		hunger += 0.1 * delta
		var new_target_pos = navigator_component.calculate_direction(global_position) * delta * target_follow_component.speed
		target_component.global_position = global_position + new_target_pos * 100
		target_follow_component.update_position(delta)
		animation_player.play("walk")
		if distance <= 2.0:
			current_action.is_finished = true
	elif current_action.name == "Interact":
		animation_player.play("interact-left")
	elif current_action.name == "Idle":
		animation_player.play("idle")
		current_action.is_finished = true
	elif current_action.name == "Sit":
		animation_player.play("sit")
		exhaustion -= 0.5 * delta
		if (exhaustion <= 0.01):
			current_action.is_finished = true
	elif current_action.name == "Eat":
		if (hunger >= 0.1):
			food.visible = true
			animation_player.play("interact-right")
		else:
			food.visible = false
			current_action.is_finished = true

func start_action(action_node: UtilityAIAction):
	current_action = action_node
	if (action_node != null):
		print("Starting action %s" % action_node.name)
	if action_node.name == "Move":
		pass
	elif action_node.name == "Interact":
		pass
	elif action_node.name == "Idle":
		pass
	elif action_node.name == "Sit":
		pass

func end_action(action_node: UtilityAIAction):
	if (action_node != null):
		print("Ending action %s" % action_node.name)
	if action_node.name == "Move":
		pass
	elif action_node.name == "Interact":
		target_follow_component.go_to_random_position()
		pass
	elif action_node.name == "Idle":
		pass
	elif action_node.name == "Eat":
		pass

func _on_utility_ai_agent_action_changed(action_node: UtilityAIAction):
	if action_node == current_action:
		return
	if current_action != null:
		end_action(current_action)
	current_action = action_node
	if current_action != null:
		start_action(current_action)

func on_animation_finished(anim_name: String) -> void:
	if (anim_name == "interact-left" && current_action != null):
		available_food += 0.2
		current_action.is_finished = true
	if (anim_name == "idle" && current_action != null):
		current_action.is_finished = true
	if (anim_name == "interact-right" && current_action != null):
		if (available_food > 1):
			hunger -= 1
			available_food -= 1
		else:
			hunger -= available_food
			available_food = 0
	
