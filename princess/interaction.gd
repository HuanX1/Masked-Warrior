extends Node2D

@onready var hitbox = $ShapeCast2D
@onready var popup = $interactLabel
@onready var screenFade = $"../../CanvasLayer/BlackScreenFade"
@onready var audioplayer = $"../../MusicPlayer"

signal popup_ready(popup, screenFade)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hitbox == null:
		return
	if hitbox.is_colliding():
		for i in range(hitbox.get_collision_count()):
			var collision = hitbox.get_collider(i)
			if collision.is_in_group("player"):
				popup.visible = true
				popup_ready.emit(popup, screenFade)
			else:
				popup.visible = false
	else:
		popup.visible = false
