extends RichTextLabel

@export var full_text := "[font_size=32][center]You are the Knight of the Herbonia Realm.

[font_size=24]Your princess has been abducted by the LIME - [b]Lords of Time[/b]. The King has appointed [b]you[/b] to save her from their clutches.

Your journey starts here.[/font_size][/center]"

@export var time_delay := 0.04
@onready var continue_button := $"../ContinueButton"

func _ready():
	text = ""
	type_text()
	continue_button.visible = false
	

func type_text() -> void:
	for i in full_text.length():
		if full_text[i] == "[":
			time_delay = 0
		elif full_text[i] == "]":
			time_delay = 0.04
		text += full_text[i]
		await get_tree().create_timer(time_delay).timeout
	continue_button.visible = true
	
