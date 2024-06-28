class_name VoidAgent extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -400.0
const STEP_UP = -40.0

var direction = 1;

@export var sidesArea: Area2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.x = SPEED * direction;
	var collision = move_and_collide(velocity * delta);
	if collision:
		if (collision.get_normal() == Vector2.LEFT ||
			collision.get_normal() == Vector2.RIGHT):
				if sidesArea.get_overlapping_bodies().has(collision.get_collider()):
					direction *= -1
				else:
					velocity.y = STEP_UP
					
	move_and_slide()
