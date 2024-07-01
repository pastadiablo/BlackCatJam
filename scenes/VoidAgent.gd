@tool
class_name VoidAgent extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const STEP_UP = -40.0
const RUNTHRESHOLD = 30.0

var direction = 1;

enum VoidAnimationState
{
	idle, idle_away, idle_curled, idle_side, idle_side_look, idle_side_away, 
	idle_snooze, idle_snooze_ear_twitch, idle_sphinx, walk, run
}

var player: AnimationPlayer
var tree: AnimationTree
var playback: AnimationNodeStateMachinePlayback
var sidesArea: Area2D
var sprite: Sprite2D
var left: Area2D
var right: Area2D
var start: bool = false

@export var moves: bool
@export var speed: float
@export var flipH: bool
@export var animationState: VoidAnimationState:
	get:
		if animationState: 
			return animationState
		return VoidAnimationState.idle if !moves else VoidAnimationState.walk
	set(value):
		if moves && (value != VoidAnimationState.walk || value != VoidAnimationState.run):
			animationState = VoidAnimationState.walk if speed < RUNTHRESHOLD else VoidAnimationState.run
		animationState = value

func _ready() -> void:
	sprite = find_child("Sprite2D")
	sidesArea = find_child("HeadChecker")
	player = find_child("AnimationPlayer")
	tree = find_child("AnimationTree")
	right = find_child("Right")
	left = find_child("Left")
	right.body_exited.connect(func(body):
		if left.get_overlapping_bodies().has(body):
			print("detected missing right side! %s" % body)
			direction *= -1)
	left.body_exited.connect(func(body):
		if right.get_overlapping_bodies().has(body):
			print("detected missing left side! %s" % body)
			direction *= -1)
	playback = tree.get("parameters/playback")
	direction = -1 if flipH else 1
	
func _startAnimation():
		if !playback: return
		if animationState != null && player:
			player.play(VoidAnimationState.keys()[animationState])
			player.seek(randf_range(0, 1))
			
func _process(delta: float) -> void:
	if !start && !Engine.is_editor_hint(): return
	if moves && (animationState != VoidAnimationState.walk || animationState != VoidAnimationState.run):
		animationState = VoidAnimationState.walk if speed < RUNTHRESHOLD else VoidAnimationState.run
	if !player.is_playing() || player.current_animation != VoidAnimationState.keys()[animationState]:
		_startAnimation()
	#if !moves || Engine.is_editor_hint():
	sprite.flip_h = flipH

func _physics_process(delta: float) -> void:
	if !start || !moves || Engine.is_editor_hint(): return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	velocity.x = speed * direction;
	flipH = velocity.x < 0
	var collision = move_and_collide(velocity * delta);
	if collision:
		if (collision.get_normal() == Vector2.LEFT ||
			collision.get_normal() == Vector2.RIGHT):
				direction *= -1
				#if sidesArea.get_overlapping_bodies().has(collision.get_collider()):
					
				#else:
					#velocity.y = STEP_UP
	move_and_slide()
