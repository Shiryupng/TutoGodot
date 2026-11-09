extends Node2D

@export var speed: float = 60.0

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) :
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	# Gira al llegar al borde de la plataforma en vez de caerse.
	if direction > 0 and not ray_cast_down_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if direction < 0 and not ray_cast_down_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	position.x += direction * speed * delta
