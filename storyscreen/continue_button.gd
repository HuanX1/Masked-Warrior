extends Button

func _on_continue_button_pressed() -> void:
	print("Continue pressed")
	GameTimer.outbound()
	get_tree().change_scene_to_file("res://world/initial_world.tscn")
