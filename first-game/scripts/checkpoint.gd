extends Area2D

@onready var flag: Polygon2D = $Flag

var _active := false


func _ready() -> void:
	var scene_path := _current_scene_path()
	if scene_path != "" and GameState.checkpoint_scene == scene_path:
		if GameState.checkpoint_position.distance_to(global_position + Vector2(0, -14)) < 2.0:
			_activate(false)


func _on_body_entered(body: Node2D) -> void:
	if _active or not body is CharacterBody2D:
		return

	_activate(true)
	GameState.set_checkpoint(_current_scene_path(), global_position + Vector2(0, -14))


func _activate(animate: bool) -> void:
	_active = true
	flag.color = Color(0.35, 0.95, 0.45, 1.0)

	if animate:
		var tween := create_tween()
		tween.tween_property(flag, "scale", Vector2(1.4, 1.4), 0.1)
		tween.tween_property(flag, "scale", Vector2(1.0, 1.0), 0.15)


func _current_scene_path() -> String:
	var scene := get_tree().current_scene
	if scene == null:
		return ""
	return scene.scene_file_path
