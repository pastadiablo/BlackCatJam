extends Label

@export var count: int
var player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = find_child("AnimationPlayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%01d %01d" % [count/10, fmod(count, 10)]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("count_increment"):
		if event.is_action_pressed("count_increment"):
			if count+1 < 100:
				count += 1
				player.play("click_increment")
		else: 
			if event.is_action_released("count_increment"):
				player.queue("idle")
	else:
		if event.is_action("count_decrement"):
			if event.is_action_pressed("count_decrement"):
				if count-1 >= 0:
					count -= 1
					player.play("click_decrement")
			else:
				if event.is_action_released("count_decrement"):
					player.queue("idle")
			
		
