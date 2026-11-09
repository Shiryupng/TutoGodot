extends AnimatableBody2D

# Desplazamiento respecto a la posición inicial (en píxeles).
@export var travel: Vector2 = Vector2(0, -64)
# Tiempo que tarda en recorrer "travel".
@export var duration: float = 2.0
# Pausa en cada extremo.
@export var wait_time: float = 0.5

var _origin: Vector2
var _time := 0.0


func _ready() -> void:
	_origin = position


func _physics_process(delta: float) -> void:
	_time += delta
	var cycle := wait_time * 2.0 + duration * 2.0
	var t := fmod(_time, cycle)
	var amount := 0.0

	if t < wait_time:
		amount = 0.0
	elif t < wait_time + duration:
		amount = smoothstep(0.0, 1.0, (t - wait_time) / duration)
	elif t < wait_time * 2.0 + duration:
		amount = 1.0
	else:
		amount = 1.0 - smoothstep(0.0, 1.0, (t - wait_time * 2.0 - duration) / duration)

	position = _origin + travel * amount
