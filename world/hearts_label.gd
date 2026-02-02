extends Label

func _on_character_body_2d_hearts_broadcast(hearts: Variant) -> void:
	text = "Hearts: " + str(hearts)
