class_name ScoreScreen extends PanelContainer

@export var level: Level
@export var clicker: ClickerLabel

@export var statusLabel: Label
@export var scoreLabel: Label
@export var levelSelectButton: Button
@export var retryButton: Button
@export var nextLevelButton: Button

@export var voidstar1: VoidStar
@export var voidstar2: VoidStar
@export var voidstar3: VoidStar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	statusLabel.hide()
	voidstar1.hide()
	voidstar2.hide()
	voidstar3.hide()
	levelSelectButton.hide()
	retryButton.hide()
	nextLevelButton.hide()
	
	levelSelectButton.pressed.connect(func():
		SceneLoader.SwitchToScene(SceneLoader.CatScene.Select))
		
	var currentLevel = level.levelNumber
	
	retryButton.pressed.connect(func():
		SceneLoader.SwitchToScene(SceneLoader.CatScene.Game))
	
	if currentLevel < GameStateManager.levelPaths.size()-1:
		nextLevelButton.pressed.connect(func():
			var path = GameStateManager.levelPaths[currentLevel+1]
			SceneLoader.nextLevel = path
			SceneLoader.SwitchToScene(SceneLoader.CatScene.Game))
	
