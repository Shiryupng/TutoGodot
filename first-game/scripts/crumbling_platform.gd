extends AnimatableBody2D

# Tiempo que tiembla antes de desaparecer.
@export var shake_time: float = 0.45
# Tiempo que tarda en volver a aparecer.
@export var respawn_time: float = 2.5

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var detector: Area2D = $Detector

var _triggered := false
var _origin: Vector2
var _sprite_origin: Vector2


func _ready() -> void:
	_origin = position
	_sprite_origin = sprite.position


func _physics_process(_delta: float) -> void:
	if _triggered:
		return

	for body in detector.get_overlapping_bodies():
		if body is CharacterBody2D and body.velocity.y >= -5.0 and body.global_position.y < global_position.y:
			_trigger()
			return


func _trigger() -> void:
	_triggered = true

	var step := shake_time / 8.0
	var tween := create_tween()
	for i in range(4):
		tween.tween_property(sprite, "position:x", _sprite_origin.x + 2.0, step)
		tween.tween_property(sprite, "position:x", _sprite_origin.x - 2.0, step)
	await tween.finished

	sprite.position = _sprite_origin
	visible = false
	collision.set_deferred("disabled", true)
	detector.set_deferred("monitoring", false)

	await get_tree().create_timer(respawn_time).timeout

	position = _origin
	visible = true
	collision.set_deferred("disabled", false)
	detector.set_deferred("monitoring", true)
	_triggered = false
