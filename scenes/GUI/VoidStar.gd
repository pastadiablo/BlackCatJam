@tool
class_name VoidStar extends Control

enum State {
	empty,
	full,
	full_float
}

@export var animState: State:
	get: return animState
	set(value):
		animState = value
		if !player: return
		print("setting state: %s" % animState)
		player.play("RESET")
		match animState:
			State.empty: player.play("empty")
			State.full: player.play("full")
			State.full_float: player.play("full_float")

@export var starSize: Vector2:
	get: return starSize
	set(value):
		starSize = value
		if texture:
			texture.custom_minimum_size = starSize
			texture.size = starSize
		custom_minimum_size = starSize
		size = starSize

var player: AnimationPlayer
var texture: TextureRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = find_child("AnimationPlayer")
	texture = find_child("Texture")
	texture.custom_minimum_size = starSize
	texture.size = starSize


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
