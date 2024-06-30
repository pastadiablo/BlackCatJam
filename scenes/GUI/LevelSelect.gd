class_name LevelSelect extends Node

var levelsContainer: Container
var returnToMenuButton: Button
var totalStarsLabel: Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levelsContainer = find_child("LevelsContainer")
	for child in levelsContainer.get_children():
		child.queue_free()
	returnToMenuButton = find_child("ReturnToMenuButton")
	returnToMenuButton.pressed.connect(func():
		SceneLoader.SwitchToScene(SceneLoader.CatScene.Menu))
	totalStarsLabel = find_child("TotalStarsLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	totalStarsLabel.text = "Total Stars: %02d" % GameStateManager.totalStars
	if levelsContainer.get_child_count() == 0 && GameStateManager.levelPaths.size() > 0:
		for index in range(GameStateManager.levelPaths.size()):
			var button: LevelButton = load("res://scenes/GUI/LevelButton.tscn").duplicate().instantiate()
			var path = GameStateManager.levelPaths[index]
			button.pressed.connect(func():
				SceneLoader.nextLevel = path
				SceneLoader.SwitchToScene(SceneLoader.CatScene.Game)
			)
			levelsContainer.add_child(button)
			var requiredStars = GameStateManager.requiredStarMap[path] - GameStateManager.totalStars
			if requiredStars > 0:
				button.text = "Need %d more stars!" % requiredStars
				button.disabled = true
				button.earnedStarsLabel.hide()
			else:
				button.text = "Level %02d" % (index+1)
				button.disabled = false
				button.earnedStarsLabel.show()
				button.earnedStarsLabel.text = "%d/3" % GameStateManager.levelStarMap[path]
	
