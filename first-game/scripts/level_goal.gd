extends Area2D

# Escena que se carga al tocar la meta. Si está vacía, no hace nada.
@export_file("*.tscn") var next_scene: String = ""

@onready var sprite: Sprite2D = $Sprite2D

var _base_position: Vector2
var _time := 0.0
var _triggered := false


func _ready() -> void:
	_base_position = sprite.position


func _process(delta: float) -> void:
	_time += delta
	sprite.position.y = _base_position.y + sin(_time * 3.0) * 2.0
	sprite.rotation += delta * 1.5


func _on_body_entered(body: Node2D) -> void:
	if _triggered or not body is CharacterBody2D:
		return

	_triggered = true
	GameState.clear_checkpoint()

	if next_scene != "":
		get_tree().call_deferred("change_scene_to_file", next_scene)
