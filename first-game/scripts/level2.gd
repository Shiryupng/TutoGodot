extends Node2D

# Al recargar la escena (por ejemplo al morir), reaparece en el último checkpoint.
func _ready() -> void:
	if GameState.checkpoint_scene != scene_file_path:
		return
	if GameState.checkpoint_position == Vector2.ZERO:
		return

	var player := get_node_or_null("Player")
	if player == null:
		return

	player.global_position = GameState.checkpoint_position
	var camera := player.get_node_or_null("Camera2D")
	if camera:
		camera.reset_smoothing()
