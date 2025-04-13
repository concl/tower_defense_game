extends Entity

class_name Player

@onready var sprites: Node2D = $Sprites
@onready var player_sprite: AnimatedSprite2D = $Sprites/PlayerSprite
@onready var front_sprite: AnimatedSprite2D = $Sprites/FrontSprite
@onready var back_sprite: AnimatedSprite2D = $Sprites/BackSprite


const CAR_LASER = preload("res://scenes/entities/projectiles/car_laser.tscn")

enum {
    SHOTGUN=0,
    MG=1,
    RL=2,
}

# Parameters
var dash_speed = 1200
var dash_frames = 12

var jump_frames = 45
var jump_accel = 40

var invincible_frames = 60

var SPEED = 400
var acceleration = 120

var max_stamina = 90

var weapon_cooldowns = Vector3i(60, 12, 120)

# State
var stamina = 90

var is_dashing = false
var is_jumping = false

var jump_progress = 0

var invincible_progress = 0

var dash_direc = Vector2()
var dash_progress = 0

var move_direc = Vector2()

var current_weapon = SHOTGUN
var cooldown_progress = Vector3i(0,0,0)
var ammo = Vector3i(12, 90, 10)

# Animation
var current_animation = "idle"

func die():
    Globals.trigger_death()

func is_mouse_over_ui() -> bool:
    var hovered_control = get_viewport().gui_get_hovered_control()
    return hovered_control is Button

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

func handle_attack():
    
    if current_weapon == SHOTGUN and ammo[SHOTGUN] > 0:
        ammo[SHOTGUN] -= 1
        cooldown_progress[SHOTGUN] = weapon_cooldowns[SHOTGUN]
        for x in range(10):
            var laser = CAR_LASER.instantiate()
            var mouse_pos = get_global_mouse_position()
            
            var direction = mouse_pos - self.global_position
            if direction.length() != 0:
                direction = direction.normalized()
            else:
                direction = Vector2(1,0)
            
            var random_angle = randf_range(-0.1, 0.1)
            direction = direction.rotated(random_angle)
            laser.linear_velocity = direction * 2000
            laser.global_position = self.global_position
            laser.rotation = atan2(direction.y, direction.x)
            get_tree().current_scene.add_child(laser)
    elif current_weapon == MG and ammo[MG] > 0:
        ammo[MG] -= 1
        cooldown_progress[MG] = weapon_cooldowns[MG]
        var laser = CAR_LASER.instantiate()
        var mouse_pos = get_global_mouse_position()
        
        var direction = mouse_pos - self.global_position
        if direction.length() != 0:
            direction = direction.normalized()
        else:
            direction = Vector2(1,0)
        
        var random_angle = randf_range(-0.05, 0.05)
        direction = direction.rotated(random_angle)
        laser.linear_velocity = direction * 2000
        laser.global_position = self.global_position
        laser.rotation = atan2(direction.y, direction.x)
        get_tree().current_scene.add_child(laser)


func handle_sprites():
    
    # Handle looking
    var mouse_pos = get_global_mouse_position()
    var relative_pos = mouse_pos - self.global_position
    
    if !is_dashing:
        if relative_pos.y <= relative_pos.x and relative_pos.y >= -relative_pos.x:
            sprites.scale.x = -abs(sprites.scale.x)  # Flip horizontally if on the left side
            player_sprite.show()
            front_sprite.hide()
            back_sprite.hide()
        elif relative_pos.y >= relative_pos.x and relative_pos.y >= -relative_pos.x:
            sprites.scale.x = abs(sprites.scale.x)
            player_sprite.hide()
            front_sprite.show()
            back_sprite.hide()
        elif relative_pos.y >= relative_pos.x and relative_pos.y <= -relative_pos.x:
            sprites.scale.x = abs(sprites.scale.x)
            player_sprite.show()
            front_sprite.hide()
            back_sprite.hide()
        else:
            sprites.scale.x = abs(sprites.scale.x)
            player_sprite.hide()
            front_sprite.hide()
            back_sprite.show()
    
    var run_check = move_direc.length() > 0
    
    if !run_check and !is_dashing and !is_jumping and current_animation != "idle":
        current_animation = "idle"
        player_sprite.play("idle")
        front_sprite.play("idle")
        back_sprite.play("idle")
    
    if run_check and !is_dashing and !is_jumping and current_animation != "run":
        current_animation = "run"
        player_sprite.play("run")
        front_sprite.play("run")
        back_sprite.play("run")
        
    
    if is_jumping and current_animation != "jump":
        current_animation = "jump"
        player_sprite.play("jump")
        front_sprite.play("jump")
        back_sprite.play("jump")
    
    if is_dashing and current_animation != "dash":
        current_animation = "dash"
        player_sprite.play("dash")
        front_sprite.play("dash")
        back_sprite.play("dash")
        
        if dash_direc.x < 0:
            sprites.scale.x = abs(sprites.scale.x)
            player_sprite.show()
            front_sprite.hide()
            back_sprite.hide()
        elif dash_direc.x > 0:
            sprites.scale.x = -abs(sprites.scale.x)
            player_sprite.show()
            front_sprite.hide()
            back_sprite.hide()
        else:
            if dash_direc.y > 0:
                player_sprite.hide()
                front_sprite.show()
                back_sprite.hide()
            else:
                player_sprite.hide()
                front_sprite.hide()
                back_sprite.show()


func handle_input(delta: float):
    
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
    
    if Input.is_action_just_pressed("dash") \
    and !is_dashing \
    and !is_jumping \
    and move_direc.length() > 0 \
    and stamina >= 60:
        stamina -= 60
        is_dashing = true
        dash_direc = move_direc
        dash_progress = dash_frames
    
    if Input.is_action_just_pressed("jump") and !is_jumping and stamina >= 30:
        stamina -= 30
        is_jumping = true
        is_dashing = false
        dash_progress = 0
        dash_direc = Vector2()
        jump_progress = jump_frames
    
    if Input.is_action_just_pressed("next_weapon"):
        current_weapon += 1
        current_weapon %= 2
    
    if Input.is_action_just_pressed("prev_weapon"):
        current_weapon -= 1
        if current_weapon < 0:
            current_weapon = 1
        
    
    if Input.is_action_pressed("attack") and cooldown_progress[current_weapon] == 0  and !is_mouse_over_ui():
        handle_attack()
    

func _physics_process(delta: float) -> void:
    handle_input(delta)
    
    handle_sprites()
    
    if is_dashing:
        handle_dash()
    elif is_jumping:
        handle_jump(delta)
    else:
        handle_general(delta)
    
    
    cooldown_progress -= Vector3i(1,1,1)
    cooldown_progress = cooldown_progress.max(Vector3i())
    
    if stamina < max_stamina:
        stamina += 1
    
    move_and_slide()

func _ready():
    health = 100  
