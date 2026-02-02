extends RichTextLabel

@export var full_text := "You walk across the plains, everybody dead at your feet. You thought you were doing the right thing. But after unmasking it all, you realise they were never the monsters, there was never a princess.

It was always you.

"
@export var time_delay := 0.04
@onready var narration_voice := $NarrationVoice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameTimer.end_game("OVER")
	narration_voice.play()
	type_text()

func type_text() -> void:
	for i in full_text.length():
		text += full_text[i]
		await get_tree().create_timer(time_delay).timeout
	
	narration_voice.stop()
	
