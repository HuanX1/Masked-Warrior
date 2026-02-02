extends Node2D
@export var cooldown = 0.5
@onready var hitbox = $hitboxCast
var canAttack = true
signal startAttack
signal finishAttack
func doAttack():
	if not canAttack:
		return
	emit_signal("startAttack")
	canAttack = false#redo hitbox detecting later if needed
	if hitbox.is_colliding():
		for i in range(hitbox.get_collision_count()):
			var collision = hitbox.get_collider(i)
			print(collision)
			if collision.is_in_group("enemy"):
				collision.takeDamage()
	
	await  get_tree().create_timer(cooldown).timeout
	emit_signal("finishAttack")
	canAttack = true
	
