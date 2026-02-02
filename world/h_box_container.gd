extends HBoxContainer

@onready var heart1 = $Heart1
@onready var heart2 = $Heart2
@onready var heart3 = $Heart3
@onready var heartfill = preload("res://world/heartfill.png")
@onready var heartempty = preload("res://world/heartnofill.png")

func _on_character_body_2d_hearts_broadcast(hearts: Variant) -> void:
	if hearts == 3:
		heart1.texture = heartfill
		heart2.texture = heartfill
		heart3.texture = heartfill
	elif hearts == 2:
		heart3.texture = heartempty
	elif hearts == 1:
		heart2.texture = heartempty
	else:
		heart1.texture = heartempty
