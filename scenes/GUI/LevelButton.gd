class_name LevelButton extends AudioButton

var earnedStarsLabel: Label

@export var voidstar1: VoidStar
@export var voidstar2: VoidStar
@export var voidstar3: VoidStar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	earnedStarsLabel = find_child("StarsEarned")

func _setStars(score: int):
	voidstar1.animState = VoidStar.State.empty
	voidstar2.animState = VoidStar.State.empty
	voidstar3.animState = VoidStar.State.empty
	
	if score > 0:
		voidstar1.animState = VoidStar.State.full
	if score > 1:
		voidstar2.animState = VoidStar.State.full
	if score > 2:
		voidstar3.animState = VoidStar.State.full
		
