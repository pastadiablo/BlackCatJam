extends Label

@export var count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%02d" % count

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("count_increment") && event.is_action_pressed("count_increment"):
		if count+1 < 100:
			count += 1
	else:
		if event.is_action("count_decrement") && event.is_action_pressed("count_decrement"):
			if count-1 >= 0:
				count -= 1
		
