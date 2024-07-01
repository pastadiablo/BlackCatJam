class_name AudioButton extends Button

## Called when the button is pressed.
func _pressed():
	# This assumes you have a Sound singleton designed to play sounds with polyphony:
	# https://github.com/Calinou/godot-mdk/blob/master/autoload/sound.gd
	print("playing sound!")
	Sound.play(self, preload("res://sound/UI_Button_Click_1.mp3"))
