extends CharacterBody2D

const SPEED = 60
var direction = 1
var override = false

@export var health = 2
@onready var raycastRight = $visual/RayCastRight
@onready var raycastLeft = $visual/RayCastLeft
@onready var hitboxr = $visual/attackNode/hitboxcaster
@onready var hitboxl = $visual/attackNode/hitboxcaster2
@onready var body = $AnimatedSprite2D
@export var gravity = 4000

func _ready():
	add_to_group("enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	velocity.y += gravity * delta
	
	if override == false:
		body.play("default")
	
	if raycastRight.is_colliding():
		direction = -1
		body.flip_h = true
	elif raycastLeft.is_colliding():
		direction = 1
		body.flip_h = false
	
	if hitboxr.is_colliding() and direction == 1:
		for i in range(hitboxr.get_collision_count()):
			var collision = hitboxr.get_collider(i)
			if collision.is_in_group("player"):
				collision.takeDamage()
				
	if hitboxl.is_colliding() and direction == -1:
		for x in range(hitboxl.get_collision_count()):
			var collision = hitboxl.get_collider(x)
			if collision.is_in_group("player"):
				collision.takeDamage()

	position.x += SPEED*direction*delta			
func takeDamage():
	override = true
	body.play("hurt")
	await get_tree().create_timer(1).timeout
	override = false
	health -=1
	if health <= 0:
		die()

func die():
	print(health)
	queue_free()
		
		
	
	
	
