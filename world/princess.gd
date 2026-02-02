extends CharacterBody2D

@onready var sprite = $PrincessAnim

func _ready() -> void:
	sprite.play("default")
