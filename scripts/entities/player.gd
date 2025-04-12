extends Entity

@onready var sprites: Node2D = $Sprites
@onready var player_sprite: AnimatedSprite2D = $Sprites/PlayerSprite



# Parameters
var dash_speed = 1600
var dash_frames = 12

var jump_frames = 45
var jump_accel = 40

var invincible_frames = 60

var SPEED = 400
var acceleration = 120

var stamina = 60

# State
var is_dashing = false
var is_jumping = false

var jump_progress = 0

var invincible_progress = 0

var dash_direc = Vector2()
var dash_progress = 0

var move_direc = Vector2()

# Animation
var current_animation = "idle"


func handle_dash():
    velocity = dash_direc * dash_speed
    if dash_progress == 0:
        is_dashing = false
    else:
        dash_progress -= 1

func handle_jump(delta: float):
    if move_direc.length() != 0:
        velocity = velocity.move_toward(move_direc * SPEED, jump_accel * delta * 60)
    
    if jump_progress == 0:
        is_jumping = false
    else:
        jump_progress -= 1


# handles general movement
func handle_general(delta: float):
    velocity = velocity.move_toward(move_direc * SPEED, acceleration * delta * 60)
    

func handle_sprites():
    var run_check = move_direc.length() > 0
    
    if !run_check and !is_dashing and !is_jumping and current_animation != "idle":
        current_animation = "idle"
        player_sprite.play("idle")
    
    if run_check and !is_dashing and !is_jumping and current_animation != "run":
        current_animation = "run"
        player_sprite.play("run")
    
    if is_jumping and current_animation != "jump":
        current_animation = "jump"
        player_sprite.play("jump")

func handle_input(delta: float):
    # Handle looking
    var mouse_pos = get_global_mouse_position()
    if mouse_pos.x > self.global_position.x:
        sprites.scale.x = -abs(sprites.scale.x)  # Flip horizontally if on the left side
    else:
        sprites.scale.x = abs(sprites.scale.x)  # No flip if on the right side
    
    # Handle movement direction
    move_direc = Vector2(0,0)
    if Input.is_action_pressed("move_right"):
        move_direc += Vector2(1,0)
        
    if Input.is_action_pressed("move_left"):
        move_direc += Vector2(-1,0)
        
    if Input.is_action_pressed("move_up"):
        move_direc += Vector2(0,-1)
    
    if Input.is_action_pressed("move_down"):
        move_direc += Vector2(0,1)
    
    move_direc = move_direc.normalized()
    
    if Input.is_action_just_pressed("dash") and !is_dashing and !is_jumping and stamina >= 48:
        stamina -= 48
        is_dashing = true
        dash_direc = move_direc
        dash_progress = dash_frames
    
    if Input.is_action_just_pressed("jump") and !is_jumping:
        is_jumping = true
        is_dashing = false
        dash_progress = 0
        dash_direc = Vector2()
        jump_progress = jump_frames
    

func _physics_process(delta: float) -> void:
    handle_input(delta)
    
    handle_sprites()
    
    if is_dashing:
        handle_dash()
    elif is_jumping:
        handle_jump(delta)
    else:
        handle_general(delta)
    
    if stamina < 60:
        stamina += 1
    
    move_and_slide()
    
