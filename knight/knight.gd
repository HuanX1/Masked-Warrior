extends CharacterBody2D
@export var health = 15
@export var SPEED = 200.0
const JUMP_VELOCITY = -400.0
var atk = null
@onready var hurtbox = $hurtbox
var blocking = false
@export var gravity = 4000
@onready var sprite = $visuals/AnimatedSprite2D
@onready var facing = $visuals
@onready var hitbox = $visuals/shwing
var blockTimer = 0.0
var charging = false
var chargeTarget = Vector2.ZERO
@export var chargeSpeed = 400.0
@export var chargeOvershoot = 50.0
var chargeDir = Vector2.ZERO
@onready var blockSound = $blockSound
@onready var stabSound = $stabSound
@onready var knightDeath = $knightDeath
@onready var dashSound = $dashSound
@onready var sliceSound = $sliceSound
@onready var startSound = $startDashNoise
var attacks = [
    {
        "name": "slash",
        "min_distance": -100,
        "max_distance": 400,
        "cooldown": 4.0,
        "weight": 6
    },
    {
        "name": "block",
        "min_distance": 0,
        "max_distance": 300,
        "cooldown": 10.0,
        "weight": 4
    },
    {
        "name": "charge",
        "min_distance": 400,
        "max_distance": 2000,
        "cooldown": 5.0,
        "weight": 5
    },]
var attackCooldowns = {}
var currentState = "idle"
var player = null
var current = ""
func _ready():
    player = get_node("/root/InitialWorld/CharacterBody2D")
    for attack in attacks:
        attackCooldowns[attack["name"]] = 10
    sprite.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)
    sprite.frame_changed.connect(_on_AnimatedSprite2D_frame_changed)
    hurtbox.body_entered.connect(_on_hurtbox_body_entered)
    hurtbox.monitoring = false
func _on_hurtbox_body_entered(body):
    if body.is_in_group("player") and hurtbox.monitoring == true:
        body.takeDamage()
func idle(delta):
    sprite.play("default")
    velocity.x = 0
    var dist = global_position.distance_to(player.global_position)
    var chance = 0
    if dist < 300:
        chance = 0.4 * delta
        
    else:
        chance = 0.2 * delta
    if randf() < chance:
            currentState = "chase"
func chase(delta):
    
    sprite.play("walking")
    var direction = (player.global_position - global_position).normalized()
    velocity = direction * SPEED
    var dist = global_position.distance_to(player.global_position)
    var chance = 0
    if dist < 300:
        chance = 0.1 * delta
        
    else:
        chance = 0.3 * delta
    if randf() < chance:
            currentState = "idle"
        
func _physics_process(delta):
    if health <= 0:
        velocity.x = 0
        return
    if blocking:
        blockTimer -= delta
        if blockTimer <= 0:
            endBlock()
        return
    if currentState == "idle":
        idle(delta)
        velocity.y = 100
    elif currentState == "chase":
        chase(delta)
        velocity.y = 0
    elif currentState == "attack":
        if charging:
            processCharge(delta)
    if velocity.x != 0 and currentState != "attack":
        facing.scale.x = sign(velocity.x)
    
    var chance =0.9 * delta
    if randf() < chance and currentState != "attack":
        
        atk = chooseAttack()
        
    if atk != null:
        
        currentState = "attack"
        match atk:
            "slash":
                slash()
            "block":
                block()
            "charge":
                charge()
        atk = null
    updateCooldowns(delta)
    move_and_slide()
    if charging and is_on_wall():
        endCharge()
func updateCooldowns(delta):
    for key in attackCooldowns.keys():
        if attackCooldowns[key] > 0:
            attackCooldowns[key] -= delta
func chooseAttack():
    var validAttacks = []
    var dist = global_position.distance_to(player.global_position)
    for attack in attacks:
        if attackCooldowns[attack["name"]] <= 0 \
        and dist >= attack["min_distance"] \
        and dist <= attack["max_distance"]:
            validAttacks.append(attack)
    if validAttacks.is_empty():
        
        return null
    var totalSum = 0
    for attack in validAttacks:
        totalSum += attack["weight"]
    var r = randi_range(0,totalSum)
    for attack in validAttacks:
        if r < attack["weight"]:
            return attack["name"]
        r -= attack["weight"]
    
func takeDamage():
    if not blocking:
        stabSound.play()
        health -=1
    else:
        blockSound.play()
        counter()
    if health <= 0:
        die()
func slash():
    velocity.x = 0
    sprite.play("attack")
    
func counter():
    sprite.play("counter")
    
func doSlashHit():
    hitbox.enabled = true
    hitbox.force_shapecast_update()

    for i in range(hitbox.get_collision_count()):
        var target = hitbox.get_collider(i)
        if target.is_in_group("player"):
            target.takeDamage()

    hitbox.enabled = false
func charge():
    
    charging = true
    velocity = Vector2.ZERO
    startSound.play()
    await  get_tree().create_timer(0.8).timeout
    hurtbox.monitoring = true
    chargeDir = (player.global_position - global_position).normalized()
    
    facing.scale.x = sign(chargeDir.x)
    if abs(chargeDir.x) > 0.1:  # If we have significant horizontal movement
        chargeDir = Vector2(chargeDir.x, 0).normalized()  # Only horizontal
    else:
        chargeDir = Vector2(facing.scale.x, 0)  # Default to facing direction
    chargeTarget = player.global_position + chargeDir * chargeOvershoot
    sprite.play("running")
    dashSound.play()
    velocity = chargeDir * chargeSpeed
func processCharge(delta):
    if not charging:
        return
    var toTarget = chargeTarget - global_position
    
    
    var remainingDistance = toTarget.length()
    
    # Check if we should stop
    if remainingDistance <= 10 or is_on_wall():  # 10 pixel threshold
        endCharge()
        return
    
    # Normalize movement to prevent overshoot
    var moveDistance = chargeSpeed * delta
    
    if remainingDistance < moveDistance:
        # We're close to target, move exactly the remaining distance
        global_position = chargeTarget
        endCharge()
    else:
        # Continue moving
        global_position += chargeDir * moveDistance
        move_and_slide()  # Still call for collision detection
func endCharge():
    charging = false
    hurtbox.monitoring = false
    currentState = "chase"
    velocity = Vector2.ZERO
func block():
    blocking = true
    blockTimer = randf_range(1.5,2.5)
    sprite.play("block")
    velocity.x = 0
func endBlock():
    blocking = false
    if currentState == "attack":
        currentState = "chase"
    
    
    
    
func die():
    sprite.play("death")
    knightDeath.play()
    await get_tree().create_timer(3).timeout
    queue_free()
func _on_AnimatedSprite2D_animation_finished():
    if currentState == "attack" and not charging:
        
        currentState = "chase"
    
func _on_AnimatedSprite2D_frame_changed():
    if sprite.animation == "attack" and sprite.frame == 2:
        sliceSound.play()
    if sprite.animation == "attack" and sprite.frame == 3:
        
        doSlashHit()
    if sprite.animation == "counter" and sprite.frame == 3:
        doSlashHit()
        
        
