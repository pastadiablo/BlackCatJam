class_name TimeLabel extends Label

signal level_complete
@export var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(timer_timeout)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%02d:%02d" % [timer.time_left / 60.0, fmod(timer.time_left, 60.0)]

func timer_timeout():
	level_complete.emit()
	timer.stop()
	print("COMPLETE");
