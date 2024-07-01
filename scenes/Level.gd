@tool
class_name Level extends Node

var voidCount: int
@export var starMargin: float = 0.1
@export var music: AudioStream
var levelNumber: int = -1
var levelPathKey: String
var clickerLabel: ClickerLabel
var voidsContainer: Node2D
var countdownLabel: Label
var timeLabel: TimeLabel
var scoreScreen: ScoreScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	voidsContainer = find_child("Voids")
	voidCount = voidsContainer.get_child_count()
	if !Engine.is_editor_hint():
		voidsContainer.modulate = Color(voidsContainer.modulate, 0.0)
	clickerLabel = find_child("Clicker")
	timeLabel = find_child("Timer")
	scoreScreen = find_child("ScoreScreen")
	timeLabel.level_complete.connect(endLevel)
	countdownLabel = find_child("CountdownLabel")
	countdownLabel.hide()
	startLevel()

func startLevel():
	#for child in Sound.get_children():
		#child.queue_free()
	#Sound.play(self, music)
	countdownLabel.show()
	countdownLabel.text = "Level %s" % (levelNumber + 1)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(countdownLabel, "modulate", Color(Color.WHITE, 0.0), 2)
	tween.tween_callback(func():
		Sound.play(self, preload("res://sound/UI2_Start_2.mp3"))
		# TODO: Play countdown sound here
		countdownLabel.modulate = Color.WHITE
		countdownLabel.text = "READY?"
	)
	tween.tween_property(countdownLabel, "modulate", Color(Color.WHITE, 0.0), 2)
	tween.tween_interval(1)
	tween.tween_callback(func():
		Sound.play(self, preload("res://sound/UI_Puzzle_Game_4.mp3"))
		countdownLabel.modulate = Color.WHITE
		countdownLabel.text = "3"
	)
	tween.tween_property(countdownLabel, "modulate", Color(Color.WHITE, 0.0), 1)
	tween.tween_callback(func():
		countdownLabel.modulate = Color.WHITE
		countdownLabel.text = "2"
	)
	tween.tween_property(countdownLabel, "modulate", Color(Color.WHITE, 0.0), 1)
	tween.tween_callback(func():
		countdownLabel.modulate = Color.WHITE
		countdownLabel.text = "1"
	)
	tween.tween_property(countdownLabel, "modulate", Color(Color.WHITE, 0.0), 1)
	tween.tween_callback(func():
		countdownLabel.modulate = Color.WHITE
		countdownLabel.text = "COUNT!"
	)
	tween.tween_property(voidsContainer, "modulate", Color(Color.WHITE, 1.0), 1)
	tween.tween_callback(func():
		countdownLabel.hide()
		clickerLabel.gameActive = true
		timeLabel.startTimer()
		for child in voidsContainer.get_children():
			child.start = true
	)

func endLevel() -> void:
	
	var count = clickerLabel.count
	var correctness = float(count) / float(voidCount)
	
	var three = 1
	var twolow = 1 - starMargin
	var onelow = 1 - starMargin * 2
	var twohigh = 1 + starMargin
	var onehigh = 1 + starMargin * 2
	
	var earnedStars: int = 0
	
	if correctness == three:
		earnedStars = 3
	elif correctness >= twolow && correctness <= twohigh:
		earnedStars = 2
	elif correctness >= onelow && correctness <= onehigh:
		earnedStars = 1
	else:
		earnedStars = 0
	
	if earnedStars > 0:
		scoreScreen.voidstar1.animState = VoidStar.State.full_float
	if earnedStars > 1:
		scoreScreen.voidstar2.animState = VoidStar.State.full_float
		scoreScreen.voidstar2.player.seek(0.3)
	if earnedStars > 2:
		scoreScreen.voidstar3.animState = VoidStar.State.full_float
		scoreScreen.voidstar3.player.seek(0.6)
		
	if GameStateManager.levelStarMap.keys().has(levelPathKey):
		GameStateManager.levelStarMap[levelPathKey] = max(earnedStars, GameStateManager.levelStarMap[levelPathKey])
	
	clickerLabel.gameActive = false
	countdownLabel.show()
	countdownLabel.text = "Time's Up!"
	Sound.play(self, preload("res://sound/UI_Puzzle_Game_9_Short.mp3"), -10, 1.0)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(countdownLabel, "modulate", Color(Color.WHITE, 0.0), 2)
	tween.tween_callback(func():
		scoreScreen.show()
	)
	tween.tween_interval(1)
	tween.tween_callback(func():
		if earnedStars > 0:
			Sound.play(self, preload("res://sound/UI_Button_Enable.mp3"), 0.0, 1.0)
		else:
			Sound.play(self, preload("res://sound/UI2_Decline_1.mp3"))
		scoreScreen.voidstar1.show()
	)
	tween.tween_interval(1)
	tween.tween_callback(func():
		if earnedStars > 1:
			Sound.play(self, preload("res://sound/UI_Button_Enable.mp3"), 0.0, 1.2)
		else:
			Sound.play(self, preload("res://sound/UI2_Decline_1.mp3"))
		scoreScreen.voidstar2.show()
	)
	tween.tween_interval(1)
	tween.tween_callback(func():
		if earnedStars > 2:
			Sound.play(self, preload("res://sound/UI_Button_Enable.mp3"), 0.0, 1.4)
		else:
			Sound.play(self, preload("res://sound/UI2_Decline_1.mp3"))
		scoreScreen.voidstar3.show()
	)
	tween.tween_interval(1)
	tween.tween_callback(func():
		if earnedStars > 2:
			Sound.play(self, preload("res://sound/UI_Puzzle_Game_5.mp3"))
			
		if levelNumber < GameStateManager.levelPaths.size()-1:
			var nextPath = GameStateManager.levelPaths[levelNumber]
			var requiredStars = GameStateManager.requiredStarMap[nextPath] - GameStateManager.totalStars
			if requiredStars > 0:
				scoreScreen.nextLevelButton.hide()
			else:
				scoreScreen.nextLevelButton.show()
		scoreScreen.levelSelectButton.show()
		scoreScreen.retryButton.show()
		scoreScreen.statusLabel.show()
	)
	
	
