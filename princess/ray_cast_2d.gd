extends RayCast2D

@onready var hitbox = $Princess/Interaction/RayCast2D
@onready var popup = $Princess/Interaction/interactLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hitbox.is_colliding():
		for i in range(hitbox.get_collision_count()):
			var collision = hitbox.get_collision(i)
			if collision.is_in_group("player"):
				popup.visible = true
			else:
				popup.visible = false
	else:
		popup.visible = false
