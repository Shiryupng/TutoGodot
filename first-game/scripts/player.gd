extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_JUMPS = 2
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var jump_count = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		jump_count=0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count<MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#Play anim
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
