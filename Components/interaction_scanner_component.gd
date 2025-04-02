extends Area3D
class_name InteractionScannerComponent

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered() -> void:
	print("Interaction available")
	pass
