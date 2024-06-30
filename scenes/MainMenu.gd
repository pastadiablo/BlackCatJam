extends Node

@export var playButton: Button
@export var creditsButton: Button
@export var quitButton: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton.pressed.connect(func():
		SceneLoader.SwitchToScene(SceneLoader.CatScene.Select))
	creditsButton.pressed.connect(func():
		SceneLoader.SwitchToScene(SceneLoader.CatScene.Credits))
	quitButton.pressed.connect(func():
		get_tree().quit())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
