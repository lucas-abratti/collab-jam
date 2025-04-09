extends VBoxContainer

@export var play_game_btn: Button
@export var game_scene: PackedScene

func _ready() -> void:
	play_game_btn.pressed.connect(on_play_game_pressed)
	if (OS.get_cmdline_args().has("test")):
		play_game_btn.pressed.emit()

func on_play_game_pressed() -> void:
	get_tree().change_scene_to_packed.call_deferred(game_scene)
