class_name TimeLabel extends Label

signal level_complete
var timer: Timer
var tickTimer: Timer
@export var waitTime: int = 30
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = find_child("Timer")
	if !timer: return
	timer.wait_time = waitTime
	timer.timeout.connect(timer_timeout)
	text = "%02d:%02d" % [waitTime / 60.0, fmod(waitTime, 60.0)]
	
	tickTimer = Timer.new()
	add_child(tickTimer)
	tickTimer.wait_time = 1.0
	tickTimer.timeout.connect(func():
		Sound.play(self, preload("res://sound/UI2_Click_1.mp3"), -10, 1.0)
		if timer.time_left < 4:
			Sound.play(self, preload("res://sound/UI_Puzzle_Game_8.mp3"))
	)

func startTimer():
	timer.start()
	tickTimer.start()
	Sound.play(self, preload("res://sound/UI2_Click_1.mp3"))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%02d:%02d" % [timer.time_left / 60.0, fmod(timer.time_left, 60.0)]

func timer_timeout():
	level_complete.emit()
	timer.stop()
	tickTimer.stop()
