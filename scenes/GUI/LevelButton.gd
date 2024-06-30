class_name LevelButton extends Button

var earnedStarsLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	earnedStarsLabel = find_child("StarsEarned")
