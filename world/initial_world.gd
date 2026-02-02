extends Node2D

@export var dialogue_text := "Hello traveler!"
@onready var audioplayer = $MusicPlayer
@onready var effectplayer = $EffectPlayer
@onready var tilemap = $TileMap

@onready var princess = $Princess
@onready var princess_voice: AudioStreamPlayer2D = $Princess/PrincessVoice

@onready var timer_label: Label = $CanvasLayer/TimerLabel

func _ready():
	audioplayer.play_music(preload("res://music/happymusic.ogg"))


func interact():
	print("Interacted")
	#DialogueManager.show_dialogue(dialogue_text)


func _on_interaction_popup_ready(popup, screenFade) -> void:
	if Input.is_action_just_pressed("ui_interaction"):
		
		popup.text = "Wow! Thank you for saving me..."
		princess_voice.play()
		await get_tree().create_timer(4).timeout
		princess_voice.stop()
		
		popup.text = "Take that mask off for me pretty boi"
		princess_voice.play()
		await get_tree().create_timer(4).timeout
		princess_voice.stop()
		
		timer_label.visible = false
		screenFade.visible = true
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://world/evil_world.tscn")

func _on_info_sign_tutorial_tutorialready(label: Variant) -> void:
	print("Connectedd")
	if Input.is_action_just_pressed("ui_interaction"):
		label.text = "A - Left, D - Right, Space - Jump, F or Click - Attack"
