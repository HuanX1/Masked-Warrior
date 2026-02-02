extends Area2D

@onready var hitbox = $ShapeCast2D
@onready var signlabel = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signlabel.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
signal evilend(label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hitbox == null:
		return
	if hitbox.is_colliding():
		for i in range(hitbox.get_collision_count()):
			var collision = hitbox.get_collider(i)
			if collision == null:
				break
			if collision.is_in_group("player"):
				signlabel.visible = true
				evilend.emit(signlabel)
			else:
				signlabel.visible = false
	else:
		signlabel.visible = false
