extends CanvasLayer

@onready var coin_label: Label = $CoinLabel


func _ready() -> void:
	GameState.coins_changed.connect(_update_counter)
	_update_counter()


func _update_counter() -> void:
	var counts := GameState.get_level_coin_counts(_get_scene_path())
	coin_label.text = "MONEDAS: %d / %d" % [counts.x, counts.y]

	if counts.y > 0 and counts.x >= counts.y:
		coin_label.modulate = Color(0.55, 1.0, 0.55)
	else:
		coin_label.modulate = Color.WHITE


func _get_scene_path() -> String:
	if owner != null and owner.scene_file_path != "":
		return owner.scene_file_path

	var current := get_tree().current_scene
	if current != null:
		return current.scene_file_path

	return ""
