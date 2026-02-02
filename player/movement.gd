extends CharacterBody2D

@onready var attack = $visuals/attackNode
@onready var facing = $visuals
@onready var sprite = $visuals/AnimatedSprite2D
@onready var effectplayer = $"../EffectPlayer"
@export var speed = 1200
@export var jump_speed = 1800
@export var gravity = 4000
@export var friction = 1000
@export var acceleration = 1000
@export var jumpCutVal = 100
@export var coyoteTime = 0.1
@export var health = 3

var evil_frames   := preload("res://player/evil_knight.tscn")

var coyoteTimer = 0.0
var wasOnFloor = false
var invincible = false
var override = false

const FALL_DEATH_Y := 800  # adjust if needed
var is_dead := false


signal heartsBroadcast(hearts)


func _ready() -> void:
	add_to_group("player")

func _physics_process(delta):
	
	#if get_tree().paused:
		#return
	
	if health <=0:
		return
	# Add gravity every frame
	velocity.y += gravity * delta
	
	# Input affects x axis only
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		if not override:
			sprite.play("running")
		facing.scale.x = sign(direction)
		velocity.x = move_toward(velocity.x, speed * direction, delta * acceleration)
	else:
		if not override:
			sprite.play("default")
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	move_and_slide()
	
	# Update coyote timer
	if is_on_floor():
		coyoteTimer = coyoteTime
		wasOnFloor = true
	else:
		
		if wasOnFloor:
			coyoteTimer -= delta
		else:
			coyoteTimer = 0
	
	
	if Input.is_action_just_pressed("ui_accept") and coyoteTimer > 0:
		jump()
		coyoteTimer = 0  
	
	if Input.is_action_just_released("ui_accept"):
		jumpCut()	
	
	if Input.is_action_just_pressed("attack"):
		attack.doAttack()
		
	if not is_dead and global_position.y > FALL_DEATH_Y:
		die()



func jump():
	velocity.y = -jump_speed
	effectplayer.play_music(preload("res://music/8bit-jump.ogg"))

func jumpCut():
	if velocity.y < -jumpCutVal:
		velocity.y = -jumpCutVal

func takeDamage():
	print(health)
	
	if invincible:
		return
	invincible = true
	health -= 1
	override = true
	heartsBroadcast.emit(health)
	
	if health <= 0:
		die()
		return
	sprite.play("hurt")
	await  get_tree().create_timer(0.8).timeout
	override = false
	invincible = false
	
func die():
	if is_dead:
		return
	is_dead = true
	
	invincible = true
	override = true
	sprite.play("death")
	
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://deathscreen 2/death_screen.tscn")
	
	print("real")
	
func _on_attack_node_start_attack() -> void:
	override = true
	sprite.play("attack")


func _on_attack_node_finish_attack() -> void:
	override = false
