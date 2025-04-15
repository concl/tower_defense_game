extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const LASANGA_BALL = preload("res://scenes/entities/projectiles/lasagna.tscn")
const SHOCKWAVE = preload("res://scenes/entities/projectiles/shockwave.tscn")

const TRACK = false
const GARF_SPEED = 180

var stamina = 240
var state_duration = 15
var shooting_state = 0
var state = 0

var jump_target = null

# State
# walk towards player
var is_bouncing = true
# leaps to player, lurp position to a predicited place baased on player's current velocity, falls, and creates a shockwave
var is_jumping = false
# launches lasagna in a circle
var is_shooting = false

func _ready():
    health = 2000
    Globals.ui.boss_battle(self)

func _physics_process(delta: float) -> void:
    stamina += 1
    stamina = min(stamina, 240)
    var player = get_tree().get_first_node_in_group("Player")
    var direction = player.global_position - global_position
    
    if direction.y >= 30:
        z_index = 0
    else:
        z_index = 2
    
    if direction.length() != 0:
        direction = direction.normalized()
    else:
        direction = Vector2(1,0)
    
    if state_duration == 0:
        handle_state()
        handle_animation()
    else:
        state_duration -= 1
    
    if is_bouncing:
        position += direction * GARF_SPEED * delta
    
    if is_shooting and shooting_state == 0:
        shooting_state = 30
        shoot()
    shooting_state -= 1
    shooting_state = max(0, shooting_state)
    
    if is_jumping:
        position = position.lerp(jump_target, delta * 4)
        handle_jump()

func handle_state():
    var rng = RandomNumberGenerator.new()
    
    var player = get_tree().get_first_node_in_group("Player")
    var direction = player.global_position - global_position
    
    if direction.length() >= 200:
        state = rng.randi_range(0, 2)
    elif direction.length() >= 60:
        state = rng.randi_range(0, 1)
    else:
        state = -1
        is_bouncing = false
        is_shooting = false
        is_jumping = false
    
    if state == 2 and stamina >= 240:
        
        stamina -= 240
        is_bouncing = false
        is_shooting = false
        is_jumping = true
        jump_target = player.global_position
        
        
        state_duration = 26 # 13/12 frames
    elif state == 1:
        is_bouncing = false
        is_shooting = true
        is_jumping = false
        state_duration = 30
    elif state == 0:
        is_bouncing = true
        is_shooting = false
        is_jumping = false
        state_duration = 15 # 5/7 frames

func handle_animation():
    if is_bouncing and animated_sprite_2d.animation != "bounce":
        animated_sprite_2d.play("bounce")
    elif is_jumping and animated_sprite_2d.animation != "jump":
        animated_sprite_2d.play("jump")


func handle_jump():
    if state_duration == 0:
        # landed on group and send shockwave
        var shock = SHOCKWAVE.instantiate()
        shock.global_position = self.global_position
        get_tree().current_scene.add_child(shock)

func shoot():
    animated_sprite_2d.play("shoot")
    var start_angle = randf_range(0,2 * PI)
    
    var player = get_tree().get_first_node_in_group("Player")
    var direction = player.global_position - self.global_position
    if direction.length() != 0:
        direction = direction.normalized()
    else:
        direction = Vector2(1,0)
    
    direction = direction.rotated(start_angle)
    
    for x in range(24):
        var lasanga = LASANGA_BALL.instantiate()
        direction = direction.rotated(2 * PI / 20)
        lasanga.linear_velocity = direction * 500
        lasanga.global_position = self.global_position
        lasanga.rotation = atan2(direction.y, direction.x)
        get_tree().current_scene.add_child(lasanga)
