extends Node
class_name NPCBrainComponent

signal walked
signal idled
signal interacted

@export_category("Components")
@export var target_follow_component: TargetFollowComponent
@export var interaction_scanner_component: InteractionScannerComponent

var tasks: Array

func _ready() -> void:
	target_follow_component.navigation_finished.connect(on_navigation_finished)
	target_follow_component.navigation_started.connect(on_navigation_started)
	interaction_scanner_component.interactable_found.connect(on_interactable_found)

func on_interactable_found(interactable: InteractableComponent) -> void:
	target_follow_component.current_target = interactable.target_component
	await target_follow_component.navigation_finished
	print("Interaction point reached")
	if(target_follow_component.current_target == interactable.target_component):
		interacted.emit()

func on_navigation_finished() -> void:
	idled.emit()
	await get_tree().create_timer(2).timeout
	if (target_follow_component.target_reached):
		walked.emit()
		target_follow_component.go_to_random_position()

func on_navigation_started() -> void:
	walked.emit()
