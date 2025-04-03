extends Area3D
class_name InteractionScannerComponent

signal interactable_found(Interactable: InteractableComponent)

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: InteractableComponent) -> void:
	interactable_found.emit(area)
