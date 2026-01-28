extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scale_factor = Vector2(3.5, 3.5)
	get_viewport().canvas_transform = Transform2D().scaled(scale_factor)
