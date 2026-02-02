extends Node

@onready var player := AudioStreamPlayer.new()

func _ready():
	add_child(player)
	player.bus = "Music"

func play_music(stream: AudioStream):
	if player.stream == stream and player.playing:
		return
	player.stream = stream
	player.volume_db = -25
	player.play()

func stop_music():
	player.stop()
