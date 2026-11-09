extends Area2D

var _collected := false


func _ready() -> void:
	# Si la moneda ya se recogió antes (por ejemplo, al morir y recargar),
	# desaparece de nuevo para no contarla dos veces.
	if GameState.register_coin(_get_scene_path(), get_path()):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if _collected or not body is CharacterBody2D:
		return

	_collected = true
	GameState.collect_coin(_get_scene_path(), get_path())
	queue_free()


func _get_scene_path() -> String:
	if owner != null and owner.scene_file_path != "":
		return owner.scene_file_path

	var current := get_tree().current_scene
	if current != null:
		return current.scene_file_path

	return ""
