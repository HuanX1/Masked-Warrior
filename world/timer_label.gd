extends Label

func _process(_delta):
	text = GameTimer.format_time(GameTimer.time)
