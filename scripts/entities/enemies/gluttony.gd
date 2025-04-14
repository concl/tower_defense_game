extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GARF_SPEED = 120
var state_duration = 0
var state

# State
# walk towards player
var is_bouncing = false
# leaps to player, lurp position to a predicited place baased on player's current velocity, falls, and creates a shockwave
var is_jumping = false
# launches lasagna in a circle
var is_shooting = false

func _physics_process(delta: float) -> void:
    var player = get_tree().get_nodes_in_group("Player")[0]
    var direction = player.global_position - global_position
    if direction.length() != 0:
        direction = direction.normalized()
    else:
        direction = Vector2(1,0)
    
    if state_duration == 0:
        handle_state()
    else:
        state_duration -= 1
    
    handle_animation()
    
    if is_bouncing:
        position += direction * GARF_SPEED * delta
    
    if is_shooting:
        shoot()
    
    if is_jumping:
        position += direction * direction.length()
        handle_jump()

func handle_state():
    if state == -1:
        return
    var rng = RandomNumberGenerator.new()
    
    var player = get_tree().get_nodes_in_group("Player")[0]
    var direction = player.global_position - global_position
    
    if direction.length() >= 200 && direction.length() <= 300:
        state = rng.randi_range(0, 2)
    elif direction.length() >= 60:
        state = rng.randi_range(0, 1)
    else:
        state = -1
    
    if state == 2:
        is_bouncing = false
        is_shooting = false
        is_jumping = true
        state_duration = 12 # multiple of 12 fps
    elif state == 1:
        is_bouncing = false
        is_shooting = true
        is_jumping = false
        state_duration = 0
    elif state == 0:
        is_bouncing = true
        is_shooting = false
        is_jumping = false
        state_duration = 7 # multiple of 7 fps
    else:
        is_bouncing = false
        is_shooting = false
        is_jumping = false
        
    

func handle_animation():
    if is_bouncing:
        animated_sprite_2d.play("bounce")
    if is_jumping:
        animated_sprite_2d.play("jump")

func handle_jump():
    pass

func shoot():
    pass
