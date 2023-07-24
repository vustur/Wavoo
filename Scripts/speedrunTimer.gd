extends RichTextLabel

@export var msTimer : Timer
var minutes = 0
var seconds = 0
var ms = 0
var showSeconds : String
var showMinutes : String
var showMs : String
var addText = ""

func _process(_delta):
	if ms == 100:
		ms=0
		seconds += 1
	if seconds == 60:
		seconds = 0
		minutes += 1

	if seconds < 10:
		showSeconds = "0" + var_to_str(seconds)
	else:
		showSeconds = var_to_str(seconds)
	if minutes < 10:
		showMinutes = "0" + var_to_str(minutes)
	else:
		showMinutes = var_to_str(minutes)
	if ms < 10:
		showMs = "0" + var_to_str(ms)
	else:
		showMs = var_to_str(ms)

	if minutes == 59 and seconds == 59 and ms == 95:
		addText = "< "
		msTimer.stop()
		showMs = "59"

	text = "[font_size=60]" + addText + showMinutes + ":" + showSeconds + ".[/font_size][font_size=35]" + showMs + "[/font_size]"
	pass


func onMsTimerTimeout():
	ms += 5
	pass

#func onPauseMenuEnabled():
#	msTimer.paused = true
#	pass

#func onPauseMenuDisabled():
#	msTimer.paused = false
#	pass

