extends PanelContainer

@export var level: Level
@export var clicker: ClickerLabel

@export var statusLabel: Label
@export var scoreLabel: Label
@export var levelSelectButton: Button
@export var retryButton: Button
@export var nextLevelButton: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	
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
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_visible_in_tree(): return
	var currentLevel = level.levelNumber
	if currentLevel < GameStateManager.levelPaths.size()-1:
		var nextPath = GameStateManager.levelPaths[currentLevel+1]
		var requiredStars = GameStateManager.requiredStarMap[nextPath] - GameStateManager.totalStars
		if requiredStars > 0:
			nextLevelButton.hide()
		else:
			nextLevelButton.show()


func _on_timer_level_complete() -> void:
	level.clickerLabel.gameActive = false
	
	var count = clicker.count
	var correctness = float(count) / float(level.voidCount)
	
	var three = 1
	var two = 1 - level.starMargin
	var one = 1 - level.starMargin * 2
	
	var earnedStars: int = 0
	
	if correctness >= three:
		statusLabel.text = "VICTORY!"
		scoreLabel.text = "3/3 Stars!"
		earnedStars = 3
	elif correctness >= two:
		statusLabel.text = "VICTORY!"
		scoreLabel.text = "2/3 Stars!"
		earnedStars = 2
	elif correctness >= one:
		statusLabel.text = "VICTORY!"
		scoreLabel.text = "1/3 Stars!"
		earnedStars = 1
	else:
		statusLabel.text = "DEFEAT!"
		scoreLabel.text = "0/3 Stars!"
		earnedStars = 0
		
	GameStateManager.levelStarMap[level.levelPathKey] = earnedStars
	show()
