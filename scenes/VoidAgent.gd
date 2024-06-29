@tool
class_name VoidAgent extends CharacterBody2D

const SPEED = 60.0
const JUMP_VELOCITY = -400.0
const STEP_UP = -40.0

var direction = 1;

enum VoidAnimationState
{
	idle, idle_away, idle_curled, idle_side, idle_side_look, idle_side_away, 
	idle_snooze, idle_snooze_ear_twitch, idle_sphinx
}

var player: AnimationPlayer
var tree: AnimationTree
var playback: AnimationNodeStateMachinePlayback
var sidesArea: Area2D
var sprite: Sprite2D
@export var flipH: bool
@export var animationState: VoidAnimationState:
	get:
		if animationState: 
			return animationState
		return VoidAnimationState.idle
	set(value): 
		animationState = value

func _ready() -> void:
	sprite = find_child("Sprite2D")
	sidesArea = find_child("HeadChecker")
	player = find_child("AnimationPlayer")
	tree = find_child("AnimationTree")
	playback = tree.get("parameters/playback")
	
func _startAnimation():
		if !playback: return
		if animationState != null && player:
			player.play(VoidAnimationState.keys()[animationState])
			player.seek(randf_range(0, 1))
			
func _process(delta: float) -> void:
	if !player.is_playing() || player.current_animation != VoidAnimationState.keys()[animationState]:
		_startAnimation()
	sprite.flip_h = flipH

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
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
	#velocity.x = SPEED * direction;
	var collision = move_and_collide(velocity * delta);
	if collision:
		if (collision.get_normal() == Vector2.LEFT ||
			collision.get_normal() == Vector2.RIGHT):
				if sidesArea.get_overlapping_bodies().has(collision.get_collider()):
					direction *= -1
				else:
					velocity.y = STEP_UP
					
	move_and_slide()
