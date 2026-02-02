extends CharacterBody2D

@onready var sprite = $PrincessAnim
#@onready var princess_voice: AudioStreamPlayer2D = $PrincessVoice

func _ready() -> void:
	sprite.play("default")
