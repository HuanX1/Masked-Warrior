extends Node2D

@onready var screenFade = $CanvasLayer2/BlackScreenFade
@onready var audioplayer = $MusicPlayer
@onready var effectplayer = $EffectPlayer

signal playerAnimChange()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameTimer.reach_dest()
	effectplayer.play_music(preload("res://music/vine-boom.ogg"))
	playerAnimChange.emit()
	screenFade.visible = false
	audioplayer.stop_music()
	audioplayer.play_music(preload("res://music/horror.ogg"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_evil_end_interact_evilend(label: Variant) -> void:
	if Input.is_action_just_pressed("ui_interaction"):
		label.text = "Your illusions have been unmasked."
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://storyscreen/end_scene.tscn")


func _on_evil_start_interact_evilstart(label: Variant) -> void:
	if Input.is_action_just_pressed("ui_interaction"):
		label.text = "GO BACK TO WHERE YOU CAME FROM."
