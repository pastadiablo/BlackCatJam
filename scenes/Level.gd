@tool
class_name Level extends Node

var voidCount: int
var starMargin: float = 0.1
var levelNumber: int = -1
var levelPathKey: String
var clickerLabel: ClickerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var container = find_child("Voids")
	voidCount = container.get_child_count()
	clickerLabel = find_child("Clicker")
	clickerLabel.gameActive = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
